<?php
// Copyright (C) 2007 Rod Roark <rod@sunsetsystems.com>
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.

require_once(dirname(__FILE__) . "/classes/Address.class.php");
require_once(dirname(__FILE__) . "/classes/InsuranceCompany.class.php");
require_once(dirname(__FILE__) . "/sql-ledger.inc");
require_once(dirname(__FILE__) . "/invoice_summary.inc.php");

// This enforces the X12 Basic Character Set. Page A2.
//
function x12clean($str) {
  return preg_replace('/[^A-Z0-9!"\\&\'()+,\\-.\\/;?= ]/', '', strtoupper($str));
}

class Claim {

  var $pid;               // patient id
  var $encounter_id;      // encounter id
  var $procs;             // array of procedure rows from billing table
  var $x12_partner;       // row from x12_partners table
  var $encounter;         // row from form_encounter table
  var $facility;          // row from facility table
  var $billing_facility;  // row from facility table
  var $provider;          // row from users table (rendering provider)
  var $referrer;          // row from users table (referring provider)
  var $insurance_numbers; // row from insurance_numbers table for current payer
  var $patient_data;      // row from patient_data table
  var $billing_options;   // row from form_misc_billing_options table
  var $invoice;           // result from get_invoice_summary()
  var $payers;            // array of arrays, for all payers

  // Constructor. Loads relevant database information.
  //
  function Claim($pid, $encounter_id) {
    $this->pid = $pid;
    $this->encounter_id = $encounter_id;
    $this->procs = array();

    // Sort by procedure timestamp in order to get some consistency.  In particular
    // we determine the provider from the first procedure in this array.
    $sql = "SELECT * FROM billing WHERE " .
      "encounter = '{$this->encounter_id}' AND pid = '{$this->pid}' AND " .
      "(code_type = 'CPT4' OR code_type = 'HCPCS') AND " .
      "activity = '1' ORDER BY date, id";
    $res = sqlStatement($sql);
    while ($row = sqlFetchArray($res)) {
      if (!$row['units']) $row['units'] = 1;
      // Consolidate duplicate procedure codes.
      foreach ($this->procs as $key => $trash) {
        if ($this->procs[$key]['code'] == $row['code']) {
          $this->procs[$key]['units'] += $row['units'];
          $this->procs[$key]['fee']   += $row['fee'];
          continue 2; // skip to next table row
        }
      }
      $this->procs[] = $row;
    }

    $sql = "SELECT * FROM x12_partners WHERE " .
      "id = '" . $this->procs[0]['x12_partner_id'] . "'";
    $this->x12_partner = sqlQuery($sql);

    $sql = "SELECT * FROM form_encounter WHERE " .
      "pid = '{$this->pid}' AND " .
      "encounter = '{$this->encounter_id}'";
    $this->encounter = sqlQuery($sql);

    $sql = "SELECT * FROM facility WHERE " .
      "name = '" . addslashes($this->encounter['facility']) . "' " .
      "ORDER BY id LIMIT 1";
    $this->facility = sqlQuery($sql);

    $sql = "SELECT * FROM users WHERE " .
      "id = '" . $this->procs[0]['provider_id'] . "'";
    $this->provider = sqlQuery($sql);

    $sql = "SELECT * FROM facility " .
      "ORDER BY billing_location DESC, id ASC LIMIT 1";
    $this->billing_facility = sqlQuery($sql);

    $sql = "SELECT * FROM insurance_numbers WHERE " .
      "(insurance_company_id = '" . $this->procs[0]['payer_id'] .
      "' OR insurance_company_id is NULL) AND " .
      "provider_id = '" . $this->provider['id'] .
      "' order by insurance_company_id DESC LIMIT 1";
    $this->insurance_numbers = sqlQuery($sql);

    $sql = "SELECT * FROM patient_data WHERE " .
      "pid = '{$this->pid}' " .
      "ORDER BY id LIMIT 1";
    $this->patient_data = sqlQuery($sql);

    $sql = "SELECT fpa.* FROM forms JOIN form_misc_billing_options AS fpa " .
      "ON fpa.id = forms.form_id WHERE " .
      "forms.encounter = '{$this->encounter_id}' AND " .
      "forms.pid = '{$this->pid}' AND " .
      "forms.formdir = 'misc_billing_options' " .
      "ORDER BY forms.date";
    $this->billing_options = sqlQuery($sql);

    $sql = "SELECT * FROM users WHERE " .
      "id = '" . $this->patient_data['providerID'] . "'";
    $this->referrer = sqlQuery($sql);
    if (!$this->referrer) $this->referrer = array();

    // Create the $payers array.  This contains data for all insurances
    // with the current one always at index 0, and the others in payment
    // order starting at index 1.
    //
    $this->payers = array();
    $this->payers[0] = array();
    $dres = sqlStatement("SELECT * FROM insurance_data WHERE " .
      "pid = '{$this->pid}' AND provider != '' " .
      "ORDER BY type");
    while ($drow = sqlFetchArray($dres)) {
      $ins = ($drow['provider'] == $this->procs[0]['payer_id']) ?
        0 : count($this->payers);
      $crow = sqlQuery("SELECT * FROM insurance_companies WHERE " .
        "id = '" . $drow['provider'] . "'");
      $orow = new InsuranceCompany($drow['provider']);
      $this->payers[$ins] = array();
      $this->payers[$ins]['data']    = $drow;
      $this->payers[$ins]['company'] = $crow;
      $this->payers[$ins]['object']  = $orow;
    }

    // Get payment and adjustment details if there are any previous payers.
    //
    $this->invoice = array();
    if ($this->payerSequence() != 'P') {
      SLConnect();
      $arres = SLQuery("select id from ar where invnumber = " .
        "'{$this->pid}.{$this->encounter_id}'");
      if ($sl_err) die($sl_err);
      $arrow = SLGetRow($arres, 0);
      if ($arrow) {
        $this->invoice = get_invoice_summary($arrow['id'], true);
      }
      SLClose();
    }

  } // end constructor

  // Return an array of adjustments from the designated payer for the
  // designated procedure code, or for the claim level.  For each
  // adjustment give date, group code, reason code and amount.
  //
  function payerAdjustments($ins, $code='Claim') {
    $aadj = array();
    $inslabel = ($this->payerSequence($ins) == 'S') ? 'Ins2' : 'Ins1';

    // For payments, source always starts with "Ins" or "Pt".
    // Nonzero adjustment reason examples:
    //   Ins1 adjust code 42 (Charges exceed our fee schedule or maximum allowable amount)
    //   Ins1 adjust code 45 (Charges exceed your contracted/ legislated fee arrangement)
    //   Ins1 adjust code 97 (Payment is included in the allowance for another service/procedure)
    //   Ins1 adjust code A2 (Contractual adjustment)
    //   Ins adjust Ins1
    //   adjust code 42
    // Zero adjustment reason examples:
    //   Co-pay: 25.00
    //   Coinsurance: 11.46  (code 2)
    //   To deductible: 0.22 (code 1)
    //   To copay (this seems to be meaningless)

    if (!empty($this->invoice[$code])) {
      foreach ($this->invoice[$code]['dtl'] as $key => $value) {
        $date = str_replace('-', '', trim(substr($key, 0, 10)));
        if ($date && $value['pmt'] == 0) {
          $rsn = $value['rsn'];
          $chg = 0 - $value['chg']; // adjustments are negative charges

          $gcode = 'CO'; // default group code = contractual obligation
          $rcode = '45'; // default reason code = max fee exceeded (code 42 is obsolete)

          if (preg_match("/Ins adjust $inslabel/i", $rsn, $tmp)) {
          }
          else if (preg_match("/$inslabel adjust code (\S+)/i", $rsn, $tmp)) {
            $rcode = $tmp[1];
          }
          else if (preg_match("/$inslabel/i", $rsn, $tmp)) {
          }
          else if ($inslabel == 'Ins1') {
            if (preg_match("/\$adjust code (\S+)/i", $rsn, $tmp)) {
              $rcode = $tmp[1];
            }
            else if ($chg) {
            }
            else if (preg_match("/Co-pay: (\S+)/i", $rsn, $tmp) ||
              preg_match("/Coinsurance: (\S+)/i", $rsn, $tmp)) {
              $gcode = 'PR';
              $rcode = '2';
              $chg = $tmp[1];
            }
            else if (preg_match("/To deductible: (\S+)/i", $rsn, $tmp)) {
              $gcode = 'PR';
              $rcode = '1';
              $chg = $tmp[1];
            }
            else {
              continue; // there is no adjustment amount anywhere
            }
          }
          else {
            continue; // we are not Ins1 and there is no chg so forget it
          }

          $aadj[] = array($date, $gcode, $rcode, sprintf('%.2f', $chg));

        } // end if
      } // end foreach
    } // end if

    return $aadj;
  }

  // Return the amount and date paid by the designated prior payer.
  // If $code is specified then only that procedure code is selected.
  //
  function payerPaidAmount($ins, $code='') {
    $inslabel = ($this->payerSequence($ins) == 'S') ? 'Ins2' : 'Ins1';
    $amount = 0;
    $date = '';
    foreach($this->invoice as $codekey => $codeval) {
      if ($code && $codekey != $code) continue;
      foreach ($codeval['dtl'] as $key => $value) {
        if (preg_match("/$inslabel/i", $value['src'], $tmp)) {
          if (!$date) $date = str_replace('-', '', trim(substr($key, 0, 10)));
          $amount += $value['pmt'];
        }
      }
    }
    return array(sprintf('%.2f', $amount), $date);
  }

  // Return the amount already paid by the patient.
  //
  function patientPaidAmount() {
    $amount = 0;
    foreach($this->invoice as $codekey => $codeval) {
      foreach ($codeval['dtl'] as $key => $value) {
        if (!preg_match("/Ins/i", $value['src'], $tmp)) {
          $amount += $value['pmt'];
        }
      }
    }
    return sprintf('%.2f', $amount);
  }

  // Return invoice total, including adjustments but not payments.
  //
  function invoiceTotal() {
    $amount = 0;
    foreach($this->invoice as $codekey => $codeval) {
      $amount += $codeval['chg'];
    }
    return sprintf('%.2f', $amount);
  }

  // Number of procedures in this claim.
  function procCount() {
    return count($this->procs);
  }

  // Number of payers for this claim. Ranges from 1 to 3.
  function payerCount() {
    return count($this->payers);
  }

  function x12gsversionstring() {
    return x12clean(trim($this->x12_partner['x12_version']));
  }

  function x12gssenderid() {
    $tmp = $this->x12_partner['x12_sender_id'];
    while (strlen($tmp) < 15) $tmp .= " ";
    return $tmp;
  }

  function x12gsreceiverid() {
    $tmp = $this->x12_partner['x12_receiver_id'];
    while (strlen($tmp) < 15) $tmp .= " ";
    return $tmp;
  }

  function cliaCode() {
    return x12clean(trim($this->facility['domain_identifier']));
  }

  function billingFacilityName() {
    return x12clean(trim($this->billing_facility['name']));
  }

  function billingFacilityStreet() {
    return x12clean(trim($this->billing_facility['street']));
  }

  function billingFacilityCity() {
    return x12clean(trim($this->billing_facility['city']));
  }

  function billingFacilityState() {
    return x12clean(trim($this->billing_facility['state']));
  }

  function billingFacilityZip() {
    return x12clean(trim($this->billing_facility['postal_code']));
  }

  function billingFacilityETIN() {
    return x12clean(trim(str_replace('-', '', $this->billing_facility['federal_ein'])));
  }

  function billingFacilityNPI() {
    return x12clean(trim($this->billing_facility['facility_npi']));
  }

  function billingContactName() {
    return x12clean(trim($this->billing_facility['attn']));
  }

  function billingContactPhone() {
    if (preg_match("/([2-9]\d\d)\D*(\d\d\d)\D*(\d\d\d\d)/",
      $this->billing_facility['phone'], $tmp))
    {
      return $tmp[1] . $tmp[2] . $tmp[3];
    }
    return '';
  }

  function facilityName() {
    return x12clean(trim($this->facility['name']));
  }

  function facilityStreet() {
    return x12clean(trim($this->facility['street']));
  }

  function facilityCity() {
    return x12clean(trim($this->facility['city']));
  }

  function facilityState() {
    return x12clean(trim($this->facility['state']));
  }

  function facilityZip() {
    return x12clean(trim($this->facility['postal_code']));
  }

  function facilityETIN() {
    return x12clean(trim(str_replace('-', '', $this->facility['federal_ein'])));
  }

  function facilityNPI() {
    return x12clean(trim($this->facility['facility_npi']));
  }

  function facilityPOS() {
    return x12clean(trim($this->facility['pos_code']));
  }

  function clearingHouseName() {
    return x12clean(trim($this->x12_partner['name']));
  }

  function clearingHouseETIN() {
    return x12clean(trim(str_replace('-', '', $this->x12_partner['id_number'])));
  }

  function providerNumberType() {
    return $this->insurance_numbers['provider_number_type'];
  }

  function providerNumber() {
    return x12clean(trim(str_replace('-', '', $this->insurance_numbers['provider_number'])));
  }

  // Returns 'P', 'S' or 'T'.
  //
  function payerSequence($ins=0) {
    return strtoupper(substr($this->payers[$ins]['data']['type'], 0, 1));
  }

  // Returns the HIPAA code of the patient-to-subscriber relationship.
  //
  function insuredRelationship($ins=0) {
    $tmp = strtolower($this->payers[$ins]['data']['subscriber_relationship']);
    if ($tmp == 'self'  ) return '18';
    if ($tmp == 'spouse') return '01';
    if ($tmp == 'child' ) return '19';
    if ($tmp == 'other' ) return 'G8';
    return $tmp; // should not happen
  }

  function insuredTypeCode($ins=0) {
    if ($this->claimType($ins) == 'MB' && $this->payerSequence($ins) != 'P')
      return '12'; // medicare secondary working aged beneficiary or
                   // spouse with employer group health plan
    return '';
  }

  // Is the patient also the subscriber?
  //
  function isSelfOfInsured($ins=0) {
    $tmp = strtolower($this->payers[$ins]['data']['subscriber_relationship']);
    return ($tmp == 'self');
  }

  function groupNumber($ins=0) {
    return x12clean(trim($this->payers[$ins]['data']['group_number']));
  }

  function groupName($ins=0) {
    return x12clean(trim($this->payers[$ins]['data']['subscriber_employer']));
  }

  function claimType($ins=0) {
    return $this->payers[$ins]['object']->get_freeb_claim_type();
  }

  function insuredLastName($ins=0) {
    return x12clean(trim($this->payers[$ins]['data']['subscriber_lname']));
  }

  function insuredFirstName($ins=0) {
    return x12clean(trim($this->payers[$ins]['data']['subscriber_fname']));
  }

  function insuredMiddleName($ins=0) {
    return x12clean(trim($this->payers[$ins]['data']['subscriber_mname']));
  }

  function policyNumber($ins=0) { // "ID"
    return x12clean(trim($this->payers[$ins]['data']['policy_number']));
  }

  function insuredStreet($ins=0) {
    return x12clean(trim($this->payers[$ins]['data']['subscriber_street']));
  }

  function insuredCity($ins=0) {
    return x12clean(trim($this->payers[$ins]['data']['subscriber_city']));
  }

  function insuredState($ins=0) {
    return x12clean(trim($this->payers[$ins]['data']['subscriber_state']));
  }

  function insuredZip($ins=0) {
    return x12clean(trim($this->payers[$ins]['data']['subscriber_postal_code']));
  }

  function insuredDOB($ins=0) {
    return str_replace('-', '', $this->payers[$ins]['data']['subscriber_DOB']);
  }

  function insuredSex($ins=0) {
    return strtoupper(substr($this->payers[$ins]['data']['subscriber_sex'], 0, 1));
  }

  function payerName($ins=0) {
    return x12clean(trim($this->payers[$ins]['company']['name']));
  }

  function payerStreet($ins=0) {
    $tmp = $this->payers[$ins]['object'];
    $tmp = $tmp->get_address();
    return x12clean(trim($tmp->get_line1()));
  }

  function payerCity($ins=0) {
    $tmp = $this->payers[$ins]['object'];
    $tmp = $tmp->get_address();
    return x12clean(trim($tmp->get_city()));
  }

  function payerState($ins=0) {
    $tmp = $this->payers[$ins]['object'];
    $tmp = $tmp->get_address();
    return x12clean(trim($tmp->get_state()));
  }

  function payerZip($ins=0) {
    $tmp = $this->payers[$ins]['object'];
    $tmp = $tmp->get_address();
    return x12clean(trim($tmp->get_zip()));
  }

  function payerID($ins=0) {
    return x12clean(trim($this->payers[$ins]['company']['cms_id']));
  }

  function patientLastName() {
    return x12clean(trim($this->patient_data['lname']));
  }

  function patientFirstName() {
    return x12clean(trim($this->patient_data['fname']));
  }

  function patientMiddleName() {
    return x12clean(trim($this->patient_data['mname']));
  }

  function patientStreet() {
    return x12clean(trim($this->patient_data['street']));
  }

  function patientCity() {
    return x12clean(trim($this->patient_data['city']));
  }

  function patientState() {
    return x12clean(trim($this->patient_data['state']));
  }

  function patientZip() {
    return x12clean(trim($this->patient_data['postal_code']));
  }

  function patientDOB() {
    return str_replace('-', '', $this->patient_data['DOB']);
  }

  function patientSex() {
    return strtoupper(substr($this->patient_data['sex'], 0, 1));
  }

  function cptCode($prockey) {
    return x12clean(trim($this->procs[$prockey]['code']));
  }

  function cptModifier($prockey) {
    return x12clean(trim($this->procs[$prockey]['modifier']));
  }

  function cptCharges($prockey) {
    return x12clean(trim($this->procs[$prockey]['fee']));
  }

  function cptUnits($prockey) {
    if (empty($this->procs[$prockey]['units'])) return '1';
    return x12clean(trim($this->procs[$prockey]['units']));
  }

  // NDC drug ID.
  function cptNDCID($prockey) {
    $ndcinfo = $this->procs[$prockey]['ndc_info'];
    if (preg_match('/^N4(\S+)\s+(\S\S)(.*)/', $ndcinfo, $tmp)) {
      $ndc = $tmp[1];
      if (preg_match('/^(\d+)-(\d+)-(\d+)$/', $ndc, $tmp)) {
        return sprintf('%05d-%04d-%02d', $tmp[1], $tmp[2], $tmp[3]);
      }
      return x12clean($ndc); // format is bad but return it anyway
    }
    return '';
  }

  // NDC drug unit of measure code.
  function cptNDCUOM($prockey) {
    $ndcinfo = $this->procs[$prockey]['ndc_info'];
    if (preg_match('/^N4(\S+)\s+(\S\S)(.*)/', $ndcinfo, $tmp))
      return x12clean($tmp[2]);
    return '';
  }

  // NDC drug number of units.
  function cptNDCQuantity($prockey) {
    $ndcinfo = $this->procs[$prockey]['ndc_info'];
    if (preg_match('/^N4(\S+)\s+(\S\S)(.*)/', $ndcinfo, $tmp))
      return x12clean($tmp[3]);
    return '';
  }

  function onsetDate() {
    return str_replace('-', '', substr($this->encounter['onset_date'], 0, 10));
  }

  function serviceDate() {
    return str_replace('-', '', substr($this->encounter['date'], 0, 10));
  }

  function priorAuth() {
    return x12clean(trim($this->billing_options['prior_auth_number']));
  }

  // Returns an array of unique primary diagnoses.  Periods are stripped.
  function diagArray() {
    $da = array();
    foreach ($this->procs as $row) {
      $tmp = explode(':', $row['justify']);
      if (count($tmp)) {
        $diag = str_replace('.', '', $tmp[0]);
        $da[$diag] = $diag;
      }
    }
    return $da;
  }

  // Compute the 1-relative index in diagArray for the given procedure.
  function diagIndex($prockey) {
    $da = $this->diagArray();
    $tmp = explode(':', $this->procs[$prockey]['justify']);
    if (empty($tmp)) return '';
    $diag = str_replace('.', '', $tmp[0]);
    $i = 0;
    foreach ($da as $value) {
      ++$i;
      if ($value == $diag) return $i;
    }
    return '';
  }

  function providerLastName() {
    return x12clean(trim($this->provider['lname']));
  }

  function providerFirstName() {
    return x12clean(trim($this->provider['fname']));
  }

  function providerMiddleName() {
    return x12clean(trim($this->provider['mname']));
  }

  function providerNPI() {
    return x12clean(trim($this->provider['npi']));
  }

  function providerUPIN() {
    return x12clean(trim($this->provider['upin']));
  }

  function providerSSN() {
    return x12clean(trim(str_replace('-', '', $this->provider['federaltaxid'])));
  }

  function referrerLastName() {
    return x12clean(trim($this->referrer['lname']));
  }

  function referrerFirstName() {
    return x12clean(trim($this->referrer['fname']));
  }

  function referrerMiddleName() {
    return x12clean(trim($this->referrer['mname']));
  }

  function referrerNPI() {
    return x12clean(trim($this->referrer['npi']));
  }

  function referrerUPIN() {
    return x12clean(trim($this->referrer['upin']));
  }

  function referrerSSN() {
    return x12clean(trim(str_replace('-', '', $this->referrer['federaltaxid'])));
  }
}
?>
