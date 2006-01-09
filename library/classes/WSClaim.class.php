<?php

require_once (dirname(__FILE__) . "/WSWrapper.class.php");
include_once (dirname(__FILE__) . "/../sqlconf.php");
include_once (dirname(__FILE__) . "/../sql.inc");
include_once (dirname(__FILE__) . "/../../includes/config.php");

class WSClaim extends WSWrapper{

	var $patient_id;
	var $foreign_provider_id;
	var $foreign_patient_id;
	var $payer_id;
	var $encounter;
	var $foreign_payer_id;
	var $claim;
	var $_db;

	function WSClaim($patient_id, $encounter) {
		if (!is_numeric($patient_id) && is_numeric($encounter)) return;

		parent::WSWrapper(null,false);

		$this->patient_id = $patient_id;
		$this->encounter = $encounter;
		$this->claim = null;
		$this->_db = $GLOBALS['adodb']['db'];
		if (!$this->_config['enabled']) return;

		if ($this->load_claim()) {
			$function['ezybiz.add_invoice'] = array(new xmlrpcval($this->claim,"struct"));
			$this->send($function);
		}

		//print_r($this->claim);

	}

	function load_claim() {
		if (!$this->load_patient_foreign_id() ||
			!$this->load_payer_foreign_id() ||
			!$this->load_provider_foreign_id() )
			return false;
		$invoice_info = array();

		// Create invoice notes for the new invoice that list the patient's
		// insurance plans.  This is so that when payments are posted, the user
		// can easily see if a secondary claim needs to be submitted.
		//
		$insnotes = "";
		$insno = 0;
		foreach (array("primary", "secondary", "tertiary") as $instype) {
			++$insno;
			$sql = "SELECT insurance_companies.name " .
				"FROM insurance_data, insurance_companies WHERE " .
				"insurance_data.pid = " . $this->patient_id . " AND " .
				"insurance_data.type = '$instype' AND " .
				"insurance_companies.id = insurance_data.provider " .
				"LIMIT 1";
			$result = $this->_db->Execute($sql);
			if ($result && !$result->EOF && $result->fields['name']) {
				if ($insnotes) $insnotes .= "\n";
				$insnotes .= "Ins$insno: " . $result->fields['name'];
			}
		}
		$invoice_info['notes'] = $insnotes;

		$sql = "SELECT b.*, CONCAT(pd.fname,' ',pd.mname,' ',pd.lname) as patient_name " .
			"FROM billing as b LEFT JOIN patient_data as pd on b.pid=pd.pid where " .
			"b.encounter = '" . $this->encounter ."' AND b.pid = '" . $this->patient_id .
			"' AND b.billed = 1 AND b.activity != '0' AND authorized = '1'";

		$result = $this->_db->Execute($sql);

		$invoice_info['salesman'] = $this->foreign_provider_id;
		$invoice_info['customerid'] = $this->foreign_patient_id;
		$invoice_info['payer_id'] = $this->foreign_payer_id;
//	$invoice_info['invoicenumber'] = $this->patient_id . "000" . $this->encounter;
		$invoice_info['invoicenumber'] = $this->patient_id . "." . $this->encounter;

		$counter = 0;
		$total = 0;
		$patient_info = array();
		$payer_info = array();

		while ($result && !$result->EOF) {

//		if ($result->fields['process_date'] == null) {
//			//don't sync a claim that has not been processed, they may just want to mark this as billed
//				return false;
//		}

      // The above is silly.  If we don't want to sync, why are we here?
      // All bills should be in the accounting system, and mark-as-cleared
      // is the only reasonable way to process cash-only patients.
      //
      $process_date = ($result->fields['process_date'] == null) ?
        date("m-d-Y") :
        date("m-d-Y", strtotime($result->fields['process_date']));

			if ($counter == 0) {
				//unused but supported by ezybiz, helpful in debugging
				// actualy the dosdate can be used if you want that as the invoice date
				$invoice_info['customer'] = $result->fields['patient_name'];
				$invoice_info['invoicedate'] = $process_date;
				$invoice_info['duedate'] = $process_date;
				$invoice_info['items'] = array();
				$invoice_info['dosdate'] = date("m-d-Y",strtotime($result->fields['date']));
			}

			$tii = array();
			//This is how we set the line items for the invoice, using codes from our encounter
			//if ($result->fields['code_type'] == "CPT4" || $result->fields['code_type'] == "HCPCS") {
			//if( $result->fields['code_type'] != "ICD9" ) {
			if( $result->fields['code_type'] == "COPAY")
			{
				$patient_info['payment_amount'] += sprintf("%01.2f",$result->fields['fee']);
			}
			else
			{
				$payer_info['payment_amount'] += sprintf("%01.2f",$result->fields['fee']);
			}

			$tii['maincode'] = $result->fields['code'];
			$tii['itemtext'] = $result->fields['code_type'] .":" .
        $result->fields['code'] . " " . $result->fields['code_text'] . " " .
        $result->fields['justify'];

//		$tii['qty'] = $result->fields['units'];
//		if (!$tii['qty'] > 0) {
//			$tii['qty'] = 1;
//		}
      $tii['qty'] = 1;

			$tii['price'] = sprintf("%01.2f",$result->fields['fee']);
			$total += $tii['price'];
			$tii['glaccountid'] = $this->_config['income_acct'];
			$invoice_info['items'][] = $tii;

			$result->MoveNext();
			$counter++;
		}

		for($counter = 0; $counter < 2; $counter++)
		{
			$fee = 0;
			$billto = 0;
			if($counter == 0)
			{
				$fee = $patient_info['payment_amount'];
				$billto = $this->foreign_patient_id;
			}
			else
			{
				$fee = $payer_info['payment_amount'];
				$billto = $this->foreign_payer_id;
			}
			$invoice_info["invoiceid$counter"] = $this->patient_id . "000" . $this->encounter;
			$invoice_info["amount$counter"] = $fee;
			$invoice_info["invoicenumber$counter"] = $this->patient_id . "000" . $this->encounter;
			$invoice_info["interest$counter"] = 0;
			$invoice_info["billtoid$counter"] = $billto;
		}
		$invoice_info['subtotal'] = sprintf("%01.2f",$total);
		$invoice_info['total'] = sprintf("%01.2f",$total);

		$this->claim = $invoice_info;
		return true;
	}

	function load_provider_foreign_id() {
		$sql = "SELECT foreign_id from integration_mapping as im LEFT JOIN billing as b on im.local_id=b.provider_id where encounter = '" . $this->encounter . "' and b.pid = '" . $this->patient_id . "' and im.local_table='users' and im.foreign_table='salesman'";
		$result = $this->_db->Execute($sql);
		if($result && !$result->EOF) {
				$this->foreign_provider_id = $result->fields['foreign_id'];
				return true;
		}
		else {
			echo "Entry has not been previously sent to external system or no entry was found for them in the integration mapping, could not send claim. Provider: '" . $this->patient_id . "'<br>";
			return false;
		}
	}

	function load_patient_foreign_id() {
		$sql = "SELECT foreign_id from integration_mapping as im LEFT JOIN patient_data as pd on im.local_id=pd.id where pd.pid = '" . $this->patient_id . "' and im.local_table='patient_data' and im.foreign_table='customer'";
		$result = $this->_db->Execute($sql);
		if($result && !$result->EOF) {
				$this->foreign_patient_id = $result->fields['foreign_id'];
				return true;
		}
		else {
			echo "Entry has not been previously sent to external system or no entry was found for them in the integration mapping, could not send claim. Patient: '" . $this->patient_id . "'<br>";
			return false;
		}
	}

	function load_payer_foreign_id() {
		$sql = "SELECT payer_id from billing where encounter = '" . $this->encounter . "' and pid = '" . $this->patient_id . "'";
		$result = $this->_db->Execute($sql);
		if($result && !$result->EOF) {
				$this->payer_id = $result->fields['payer_id'];
		}
		else {
			echo "No payer id for this claim could be found";
			return false;
		}
		// See comments in globals.php:
		if ($GLOBALS['insurance_companies_are_not_customers']) {
			$this->foreign_payer_id = $this->payer_id;
		}
		else {
			$sql = "SELECT foreign_id from integration_mapping as im LEFT JOIN billing as b on im.local_id=b.payer_id where b.payer_id = '" . $this->payer_id . "' and im.local_table='insurance_companies' and im.foreign_table='customer'";
			$result = $this->_db->Execute($sql);
			if($result && !$result->EOF) {
				$this->foreign_payer_id = $result->fields['foreign_id'];
			}
			else {
				echo "Entry has not been previously sent to external system or no entry was found for them in the integration mapping, could not send claim. Insurance Company: '" . $this->payer_id . "'<br>";
				return false;
			}
		}
		return true;
	}
}

//$wsc = new WSClaim("3","20040622");

?>