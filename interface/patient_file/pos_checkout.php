<?php
 // Copyright (C) 2006, 2008 Rod Roark <rod@sunsetsystems.com>
 //
 // This program is free software; you can redistribute it and/or
 // modify it under the terms of the GNU General Public License
 // as published by the Free Software Foundation; either version 2
 // of the License, or (at your option) any later version.

 // This module supports a popup window to handle patient checkout
 // as a point-of-sale transaction.  Support for in-house drug sales
 // is included.

 // Important notes about system design:
 //
 // (1) Drug sales may or may not be associated with an encounter;
 //     they are if they are paid for concurrently with an encounter, or
 //     if they are "product" (non-prescription) sales via the Fee Sheet.
 // (2) Drug sales without an encounter will have 20YYMMDD, possibly
 //     with a suffix, as the encounter-number portion of their invoice
 //     number.
 // (3) Payments are saved in SL only, don't mess with the billing table.
 //     See library/classes/WSClaim.class.php for posting code.
 // (4) On checkout, the billing and drug_sales table entries are marked
 //     as billed and so become unavailable for further billing.
 // (5) Receipt printing must be a separate operation from payment,
 //     and repeatable, therefore driven from the SL database and
 //     mirroring the contents of the invoice.

 require_once("../globals.php");
 require_once("$srcdir/acl.inc");
 require_once("$srcdir/patient.inc");
 require_once("$srcdir/sql-ledger.inc");
 require_once("$srcdir/freeb/xmlrpc.inc");
 require_once("$srcdir/freeb/xmlrpcs.inc");
 require_once("../../custom/code_types.inc.php");

 // Get the patient's name and chart number.
 $patdata = getPatientData($pid, 'fname,mname,lname,pubpid,street,city,state,postal_code');

//////////////////////////////////////////////////////////////////////
// The following functions are inline here temporarily, and should be
// moved to an includable module for common use.  In particular
// WSClaim.class.php should be rewritten to use them.
//////////////////////////////////////////////////////////////////////

// Initialize the array of invoice information for posting to the
// accounting system.
//
function invoice_initialize(& $invoice_info, $patient_id, $provider_id,
	$payer_id = 0, $encounter = 0, $dosdate = '')
{
	$db = $GLOBALS['adodb']['db'];

	// Get foreign ID (customer) for patient.
	$sql = "SELECT foreign_id from integration_mapping as im " .
		"LEFT JOIN patient_data as pd on im.local_id=pd.id " .
		"where pd.pid = '" .
		$patient_id .
		"' and im.local_table='patient_data' and im.foreign_table='customer'";
	$result = $db->Execute($sql);
	if($result && !$result->EOF) {
		$foreign_patient_id = $result->fields['foreign_id'];
	}
	else {
		return "Patient '" . $patient_id . "' has not yet been posted to the accounting system.";
	}

	// Get foreign ID (salesman) for provider.
	$sql = "SELECT foreign_id from integration_mapping WHERE " .
		"local_id = $provider_id AND local_table='users' and foreign_table='salesman'";
	$result = $db->Execute($sql);
	if($result && !$result->EOF) {
		$foreign_provider_id = $result->fields['foreign_id'];
	}
	else {
		return "Provider '" . $provider_id . "' has not yet been posted to the accounting system.";
	}

	// Get foreign ID (customer) for insurance payer.
	if ($payer_id && ! $GLOBALS['insurance_companies_are_not_customers']) {
		$sql = "SELECT foreign_id from integration_mapping WHERE " .
			"local_id = $payer_id AND local_table = 'insurance_companies' AND foreign_table='customer'";
		$result = $db->Execute($sql);
		if($result && !$result->EOF) {
			$foreign_payer_id = $result->fields['foreign_id'];
		}
		else {
			return "Payer '" . $payer_id . "' has not yet been posted to the accounting system.";
		}
	} else {
		$foreign_payer_id = $payer_id;
	}

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
			"insurance_data.pid = $patient_id AND " .
			"insurance_data.type = '$instype' AND " .
			"insurance_companies.id = insurance_data.provider " .
			"ORDER BY insurance_data.date DESC LIMIT 1";
		$result = $db->Execute($sql);
		if ($result && !$result->EOF && $result->fields['name']) {
			if ($insnotes) $insnotes .= "\n";
			$insnotes .= "Ins$insno: " . $result->fields['name'];
		}
	}
	$invoice_info['notes'] = $insnotes;

	if (preg_match("/(\d\d\d\d)\D*(\d\d)\D*(\d\d)/", $dosdate, $matches)) {
		$dosdate = $matches[2] . '-' . $matches[3] . '-' . $matches[1];
	} else {
		$dosdate = date("m-d-Y");
	}

	$invoice_info['salesman']   = $foreign_provider_id;
	$invoice_info['customerid'] = $foreign_patient_id;
	$invoice_info['payer_id']   = $foreign_payer_id;
	$invoice_info['invoicenumber'] = $patient_id . "." . $encounter;
	$invoice_info['dosdate'] = $dosdate;
	$invoice_info['items'] = array();
	$invoice_info['total'] = '0.00';

	return '';
}

function invoice_add_line_item(& $invoice_info, $code_type, $code,
	$code_text, $amount, $units=1)
{
  $units = max(1, intval(trim($units)));
  $amount = sprintf("%01.2f", $amount);
  $price = $amount / $units;
  $tmp = sprintf("%01.2f", $price);
  if (abs($price - $tmp) < 0.000001) $price = $tmp;
	$tii = array();
	$tii['maincode'] = $code;
	$tii['itemtext'] = "$code_type:$code";
	if ($code_text) $tii['itemtext'] .= " $code_text";
	// $tii['qty'] = 1;
	// $tii['price'] = sprintf("%01.2f", $amount);
  $tii['qty'] = $units;
  $tii['price'] = $price;
	$tii['glaccountid'] = $GLOBALS['oer_config']['ws_accounting']['income_acct'];
	// $invoice_info['total'] = sprintf("%01.2f", $invoice_info['total'] + $tii['price']);
  $invoice_info['total'] = sprintf("%01.2f", $invoice_info['total'] + $amount);
	$invoice_info['items'][] = $tii;
	return '';
}

function invoice_post(& $invoice_info)
{
	$function['ezybiz.add_invoice'] = array(new xmlrpcval($invoice_info, "struct"));

	list($name, $var) = each($function);
	$f = new xmlrpcmsg($name, $var);

	$c = new xmlrpc_client($GLOBALS['oer_config']['ws_accounting']['url'],
		$GLOBALS['oer_config']['ws_accounting']['server'],
		$GLOBALS['oer_config']['ws_accounting']['port']);

	$c->setCredentials($GLOBALS['oer_config']['ws_accounting']['username'],
		$GLOBALS['oer_config']['ws_accounting']['password']);

	$r = $c->send($f);
	if (!$r) return "XMLRPC send failed";

	// We are not doing anything with the return value yet... should we?
	$tv = $r->value();
	if (is_object($tv)) {
		$value = $tv->getval();
	}
	else {
		$value = null;	
	}

	if ($r->faultCode()) {
		return "Fault: Code: " . $r->faultCode() . " Reason '" . $r->faultString() . "'";
	}

	return '';
}

/////////////////// End of invoice posting functions /////////////////

// Generate a receipt from the last-billed invoice for this patient.
//
function generate_receipt($patient_id) {
  global $sl_err, $sl_cash_acc, $css_header;

  // Get details for what we guess is the primary facility.
  $frow = sqlQuery("SELECT * FROM facility " .
    "ORDER BY billing_location DESC, accepts_assignment DESC, id LIMIT 1");

  $patdata = getPatientData($patient_id, 'fname,mname,lname,pubpid,street,city,state,postal_code');

  SLConnect();

  // Get the most recent invoice data into $arrow.
  //
  $arres = SLQuery("SELECT * FROM ar WHERE " .
    "invnumber LIKE '$patient_id.%' " .
    "ORDER BY id DESC LIMIT 1");
  if ($sl_err) die($sl_err);
  if (!SLRowCount($arres)) die(xl("This patient has no activity."));
  $arrow = SLGetRow($arres, 0);

  $trans_id = $arrow['id'];

  // Determine the date of service.  An 8-digit encounter number is
  // presumed to be a date of service imported during conversion or
  // associated with prescriptions only.  Otherwise look it up in the
  // form_encounter table.
  //
  $svcdate = "";
  list($trash, $encounter) = explode(".", $arrow['invnumber']);
  if (strlen($encounter) >= 8) {
    $svcdate = substr($encounter, 0, 4) . "-" . substr($encounter, 4, 2) .
      "-" . substr($encounter, 6, 2);
  }
  else if ($encounter) {
    $tmp = sqlQuery("SELECT date FROM form_encounter WHERE " .
      "encounter = $encounter");
    $svcdate = substr($tmp['date'], 0, 10);
  }
?>
<html>
<head>
<?php html_header_show(); ?>
<link rel='stylesheet' href='<?php echo $css_header ?>' type='text/css'>
<title><?php xl('Receipt for Payment','e'); ?></title>
</head>
<body class="body_top">
<center>
<p><b><?php echo $frow['name'] ?>
<br><?php echo $frow['street'] ?>
<br><?php echo $frow['city'] . ', ' . $frow['state'] . ' ' . $frow['postal_code'] ?>
<br><?php echo $frow['phone'] ?>
<br>&nbsp;
<br><?php echo date('F j, Y') ?>
<br>&nbsp;
</b></p>
</center>
<p>
<?php echo $patdata['fname'] . ' ' . $patdata['mname'] . ' ' . $patdata['lname'] ?>
<br><?php echo $patdata['street'] ?>
<br><?php echo $patdata['city'] . ', ' . $patdata['state'] . ' ' . $patdata['postal_code'] ?>
<br>&nbsp;
</p>
<center>
<table>
 <tr>
  <td><b><?php xl('Date','e'); ?></b></td>
  <td><b><?php xl('Description','e'); ?></b></td>
  <td align='right'><b><?php xl('Price','e'); ?></b></td>
  <td align='right'><b><?php xl('Qty'  ,'e'); ?></b></td>
  <td align='right'><b><?php xl('Total','e'); ?></b></td>
 </tr>
<?php
 $charges = 0.00;
 // Request all line items with money belonging to the invoice.
 $inres = SLQuery("SELECT * FROM invoice WHERE " .
  "trans_id = $trans_id AND sellprice != 0 ORDER BY id");
 if ($sl_err) die($sl_err);

 for ($irow = 0; $irow < SLRowCount($inres); ++$irow) {
  $row = SLGetRow($inres, $irow);
  $price = sprintf('%01.2f', $row['sellprice']);
  $tmp   = sprintf('%01.4f', $row['sellprice']);
  if ($tmp != $price) $price = $tmp;
  $amount = sprintf('%01.2f', $row['sellprice'] * $row['qty']);
  $charges += $amount;
  $desc = preg_replace('/^.{1,6}:/', '', $row['description']);
  echo " <tr>\n";
  echo "  <td>$svcdate</td>\n";
  echo "  <td>$desc</td>\n";
  echo "  <td align='right'>$price</td>\n";
  echo "  <td align='right'>" . $row['qty'] . "</td>\n";
  echo "  <td align='right'>$amount</td>\n";
  echo " </tr>\n";
 }
?>

 <tr>
  <td colspan='5'>&nbsp;</td>
 </tr>
 <tr>
  <td>&nbsp;</td>
  <td><b><?php xl('Total Charges','e'); ?></b></td>
  <td align='right'>&nbsp;</td>
  <td align='right'>&nbsp;</td>
  <td align='right'><?php echo sprintf('%01.2f', $charges) ?></td>
 </tr>
 <tr>
  <td colspan='5'>&nbsp;</td>
 </tr>

<?php
 $chart_id_cash = SLQueryValue("select id from chart where accno = '$sl_cash_acc'");
 if ($sl_err) die($sl_err);
 if (! $chart_id_cash) die("There is no COA entry for cash account '$sl_cash_acc'");

 // Request all cash entries belonging to the invoice.
 $atres = SLQuery("SELECT * FROM acc_trans WHERE " .
  "trans_id = $trans_id AND chart_id = $chart_id_cash ORDER BY transdate");
 if ($sl_err) die($sl_err);

 for ($irow = 0; $irow < SLRowCount($atres); ++$irow) {
  $row = SLGetRow($atres, $irow);
  $amount = sprintf('%01.2f', $row['amount']); // negative
  $charges += $amount;
  $rowsource = $row['source'];
  if (strtolower($rowsource) == 'co-pay') $rowsource = '';
  echo " <tr>\n";
  echo "  <td>" . $row['transdate'] . "</td>\n";
  echo "  <td>" . xl('Payment') . " $rowsource</td>\n";
  echo "  <td colspan='2'>&nbsp;</td>\n";
  echo "  <td align='right'>$amount</td>\n";
  echo " </tr>\n";
 }
?>
 <tr>
  <td colspan='5'>&nbsp;</td>
 </tr>
 <tr>
  <td>&nbsp;</td>
  <td><b><?php xl('Balance Due','e'); ?></b></td>
  <td colspan='2'>&nbsp;</td>
  <td align='right'><?php echo sprintf('%01.2f', $charges) ?></td>
 </tr>
</table>
</center>
<p>&nbsp;<a href='' onclick='window.print(); return false;'><?php xl('Print','e'); ?></a></p>
</body>
</html>
<?php
  SLClose();
} // end function

// Function to output a line item for the input form.
//
$lino = 0;
function write_form_line($code_type, $code, $id, $date, $description,
  $amount, $units, $taxrates) {
  global $lino;
  $amount = sprintf("%01.2f", $amount);
  if (empty($units)) $units = 1;
  $price = $amount / $units; // should be even cents, but ok here if not
  if ($code_type == 'COPAY' && !$description) $description = xl('Payment');
  echo " <tr>\n";
  echo "  <td>$date";
  echo "<input type='hidden' name='line[$lino][code_type]' value='$code_type'>";
  echo "<input type='hidden' name='line[$lino][code]' value='$code'>";
  echo "<input type='hidden' name='line[$lino][id]' value='$id'>";
  echo "<input type='hidden' name='line[$lino][description]' value='$description'>";
  echo "<input type='hidden' name='line[$lino][taxrates]' value='$taxrates'>";
  echo "<input type='hidden' name='line[$lino][price]' value='$price'>";
  echo "<input type='hidden' name='line[$lino][units]' value='$units'>";
  echo "</td>\n";
  echo "  <td>$description</td>";
  echo "  <td align='right'>$units</td>";
  echo "  <td align='right'><input type='text' name='line[$lino][amount]' " .
       "value='$amount' size='6' maxlength='8'";
  // Modifying prices requires the acct/disc permission.
  // if ($code_type == 'TAX' || ($code_type != 'COPAY' && !acl_check('acct','disc')))
  echo " style='text-align:right;background-color:transparent' readonly";
  // else echo " style='text-align:right' onkeyup='computeTotals()'";
  echo "></td>\n";
  echo " </tr>\n";
  ++$lino;
}

// Create the taxes array.  Key is tax id, value is
// (description, rate, accumulated total).
$taxes = array();
$pres = sqlStatement("SELECT option_id, title, option_value " .
  "FROM list_options WHERE list_id = 'taxrate' ORDER BY seq");
while ($prow = sqlFetchArray($pres)) {
  $taxes[$prow['option_id']] = array($prow['title'], $prow['option_value'], 0);
}

// Mark the tax rates that are referenced in this invoice.
function markTaxes($taxrates) {
  global $taxes;
  $arates = explode(':', $taxrates);
  if (empty($arates)) return;
  foreach ($arates as $value) {
    if (!empty($taxes[$value])) $taxes[$value][2] = '1';
  }
}

 $payment_methods = array(
  'Cash',
  'Check',
  'MC',
  'VISA',
  'AMEX',
  'DISC',
  'Other');

 $alertmsg = ''; // anything here pops up in an alert box

 // If the Save button was clicked...
 //
 if ($_POST['form_save']) {

  // On a save, do the following:
  // Flag drug_sales and billing items as billed.
  // Post the corresponding invoice with its payment(s) to sql-ledger
  // and be careful to use a unique invoice number.
  // Call the generate-receipt function.
  // Exit.

  $form_pid = $_POST['form_pid'];
  $form_encounter = $_POST['form_encounter'];

  // Get the posting date from the form as yyyy-mm-dd.
  $dosdate = date("Y-m-d");
  if (preg_match("/(\d\d\d\d)\D*(\d\d)\D*(\d\d)/", $_POST['form_date'], $matches)) {
   $dosdate = $matches[1] . '-' . $matches[2] . '-' . $matches[3];
  }

  // If there is no associated encounter (i.e. this invoice has only
  // prescriptions) then assign an encounter number of the service
  // date, with an optional suffix to ensure that it's unique.
  //
  if (! $form_encounter) {
   SLConnect();
   $form_encounter = substr($dosdate,0,4) . substr($dosdate,5,2) . substr($dosdate,8,2);
   $tmp = '';
   while (SLQueryValue("select id from ar where " .
    "invnumber = '$form_pid.$form_encounter$tmp'")) {
    $tmp = $tmp ? $tmp + 1 : 1;
   }
   $form_encounter .= $tmp;
   SLClose();
  }

  // Initialize an array of invoice information for posting.
  //
  $invoice_info = array();
  $msg = invoice_initialize($invoice_info, $form_pid,
   $_POST['form_provider'], $_POST['form_payer'], $form_encounter, $dosdate);
  if ($msg) die($msg);

  $form_amount = $_POST['form_amount'];
  $lines = $_POST['line'];

  for ($lino = 0; $lines[$lino]['code_type']; ++$lino) {
   $line = $lines[$lino];

   $code_type = $line['code_type'];
   $id        = $line['id'];
   $amount    = sprintf('%01.2f', trim($line['amount']));

   $msg = invoice_add_line_item($invoice_info, $code_type,
    $line['code'], $line['description'], $amount, $line['units']);
   if ($msg) die($msg);

   if ($code_type == 'PROD') {
    $query = "update drug_sales SET fee = '$amount', " .
     "encounter = '$form_encounter', billed = 1 WHERE " .
     "sale_id = '$id'";
    sqlQuery($query);
   }
   else {
    // Because there is no insurance here, there is no need for a claims
    // table entry and so we do not call updateClaim().  Note we should not
    // eliminate billed and bill_date from the billing table!
    $query = "UPDATE billing SET fee = '$amount', billed = 1, " .
     "bill_date = NOW() WHERE id = '$id'";
    sqlQuery($query);
   }
  }

  if ($_POST['form_amount']) {
   $paydesc = $_POST['form_source'] ? $_POST['form_source'] : '';
   $msg = invoice_add_line_item($invoice_info, 'COPAY',
    $_POST['form_method'],
    $paydesc,
    0 - $_POST['form_amount']);
   if ($msg) die($msg);
  }

  $msg = invoice_post($invoice_info);
  if ($msg) die($msg);

  generate_receipt($_POST['form_pid']);
  exit();
 }

 // Get the unbilled billing table items and prescription sales for
 // this patient.

 $query = "SELECT id, date, code_type, code, modifier, code_text, " .
  "provider_id, payer_id, units, fee, encounter " .
  "FROM billing " .
  "WHERE pid = '$pid' AND activity = 1 AND billed = 0 " .
  "ORDER BY encounter DESC, id ASC";
 $bres = sqlStatement($query);

 $query = "SELECT s.sale_id, s.sale_date, s.prescription_id, s.fee, " .
  "s.quantity, s.encounter, s.drug_id, d.name, r.provider_id " .
  "FROM drug_sales AS s " .
  "LEFT JOIN drugs AS d ON d.drug_id = s.drug_id " .
  "LEFT OUTER JOIN prescriptions AS r ON r.id = s.prescription_id " .
  "WHERE s.pid = '$pid' AND s.billed = 0 " .
  "ORDER BY s.encounter DESC, s.sale_id ASC";
 $dres = sqlStatement($query);

 // If there are none, just redisplay the last receipt and exit.
 //
 if (mysql_num_rows($bres) == 0 && mysql_num_rows($dres) == 0) {
  generate_receipt($pid);
  exit();
 }

 // Now write a data entry form:
 // List unbilled billing items (cpt, hcpcs, copays) for the patient.
 // List unbilled prescription sales for the patient.
 // Present an editable dollar amount for each line item, a total
 // which is also the default value of the input payment amount,
 // and OK and Cancel buttons.
?>
<html>
<head>
<link rel='stylesheet' href='<?php echo $css_header ?>' type='text/css'>
<title><?php xl('Patient Checkout','e'); ?></title>
<style>
</style>
<style type="text/css">@import url(../../library/dynarch_calendar.css);</style>
<script type="text/javascript" src="../../library/textformat.js"></script>
<script type="text/javascript" src="../../library/dynarch_calendar.js"></script>
<script type="text/javascript" src="../../library/dynarch_calendar_en.js"></script>
<script type="text/javascript" src="../../library/dynarch_calendar_setup.js"></script>
<script language="JavaScript">
 var mypcc = '<?php echo $GLOBALS['phone_country_code'] ?>';

 function clearTax() {
  var f = document.forms[0];
  for (var lino = 0; true; ++lino) {
   var pfx = 'line[' + lino + ']';
   if (! f[pfx + '[code_type]']) break;
   if (f[pfx + '[code_type]'].value != 'TAX') continue;
   f[pfx + '[amount]'].value = '0.00';
   f[pfx + '[price]'].value = '0.00';
  }
 }

 function addTax(rateid, amount) {
  if (rateid.length == 0) return 0;
  var f = document.forms[0];
  for (var lino = 0; true; ++lino) {
   var pfx = 'line[' + lino + ']';
   if (! f[pfx + '[code_type]']) break;
   if (f[pfx + '[code_type]'].value != 'TAX') continue;
   if (f[pfx + '[code]'].value != rateid) continue;
   var tax = amount * parseFloat(f[pfx + '[taxrates]'].value);
   tax = parseFloat(tax.toFixed(2));
   var cumtax = parseFloat(f[pfx + '[price]'].value) + tax;
   f[pfx + '[price]'].value  = cumtax.toFixed(2); // requires JS 1.5
   f[pfx + '[amount]'].value = cumtax.toFixed(2); // requires JS 1.5
   if (isNaN(tax)) alert('Tax rate not numeric at line ' + lino);
   return tax;
  }
  return 0;
 }

 // This mess applies the discount percentage.
 function computeTotals() {
  clearTax();
  var f = document.forms[0];
  var total = 0.00;
  var discount = parseFloat(f.form_discount.value);
  if (isNaN(discount)) discount = 0;
  for (var lino = 0; f['line[' + lino + '][code_type]']; ++lino) {
   var code_type = f['line[' + lino + '][code_type]'].value;
   var price = parseFloat(f['line[' + lino + '][price]'].value);
   if (isNaN(price)) alert('Price not numeric at line ' + lino);
   if (code_type == 'COPAY' || code_type == 'TAX') {
    total += parseFloat(price.toFixed(2));
    continue;
   }
   var units = f['line[' + lino + '][units]'].value;
   if (discount > 100) discount = 100;
   if (discount < 0  ) discount = 0;
   var amount = price * units;
   if (discount > 0) {
    amount = ((amount * (100 - discount) / 100) / units).toFixed(2) * units;
   }
   amount = parseFloat(amount.toFixed(2));
   f['line[' + lino + '][amount]'].value = amount.toFixed(2);
   total += amount;
   var taxrates  = f['line[' + lino + '][taxrates]'].value;
   var taxids = taxrates.split(':');
   for (var j = 0; j < taxids.length; ++j) {
    addTax(taxids[j], amount);
   }
  }
  // f.form_amount.value = total.toFixed(2);
  f.form_amount.value = total.toFixed(2);
  return true;
 }

</script>
</head>

<body class="body_top">

<form method='post' action='pos_checkout.php'>
<input type='hidden' name='form_pid' value='<?php echo $pid ?>' />

<center>

<p>
<table cellspacing='5'>
 <tr>
  <td colspan='3' align='center'>
   <b><?php xl('Patient Checkout for ','e'); ?><?php echo $patdata['fname'] . " " .
    $patdata['lname'] . " (" . $patdata['pubpid'] . ")" ?></b>
  </td>
 </tr>
 <tr>
  <td><b><?php xl('Date','e'); ?></b></td>
  <td><b><?php xl('Description','e'); ?></b></td>
  <td align='right'><b><?php xl('Qty','e'); ?></b></td>
  <td align='right'><b><?php xl('Amount','e'); ?></b></td>
 </tr>
<?php
$inv_encounter = '';
$inv_date      = '';
$inv_provider  = 0;
$inv_payer     = 0;

while ($brow = sqlFetchArray($bres)) {
  // Skip all but the most recent encounter.
  if ($inv_encounter && $brow['encounter'] != $inv_encounter) continue;

  $thisdate = substr($brow['date'], 0, 10);
  $code_type = $brow['code_type'];

  $taxrates = '';
  if ($code_type != 'COPAY' && $code_type != 'TAX') {
    $query = "SELECT taxrates FROM codes WHERE code_type = '" .
      $code_types[$code_type]['id'] . "' AND " .
      "code = '" . $brow['code'] . "' AND ";
    if ($brow['modifier']) {
      $query .= "modifier = '" . $brow['modifier'] . "'";
    } else {
      $query .= "(modifier IS NULL OR modifier = '')";
    }
    $query .= " LIMIT 1";
    $tmp = sqlQuery($query);
    $taxrates = $tmp['taxrates'];
    markTaxes($taxrates);
  }

  write_form_line($code_type, $brow['code'], $brow['id'], $thisdate,
    ucfirst(strtolower($brow['code_text'])), $brow['fee'], $brow['units'],
    $taxrates);
  if (!$inv_encounter) $inv_encounter = $brow['encounter'];
  if (!$inv_provider ) $inv_provider  = $brow['provider_id'];
  $inv_payer = $brow['payer_id'];
  if (!$inv_date || $inv_date < $thisdate) $inv_date = $thisdate;
}

while ($drow = sqlFetchArray($dres)) {
  if ($inv_encounter && $drow['encounter'] && $drow['encounter'] != $inv_encounter) continue;

  $thisdate = $drow['sale_date'];
  if (!$inv_encounter) $inv_encounter = $drow['encounter'];
  if (!$inv_provider ) $inv_provider  = $drow['provider_id'] + 0;
  if (!$inv_date || $inv_date < $thisdate) $inv_date = $thisdate;
  // $total += $drow['fee'];

  // Accumulate taxes for this product.
  $tmp = sqlQuery("SELECT taxrates FROM drug_templates WHERE drug_id = '" .
    $drow['drug_id'] . "' ORDER BY selector LIMIT 1");
  // accumTaxes($drow['fee'], $tmp['taxrates']);
  $taxrates = $tmp['taxrates'];
  markTaxes($taxrates);

  write_form_line('PROD', $drow['drug_id'], $drow['sale_id'],
   $thisdate, $drow['name'], $drow['fee'], $drow['quantity'], $taxrates);
}

// Write a form line for each tax that has money, adding to $total.
foreach ($taxes as $key => $value) {
  if ($value[2]) {
    write_form_line('TAX', $key, $key, date('Y-m-d'), $value[0], 0, 1, $value[1]);
  }
}

// If there were only products without prescriptions then there is no
// provider yet, so get it from the encounter.
if ($inv_encounter && !$inv_provider) {
  $erow = sqlQuery("SELECT users.id FROM forms, users WHERE " .
    "forms.encounter = '$inv_encounter' AND " .
    "forms.formdir = 'newpatient' AND " .
    "users.username = forms.user LIMIT 1");
  $inv_provider = $erow['id'];
}
?>
</table>

<p>
<table border='0' cellspacing='8'>

 <tr>
  <td>
   <?php xl('Discount Percentage','e'); ?>:
  </td>
  <td>
   <input type='text' name='form_discount' size='3' value=''
    style='text-align:right' onkeyup='computeTotals()'>
  </td>
 </tr>

 <tr>
  <td>
   <?php xl('Payment Method','e'); ?>:
  </td>
  <td>
   <select name='form_method'>
<?
 foreach ($payment_methods as $value) {
  echo "    <option value='$value'";
  echo ">$value</option>\n";
 }
?>
   </select>
  </td>
 </tr>

 <tr>
  <td>
   <?php xl('Check/Reference Number','e'); ?>:
  </td>
  <td>
   <input type='text' name='form_source' size='10' value=''>
  </td>
 </tr>

 <tr>
  <td>
   <?php xl('Amount Paid','e'); ?>:
  </td>
  <td>
   <input type='text' name='form_amount' size='10' value='0.00'>
  </td>
 </tr>

 <tr>
  <td>
   <?php xl('Posting Date','e'); ?>:
  </td>
  <td>
   <input type='text' size='10' name='form_date' id='form_date'
    value='<?php echo $inv_date ?>'
    title='yyyy-mm-dd date of service'
    onkeyup='datekeyup(this,mypcc)' onblur='dateblur(this,mypcc)' />
   <img src='../pic/show_calendar.gif' align='absbottom' width='24' height='22'
    id='img_date' border='0' alt='[?]' style='cursor:pointer'
    title='Click here to choose a date'>
  </td>
 </tr>

 <tr>
  <td colspan='2' align='center'>
   &nbsp;<br>
   <input type='submit' name='form_save' value='<?php xl('Save','e'); ?>' /> &nbsp;
<?php if (empty($_GET['framed'])) { ?>
   <input type='button' value='Cancel' onclick='window.close()' />
<?php } ?>
   <input type='hidden' name='form_provider'  value='<?php echo $inv_provider  ?>' />
   <input type='hidden' name='form_payer'     value='<?php echo $inv_payer     ?>' />
   <input type='hidden' name='form_encounter' value='<?php echo $inv_encounter ?>' />
  </td>
 </tr>

</table>
</center>

</form>

<script language='JavaScript'>
 Calendar.setup({inputField:"form_date", ifFormat:"%Y-%m-%d", button:"img_date"});
 computeTotals();
</script>

</body>
</html>
