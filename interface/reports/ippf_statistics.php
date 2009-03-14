<?php
// This module creates statistical reports related to family planning
// and sexual and reproductive health.

include_once("../globals.php");
include_once("../../library/patient.inc");
include_once("../../library/acl.inc");

// Might want something different here.
//
if (! acl_check('acct', 'rep')) die("Unauthorized access.");

$report_type = empty($_GET['t']) ? 'i' : $_GET['t'];

$from_date     = fixDate($_POST['form_from_date']);
$to_date       = fixDate($_POST['form_to_date'], date('Y-m-d'));
$form_by       = $_POST['form_by'];     // this is a scalar
$form_show     = $_POST['form_show'];   // this is an array
$form_facility = isset($_POST['form_facility']) ? $_POST['form_facility'] : '';
$form_sexes    = isset($_POST['form_sexes']) ? $_POST['form_sexes'] : '3';
$form_cors     = isset($_POST['form_cors']) ? $_POST['form_cors'] : '1';
$form_output   = isset($_POST['form_output']) ? 0 + $_POST['form_output'] : 1;

if (empty($form_by))    $form_by = '1';
if (empty($form_show))  $form_show = array('1');

// One of these is chosen as the left column, or Y-axis, of the report.
//
if ($report_type == 'm') {
  $report_title = xl('Member Association Statistics Report');
  $arr_by = array(
    101 => xl('MA Category'),
    102 => xl('Specific Service'),
    17  => xl('Patient'),
    9   => xl('Internal Referrals'),
    10  => xl('External Referrals'),
    103 => xl('Referral Source'),
    2   => xl('Total'),
  );
}
else if ($report_type == 'g') {
  $report_title = xl('GCAC Statistics Report');
  $arr_by = array(
    1  => xl('Total SRH & Family Planning'),
    12 => xl('Pre-Abortion Counseling'), // not yet implemented
    5  => xl('Abortion Method'), // includes surgical and drug-induced
    8  => xl('Post-Abortion Followup'),
    7  => xl('Post-Abortion Contraception'),
    11 => xl('Complications of Abortion'),
  );
}
else {
  $report_title = xl('IPPF Statistics Report');
  $arr_by = array(
    1  => xl('General Service Category'),
    4  => xl('Specific Service'),
    6  => xl('Contraceptive Method'),
    9   => xl('Internal Referrals'),
    10  => xl('External Referrals'),
  );
}

if ($report_type == 'm') {
  $arr_content = array(
    1 => xl('Services'),
    2 => xl('Unique Clients'),
    4 => xl('Unique New Clients')
  );
}
else {
  $arr_content = array(
    1 => xl('Services'),
    2 => xl('Unique Clients'),
    3 => xl('New Acceptors'),
    4 => xl('Unique New Clients')
  );
}

// A reported value is either scalar, or an array listed horizontally.  If
// multiple items are chosen then each starts in the next available column.
//
$arr_show = array(
  1 => xl('Total'),
  // 9 => xl('Total Clients'),
  2 => xl('Age Category'),
  3 => xl('Sex'),
  4 => xl('Religion'),
  5 => xl('Nationality'),
  6 => xl('Marital Status'),
  7 => xl('State/Parish'),
 10 => xl('City'),
  8 => xl('Occupation'),
 11 => xl('Education'),
 12 => xl('Income'),
 13 => xl('Provider'),
);

// This will become the array of reportable values.
$areport = array();

// This accumulates the bottom line totals.
$atotals = array();

// Arrays of titles for some column headings.
$arr_titles = array(
  'rel' => array(),
  'nat' => array(),
  'mar' => array(),
  'sta' => array(),
  'occ' => array(),
  'cit' => array(),
  'edu' => array(),
  'inc' => array(),
  'pro' => array(),
);

// This is so we know when the current patient changes.
// $previous_pid = 0;

// Compute age in years given a DOB and "as of" date.
//
function getAge($dob, $asof='') {
  if (empty($asof)) $asof = date('Y-m-d');
  $a1 = explode('-', substr($dob , 0, 10));
  $a2 = explode('-', substr($asof, 0, 10));
  $age = $a2[0] - $a1[0];
  if ($a2[1] < $a1[1] || ($a2[1] == $a1[1] && $a2[2] < $a1[2])) --$age;
  // echo "<!-- $dob $asof $age -->\n"; // debugging
  return $age;
}

$cellcount = 0;

function genStartRow($att) {
  global $cellcount, $form_output;
  if ($form_output != 3) echo " <tr $att>\n";
  $cellcount = 0;
}

function genEndRow() {
  global $form_output;
  if ($form_output == 3) {
    echo "\n";
  }
  else {
    echo " </tr>\n";
  }
}

/*********************************************************************
function genAnyCell($data, $right=false, $class='') {
  global $cellcount;
  if ($_POST['form_csvexport']) {
    if ($cellcount) echo ',';
    echo '"' . $data . '"';
  }
  else {
    echo "  <td";
    if ($class) echo " class='$class'";
    if ($right) echo " align='right'";
    echo ">$data</td>\n";
  }
  ++$cellcount;
}
*********************************************************************/

function getListTitle($list, $option) {
  $row = sqlQuery("SELECT title FROM list_options WHERE " .
    "list_id = '$list' AND option_id = '$option'");
  if (empty($row['title'])) return $option;
  return $row['title'];
}

// Usually this generates one cell, but allows for two or more.
//
function genAnyCell($data, $right=false, $class='') {
  global $cellcount, $form_output;
  if (!is_array($data)) {
    $data = array(0 => $data);
  }
  foreach ($data as $datum) {
    if ($form_output == 3) {
      if ($cellcount) echo ',';
      echo '"' . $datum . '"';
    }
    else {
      echo "  <td";
      if ($class) echo " class='$class'";
      if ($right) echo " align='right'";
      echo ">$datum</td>\n";
    }
    ++$cellcount;
  }
}

function genHeadCell($data, $right=false) {
  genAnyCell($data, $right, 'dehead');
}

// Create an HTML table cell containing a numeric value, and track totals.
//
function genNumCell($num, $cnum) {
  global $atotals, $form_output;
  $atotals[$cnum] += $num;
  if (empty($num) && $form_output != 3) $num = '&nbsp;';
  genAnyCell($num, true, 'detail');
}

// Translate an IPPF code to the corresponding descriptive name of its
// contraceptive method, or to an empty string if none applies.
//
function getContraceptiveMethod($code) {
  $key = '';
  if (preg_match('/^111101/', $code)) {
    $key = xl('Pills');
  }
  else if (preg_match('/^11111[1-9]/', $code)) {
    $key = xl('Injectables');
  }
  else if (preg_match('/^11112[1-9]/', $code)) {
    $key = xl('Implants');
  }
  else if (preg_match('/^111132/', $code)) {
    $key = xl('Patch');
  }
  else if (preg_match('/^111133/', $code)) {
    $key = xl('Vaginal Ring');
  }
  else if (preg_match('/^112141/', $code)) {
    $key = xl('Male Condoms');
  }
  else if (preg_match('/^112142/', $code)) {
    $key = xl('Female Condoms');
  }
  else if (preg_match('/^11215[1-9]/', $code)) {
    $key = xl('Diaphragms/Caps');
  }
  else if (preg_match('/^11216[1-9]/', $code)) {
    $key = xl('Spermicides');
  }
  else if (preg_match('/^11317[1-9]/', $code)) {
    $key = xl('IUD');
  }
  else if (preg_match('/^145212/', $code)) {
    $key = xl('Emergency Contraception');
  }
  else if (preg_match('/^121181.13/', $code)) {
    $key = xl('Female VSC');
  }
  else if (preg_match('/^122182.13/', $code)) {
    $key = xl('Male VSC');
  }
  else if (preg_match('/^131191.10/', $code)) {
    $key = xl('Awareness-Based');
  }
  return $key;
}

// Translate an IPPF code to the corresponding descriptive name of its
// abortion method, or to an empty string if none applies.
//
function getAbortionMethod($code) {
  $key = '';
  if (preg_match('/^25222[34]/', $code)) {
    if (preg_match('/^2522231/', $code)) {
      $key = xl('D&C');
    }
    else if (preg_match('/^2522232/', $code)) {
      $key = xl('D&E');
    }
    else if (preg_match('/^2522233/', $code)) {
      $key = xl('MVA');
    }
    else if (preg_match('/^252224/', $code)) {
      $key = xl('Medical');
    }
    else {
      $key = xl('Other Surgical');
    }
  }
  return $key;
}

// Helper function to look up the GCAC issue associated with a visit.
// Ideally this is the one and only GCAC issue linked to the encounter.
// However if there are multiple such issues, or if only unlinked issues
// are found, then we pick the one with its start date closest to the
// encounter date.
//
function getGcacData($row, $what, $morejoins="") {
  $patient_id = $row['pid'];
  $encounter_id = $row['encounter'];
  $encdate = substr($row['encdate'], 0, 10);
  $query = "SELECT $what " .
    "FROM lists AS l " .
    "JOIN lists_ippf_gcac AS lg ON l.type = 'ippf_gcac' AND lg.id = l.id " .
    "LEFT JOIN issue_encounter AS ie ON ie.pid = '$patient_id' AND " .
    "ie.encounter = '$encounter_id' AND ie.list_id = l.id " .
    "$morejoins " .
    "WHERE l.pid = '$patient_id' AND " .
    "l.activity = 1 AND l.type = 'ippf_gcac' " .
    "ORDER BY ie.pid DESC, ABS(DATEDIFF(l.begdate, '$encdate')) ASC " .
    "LIMIT 1";
  // Note that reverse-ordering by ie.pid is a trick for sorting
  // issues linked to the encounter (non-null values) first.
  return sqlQuery($query);
}

// Get the "client status" field from the related GCAC issue.
//
function getGcacClientStatus($row) {
  $irow = getGcacData($row, "lo.title", "LEFT JOIN list_options AS lo ON " .
    "lo.list_id = 'clientstatus' AND lo.option_id = lg.client_status");
  if (empty($irow['title'])) {
    $key = xl('Indeterminate');
  }
  else {
    // The client status description should be just fine for this.
    $key = $irow['title'];
  }
  return $key;
}

// Helper function called after the reporting key is determined for a row.
//
function loadColumnData($key, $row) {
  global $areport, $arr_titles, $form_cors, $from_date, $to_date;

  // global $previous_pid;
  // if ($form_cors == '2' && $row['pid'] == $previous_pid) return;
  // $previous_pid = $row['pid'];

  // If first instance of this key, initialize its arrays.
  if (empty($areport[$key])) {
    $areport[$key] = array();
    $areport[$key]['wom'] = 0;       // number of services for women
    $areport[$key]['men'] = 0;       // number of services for men
    $areport[$key]['age'] = array(0,0,0,0,0,0,0,0,0); // age array
    $areport[$key]['rel'] = array(); // religion array
    $areport[$key]['nat'] = array(); // nationality array
    $areport[$key]['mar'] = array(); // marital status array
    $areport[$key]['sta'] = array(); // state/parish array
    $areport[$key]['occ'] = array(); // occupation array
    $areport[$key]['cit'] = array(); // city array
    $areport[$key]['edu'] = array(); // education array
    $areport[$key]['inc'] = array(); // income array
    $areport[$key]['pro'] = array(); // provider array
    $areport[$key]['prp'] = 0;       // previous pid
  }

  // Skip this key if we are counting unique patients and the key
  // has already seen this patient.
  if ($form_cors == '2' && $row['pid'] == $areport[$key]['prp']) return;

  // If we are counting new acceptors, then require a unique patient
  // whose contraceptive start date is within the reporting period.
  if ($form_cors == '3') {
    if ($row['pid'] == $areport[$key]['prp']) return;
    // Check contraceptive start date.
    if (!$row['contrastart'] || $row['contrastart'] < $from_date ||
      $row['contrastart'] > $to_date) return;
  }

  // If we are counting new clients, then require a unique patient
  // whose registration date is within the reporting period.
  if ($form_cors == '4') {
    if ($row['pid'] == $areport[$key]['prp']) return;
    // Check registration date.
    if (!$row['regdate'] || $row['regdate'] < $from_date ||
      $row['regdate'] > $to_date) return;
  }

  // Flag this patient as having been encountered for this report row.
  $areport[$key]['prp'] = $row['pid'];

  /*******************************************************************
  // Increment the number of unique clients.
  if ($row['pid'] != $previous_pid) {
    ++$areport[$key]['cli'];
    $previous_pid = $row['pid'];
  }
  *******************************************************************/

  // Increment the correct sex category.
  if (strcasecmp($row['sex'], 'Male') == 0)
    ++$areport[$key]['men'];
  else
    ++$areport[$key]['wom'];

  // Increment the correct age category.
  $age = getAge(fixDate($row['DOB']), $row['encdate']);
  $i = min(intval(($age - 5) / 5), 8);
  if ($age < 11) $i = 0;
  ++$areport[$key]['age'][$i];

  // Increment the correct religion category.
  $religion = empty($row['userlist5']) ? 'Unspecified' : $row['userlist5'];
  $areport[$key]['rel'][$religion] += 1;
  $arr_titles['rel'][$religion] += 1;

  // Increment the correct nationality category.
  $nationality = empty($row['country_code']) ? 'Unspecified' : $row['country_code'];
  $areport[$key]['nat'][$nationality] += 1;
  $arr_titles['nat'][$nationality] += 1;

  // Increment the correct marital status category.
  $status = empty($row['status']) ? 'Unspecified' : $row['status'];
  $areport[$key]['mar'][$status] += 1;
  $arr_titles['mar'][$status] += 1;

  // Increment the correct state/parish category.
  $status = empty($row['state']) ? 'Unspecified' : $row['state'];
  $areport[$key]['sta'][$status] += 1;
  $arr_titles['sta'][$status] += 1;

  // Increment the correct occupation category.
  $status = empty($row['occupation']) ? 'Unspecified' : $row['occupation'];
  $areport[$key]['occ'][$status] += 1;
  $arr_titles['occ'][$status] += 1;

  // Increment the correct city category.
  $status = empty($row['city']) ? 'Unspecified' : $row['city'];
  $areport[$key]['cit'][$status] += 1;
  $arr_titles['cit'][$status] += 1;

  // Increment the correct education category.
  $status = empty($row['userlist2']) ? 'Unspecified' : $row['userlist2'];
  $areport[$key]['edu'][$status] += 1;
  $arr_titles['edu'][$status] += 1;

  // Increment the correct income category.
  $status = empty($row['userlist3']) ? 'Unspecified' : $row['userlist3'];
  $areport[$key]['inc'][$status] += 1;
  $arr_titles['inc'][$status] += 1;

  // Increment the correct provider category.
  $status = empty($row['provider']) ? 'Unknown' : $row['provider'];
  $areport[$key]['pro'][$status] += 1;
  $arr_titles['pro'][$status] += 1;
}

// This is called for each IPPF service code that is selected.
//
function process_ippf_code($row, $code) {
  global $areport, $arr_titles, $form_by;

  $key = 'Unspecified';

  // General Service Category.
  //
  if ($form_by === '1') {
    if (preg_match('/^1/', $code)) {
      $key = xl('SRH - Family Planning');
    }
    else if (preg_match('/^2/', $code)) {
      $key = xl('SRH Non Family Planning');
    }
    else if (preg_match('/^3/', $code)) {
      $key = xl('Non-SRH Medical');
    }
    else if (preg_match('/^4/', $code)) {
      $key = xl('Non-SRH Non-Medical');
    }
    else {
      $key = xl('Invalid Service Codes');
    }
  }

  // Specific Services. One row for each IPPF code.
  //
  else if ($form_by === '4') {
    $key = $code;
  }

  // Abortion Method.
  //
  else if ($form_by === '5') {
    $key = getAbortionMethod($code);
    if (empty($key)) return;
  }

  // Contraceptive Method.
  //
  else if ($form_by === '6') {
    $key = getContraceptiveMethod($code);
    if (empty($key)) return;
  }

  // Contraceptive method for new contraceptive adoption following abortion.
  // Get it from the IPPF code if an abortion issue is linked to the visit.
  // Note we are handling this during processing of services rather than
  // by enumerating issues, because we need the service date.
  //
  else if ($form_by === '7') {
    $key = getContraceptiveMethod($code);
    if (empty($key)) return;
    $patient_id = $row['pid'];
    $encounter_id = $row['encounter'];
    $query = "SELECT COUNT(*) AS count " .
      "FROM lists AS l " .
      "JOIN issue_encounter AS ie ON ie.pid = '$patient_id' AND " .
      "ie.encounter = '$encounter_id' AND ie.list_id = l.id " .
      "WHERE l.pid = '$patient_id' AND " .
      "l.activity = 1 AND l.type = 'ippf_gcac'";
    // echo "<!-- $key: $query -->\n"; // debugging
    $irow = sqlQuery($query);
    if (empty($irow['count'])) return;
  }

  // Post-Abortion Care by Source.
  // Requirements just call for counting sessions, but this way the columns
  // can be anything - age category, religion, whatever.
  //
  else if ($form_by === '8') {
    if (preg_match('/^252226/', $code)) { // all post-abortion care
      $key = getGcacClientStatus($row);
    } else {
      return;
    }
  }

  // Complications from abortion by abortion method and complication type.
  // These may be noted either during recovery or during a followup visit.
  // Again, driven by services in order to report by service date.
  // Note: If there are multiple complications, they will all be reported.
  //
  else if ($form_by === '11') {
    $compl_type = '';
    if (preg_match('/^25222[345]/', $code)) { // all abortions including incomplete
      $compl_type = 'rec_compl';
    }
    else if (preg_match('/^252226/', $code)) { // all post-abortion care
      $compl_type = 'fol_compl';
    }
    else {
      return;
    }
    $irow = getGcacData($row, "lg.$compl_type, lo.title",
      "LEFT JOIN list_options AS lo ON lo.list_id = 'in_ab_proc' AND " .
      "lo.option_id = lg.in_ab_proc");
    if (empty($irow)) return; // this should not happen
    if (empty($irow[$compl_type])) return; // ok, no complications
    // We have one or more complications.
    $abtype = empty($irow['title']) ? xl('Indeterminate') : $irow['title'];
    $acompl = explode('|', $irow[$compl_type]);
    foreach ($acompl as $compl) {
      $crow = sqlQuery("SELECT title FROM list_options WHERE " .
        "list_id = 'complication' AND option_id = '$compl'");
      $key = "$abtype / " . $crow['title'];
      loadColumnData($key, $row);
    }
    return; // because loadColumnData() is already done.
  }

  // Pre-Abortion Counseling.  Three possible situations:
  //   Provided abortion in the MA clinics
  //   Referred to other service providers (govt,private clinics)
  //   Decided not to have the abortion
  //
  else if ($form_by === '12') {
    if (preg_match('/^252221/', $code)) { // all pre-abortion counseling
      $key = getGcacClientStatus($row);
    } else {
      return;
    }
  }

  // Patient Name.
  //
  else if ($form_by === '17') {
    $key = $row['lname'] . ', ' . $row['fname'] . ' ' . $row['mname'];
  }

  else {
    return;
  }

  // OK we now have the reporting key for this issue.

  loadColumnData($key, $row);
}

// This is called for each MA service code that is selected.
//
function process_ma_code($row) {
  global $form_by, $arr_content, $form_cors;

  $key = 'Unspecified';

  // One row for each service category.
  //
  if ($form_by === '101') {
    if (!empty($row['title'])) $key = xl($row['title']);
  }

  // Specific Services. One row for each MA code.
  //
  else if ($form_by === '102') {
    $key = $row['code'];
  }

  // One row for each referral source.
  //
  else if ($form_by === '103') {
    $key = $row['referral_source'];
  }

  // Just one row.
  //
  else if ($form_by === '2') {
    $key = $arr_content[$form_cors];
  }

  else {
    return;
  }

  loadColumnData($key, $row);
}

/*********************************************************************
// This is called for each issue that is selected.
//
function process_issue($row) {
  global $form_by;

  $key = 'Unspecified';

  // Pre-Abortion Counseling.  Three possible rows:
  //   Provided abortion in the MA clinics
  //   Referred to other service providers (govt,private clinics)
  //   Decided not to have the abortion
  //
  if ($form_by === '12') {

    // TBD: Assign one of the 3 keys, or just return.

  }

  // Others TBD

  else {
    return;
  }

  // TBD: Load column data from the issue.
  // loadColumnData($key, $row);
}
*********************************************************************/

// This is called for each selected referral.
// Row keys are the first specified MA code, if any.
//
function process_referral($row) {
  $key = 'Unspecified';
  if (!empty($row['refer_related_code'])) {
    $relcodes = explode(';', $row['refer_related_code']);
    foreach ($relcodes as $codestring) {
      if ($codestring === '') continue;
      list($codetype, $code) = explode(':', $codestring);
      if ($codetype !== 'MA') continue;
      $key = $code;
      break;
    }
  }
  loadColumnData($key, $row);
}

  // If we are doing the CSV export then generate the needed HTTP headers.
  // Otherwise generate HTML.
  //
  if ($form_output == 3) {
    header("Pragma: public");
    header("Expires: 0");
    header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
    header("Content-Type: application/force-download");
    header("Content-Disposition: attachment; filename=service_statistics_report.csv");
    header("Content-Description: File Transfer");
  }
  else {
?>
<html>
<head>
<?php html_header_show(); ?>
<title><?php echo $report_title; ?></title>
<style type="text/css">@import url(../../library/dynarch_calendar.css);</style>
<style type="text/css">
 body       { font-family:sans-serif; font-size:10pt; font-weight:normal }
 .dehead    { color:#000000; font-family:sans-serif; font-size:10pt; font-weight:bold }
 .detail    { color:#000000; font-family:sans-serif; font-size:10pt; font-weight:normal }
</style>
<script type="text/javascript" src="../../library/textformat.js"></script>
<script type="text/javascript" src="../../library/dynarch_calendar.js"></script>
<script type="text/javascript" src="../../library/dynarch_calendar_en.js"></script>
<script type="text/javascript" src="../../library/dynarch_calendar_setup.js"></script>
<script language="JavaScript">
 var mypcc = '<?php echo $GLOBALS['phone_country_code'] ?>';
</script>
</head>

<body leftmargin='0' topmargin='0' marginwidth='0' marginheight='0'>

<center>

<h2><?php echo $report_title; ?></h2>

<form name='theform' method='post'
 action='ippf_statistics.php?t=<?php echo $report_type ?>'>

<table border='0' cellspacing='5' cellpadding='1'>
 <tr>
  <td valign='top' class='dehead' nowrap>
   <?php xl('Rows','e'); ?>:
  </td>
  <td valign='top' class='detail'>
   <select name='form_by' title='Left column of report'>
<?php
  foreach ($arr_by as $key => $value) {
    echo "    <option value='$key'";
    if ($key == $form_by) echo " selected";
    echo ">" . $value . "</option>\n";
  }
?>
   </select>
  </td>
  <td valign='top' class='dehead' nowrap>
   <?php xl('Content','e'); ?>:
  </td>
  <td valign='top' class='detail'>
   <select name='form_cors' title='<?php xl('What is to be counted?','e'); ?>'>
<?php
  foreach ($arr_content as $key => $value) {
    echo "    <option value='$key'";
    if ($key == $form_cors) echo " selected";
    echo ">$value</option>\n";
  }
?>
   </select>
  </td>
  <td valign='top' class='detail'>
   &nbsp;
  </td>
 </tr>
 <tr>
  <td valign='top' class='dehead' nowrap>
   <?php xl('Columns','e'); ?>:
  </td>
  <td valign='top' class='detail'>
   <select name='form_show[]' size='4' multiple
    title='<?php xl('Hold down Ctrl to select multiple items','e'); ?>'>
<?php
  foreach ($arr_show as $key => $value) {
    echo "    <option value='$key'";
    if (is_array($form_show) && in_array($key, $form_show)) echo " selected";
    echo ">" . $value . "</option>\n";
  }
?>
   </select>
  </td>
  <td valign='top' class='dehead' nowrap>
   <?php xl('Filters','e'); ?>:
  </td>
  <td colspan='2' class='detail' style='border-style:solid;border-width:1px;border-color:#cccccc'>
   <table>
    <tr>
     <td valign='top' class='detail' nowrap>
      <?php xl('Sex','e'); ?>:
     </td>
     <td class='detail' valign='top'>
      <select name='form_sexes' title='<?php xl('To filter by sex','e'); ?>'>
<?php
  foreach (array(3 => xl('Men and Women'), 1 => xl('Women Only'), 2 => xl('Men Only')) as $key => $value) {
    echo "       <option value='$key'";
    if ($key == $form_sexes) echo " selected";
    echo ">$value</option>\n";
  }
?>
      </select>
     </td>
    </tr>
    <tr>
     <td valign='top' class='detail' nowrap>
      <?php xl('Facility','e'); ?>:
     </td>
     <td valign='top' class='detail'>
<?php
 // Build a drop-down list of facilities.
 //
 $query = "SELECT id, name FROM facility ORDER BY name";
 $fres = sqlStatement($query);
 echo "      <select name='form_facility'>\n";
 echo "       <option value=''>-- All Facilities --\n";
 while ($frow = sqlFetchArray($fres)) {
  $facid = $frow['id'];
  echo "       <option value='$facid'";
  if ($facid == $_POST['form_facility']) echo " selected";
  echo ">" . $frow['name'] . "\n";
 }
 echo "      </select>\n";
?>
     </td>
    </tr>
    <tr>
     <td colspan='2' class='detail' nowrap>
      <?php xl('From','e'); ?>
      <input type='text' name='form_from_date' id='form_from_date' size='10' value='<?php echo $from_date ?>'
       onkeyup='datekeyup(this,mypcc)' onblur='dateblur(this,mypcc)' title='Start date yyyy-mm-dd'>
      <img src='../pic/show_calendar.gif' align='absbottom' width='24' height='22'
       id='img_from_date' border='0' alt='[?]' style='cursor:pointer'
       title='<?php xl('Click here to choose a date','e'); ?>'>
      <?php xl('To','e'); ?>
      <input type='text' name='form_to_date' id='form_to_date' size='10' value='<?php echo $to_date ?>'
       onkeyup='datekeyup(this,mypcc)' onblur='dateblur(this,mypcc)' title='End date yyyy-mm-dd'>
      <img src='../pic/show_calendar.gif' align='absbottom' width='24' height='22'
       id='img_to_date' border='0' alt='[?]' style='cursor:pointer'
       title='<?php xl('Click here to choose a date','e'); ?>'>
     </td>
    </tr>
   </table>
  </td>
 </tr>
 <tr>
  <td valign='top' class='dehead' nowrap>
   <?php xl('To','e'); ?>:
  </td>
  <td colspan='3' valign='top' class='detail' nowrap>
<?php
foreach (array(1 => 'Screen', 2 => 'Printer', 3 => 'Export File') as $key => $value) {
  echo "   <input type='radio' name='form_output' value='$key'";
  if ($key == $form_output) echo ' checked';
  echo " />$value &nbsp;";
}
?>
  </td>
  <td align='right' valign='top' class='detail' nowrap>
   <input type='submit' name='form_submit' value='<?php xl('Submit','e'); ?>'
    title='<?php xl('Click to generate the report','e'); ?>' />
  </td>
 </tr>
 <tr>
  <td colspan='5' height="1">
  </td>
 </tr>
</table>
<?php
  } // end not export

  if ($_POST['form_submit']) {
    $sexcond = '';
    if ($form_sexes == '1') $sexcond = "AND pd.sex NOT LIKE 'Male' ";
    else if ($form_sexes == '2') $sexcond = "AND pd.sex LIKE 'Male' ";

    // Get referrals and related patient data.
    if ($form_by === '9' || $form_by === '10') {
      $exttest = $form_by === '9' ? '=' : '!=';
      $query = "SELECT " .
        "t.refer_related_code, t.pid, pd.regdate, pd.referral_source, " .
        "pd.sex, pd.DOB, pd.lname, pd.fname, pd.mname, pd.userlist5, " .
        "pd.country_code, pd.status, pd.state, pd.occupation, pd.contrastart, " .
        "pd.city, pd.userlist2, pd.userlist3 " .
        "FROM transactions AS t " .
        "JOIN patient_data AS pd ON pd.pid = t.pid $sexcond" .
        "WHERE t.title = 'Referral' AND t.refer_date >= '$from_date' AND " .
        "t.refer_date <= '$to_date' AND refer_external $exttest '0' " .
        "ORDER BY t.pid, t.id";
      $res = sqlStatement($query);
      while ($row = sqlFetchArray($res)) {
        process_referral($row);
      }
    }
    /*****************************************************************
    else if ($form_by === '12') {
      // We are reporting on a date range, and assume the applicable date is
      // the issue start date which is presumably also the date of pre-
      // abortion counseling.  The issue end date and the surgery date are
      // not of interest here.
      $query = "SELECT " .
        "l.type, l.begdate, l.pid, " .
        "pd.sex, pd.DOB, pd.lname, pd.fname, pd.mname, pd.userlist5, " .
        "pd.country_code, pd.status, pd.state, pd.occupation, " .
        "lg.client_status, lg.ab_location " .
        "FROM lists AS l " .
        "JOIN patient_data AS pd ON pd.pid = l.pid $sexcond" .
        "LEFT OUTER JOIN lists_ippf_gcac AS lg ON l.type = 'ippf_gcac' AND lg.id = l.id " .
        // "LEFT OUTER JOIN lists_ippf_con  AS lc ON l.type = 'contraceptive' AND lc.id = l.id " .
        "WHERE l.begdate >= '$from_date' AND l.begdate <= '$to_date' AND " .
        "l.activity = 1 AND l.type = 'ippf_gcac' " .
        "ORDER BY l.pid, l.id";
      $res = sqlStatement($query);
      while ($row = sqlFetchArray($res)) {
        process_issue($row);
      }
    }
    *****************************************************************/
    else {
      // This gets us all MA codes, with encounter and patient
      // info attached and grouped by patient and encounter.
      $query = "SELECT " .
        "fe.pid, fe.encounter, fe.date AS encdate, pd.regdate, " .
        "f.user AS provider, " .
        "pd.sex, pd.DOB, pd.lname, pd.fname, pd.mname, pd.userlist5, " .
        "pd.country_code, pd.status, pd.state, pd.occupation, pd.contrastart, " .
        "pd.referral_source, pd.city, pd.userlist2, pd.userlist3, " .
        "b.code_type, b.code, c.related_code, lo.title " .
        "FROM form_encounter AS fe " .
        "JOIN forms AS f ON f.pid = fe.pid AND f.encounter = fe.encounter AND " .
        "f.formdir = 'newpatient' AND f.form_id = fe.id AND f.deleted = 0 " .
        "JOIN patient_data AS pd ON pd.pid = fe.pid $sexcond" .
        "LEFT OUTER JOIN billing AS b ON " .
        "b.pid = fe.pid AND b.encounter = fe.encounter AND b.activity = 1 " .
        "AND b.code_type = 'MA' " .
        "LEFT OUTER JOIN codes AS c ON b.code_type = 'MA' AND c.code_type = '12' AND " .
        "c.code = b.code AND c.modifier = b.modifier " .
        "LEFT OUTER JOIN list_options AS lo ON " .
        "lo.list_id = 'superbill' AND lo.option_id = c.superbill " .
        "WHERE fe.date >= '$from_date 00:00:00' AND " .
        "fe.date <= '$to_date 23:59:59' ";

      if ($form_facility) {
        $query .= "AND fe.facility_id = '$form_facility' ";
      }
      $query .= "ORDER BY fe.pid, fe.encounter, b.code";
      $res = sqlStatement($query);
      while ($row = sqlFetchArray($res)) {
        if ($row['code_type'] === 'MA') {
          process_ma_code($row);
          if (!empty($row['related_code'])) {
            $relcodes = explode(';', $row['related_code']);
            foreach ($relcodes as $codestring) {
              if ($codestring === '') continue;
              list($codetype, $code) = explode(':', $codestring);
              if ($codetype !== 'IPPF') continue;
              process_ippf_code($row, $code);
            }
          }
        }
      } // end while
    } // end else

    // Sort everything by key for reporting.
    ksort($areport);
    ksort($arr_titles['rel']);
    ksort($arr_titles['nat']);
    ksort($arr_titles['mar']);
    ksort($arr_titles['sta']);
    ksort($arr_titles['occ']);
    ksort($arr_titles['cit']);
    ksort($arr_titles['edu']);
    ksort($arr_titles['inc']);
    ksort($arr_titles['pro']);

    if ($form_output != 3) {
      echo "<table border='0' cellpadding='1' cellspacing='2' width='98%'>\n";
    } // end not csv export

    genStartRow("bgcolor='#dddddd'");

    // If the key is an MA or IPPF code, then add a column for its description.
    if ($form_by === '4' || $form_by === '102' || $form_by === '9' || $form_by === '10') {
      genHeadCell(array($arr_by[$form_by], xl('Description')));
    } else {
      genHeadCell($arr_by[$form_by]);
    }

    // Generate headings for values to be shown.
    foreach ($form_show as $value) {
      if ($value == '1') { // Total Services
        genHeadCell(xl('Total'));
      }
      /***************************************************************
      else if ($value == '9') { // Total Unique Clients
        genHeadCell(xl('Clients'));
      }
      ***************************************************************/
      else if ($value == '2') { // Age
        genHeadCell(xl('0-10' ), true);
        genHeadCell(xl('11-14'), true);
        genHeadCell(xl('15-19'), true);
        genHeadCell(xl('20-24'), true);
        genHeadCell(xl('25-29'), true);
        genHeadCell(xl('30-34'), true);
        genHeadCell(xl('35-39'), true);
        genHeadCell(xl('40-44'), true);
        genHeadCell(xl('45+'  ), true);
      }
      else if ($value == '3') { // Sex
        genHeadCell(xl('Women'), true);
        genHeadCell(xl('Men'  ), true);
      }
      else if ($value == '4') { // Religion
        foreach ($arr_titles['rel'] as $key => $value) {
          genHeadCell(getListTitle('userlist5',$key), true);
        }
      }
      else if ($value == '5') { // Nationality
        foreach ($arr_titles['nat'] as $key => $value) {
          genHeadCell(getListTitle('country',$key), true);
        }
      }
      else if ($value == '6') { // Marital Status
        foreach ($arr_titles['mar'] as $key => $value) {
          genHeadCell(getListTitle('marital',$key), true);
        }
      }
      else if ($value == '7') { // State/Parish
        foreach ($arr_titles['sta'] as $key => $value) {
          genHeadCell($key, true);
        }
      }
      else if ($value == '8') { // Occupation
        foreach ($arr_titles['occ'] as $key => $value) {
          genHeadCell(getListTitle('occupations',$key), true);
        }
      }
      else if ($value == '10') { // City
        foreach ($arr_titles['cit'] as $key => $value) {
          genHeadCell($key, true);
        }
      }
      else if ($value == '11') { // Education
        foreach ($arr_titles['edu'] as $key => $value) {
          genHeadCell(getListTitle('userlist2',$key), true);
        }
      }
      else if ($value == '12') { // Income
        foreach ($arr_titles['inc'] as $key => $value) {
          genHeadCell(getListTitle('userlist3',$key), true);
        }
      }
      else if ($value == '13') { // Provider
        foreach ($arr_titles['pro'] as $key => $value) {
          genHeadCell($key, true);
        }
      }
    }

    if ($form_output != 3) {
      genHeadCell(xl('Total'), true);
    }

    genEndRow();

    $encount = 0;

    foreach ($areport as $key => $varr) {
      $bgcolor = (++$encount & 1) ? "#ddddff" : "#ffdddd";

      $dispkey = $key;

      // If the key is an MA or IPPF code, then add a column for its description.
      if ($form_by === '4' || $form_by === '102' || $form_by === '9' || $form_by === '10') {
        $dispkey = array($key, '');
        $type = $form_by === '4' ? 11 : 12; // IPPF or MA
        $crow = sqlQuery("SELECT code_text FROM codes WHERE " .
          "code_type = '$type' AND code = '$key' ORDER BY id LIMIT 1");
        if (!empty($crow['code_text'])) $dispkey[1] = $crow['code_text'];
      }

      genStartRow("bgcolor='$bgcolor'");

      genAnyCell($dispkey, false, 'detail');

      // This is the column index for accumulating column totals.
      $cnum = 0;
      $totalsvcs = $areport[$key]['wom'] + $areport[$key]['men'];

      // Generate data for this row.
      foreach ($form_show as $value) {
        if ($value == '1') { // Total Services
          genNumCell($totalsvcs, $cnum++);
        }
        /*************************************************************
        else if ($value == '9') { // Total Unique Clients
          genNumCell($areport[$key]['cli'], $cnum++);
        }
        *************************************************************/
        else if ($value == '2') { // Age
          for ($i = 0; $i < 9; ++$i) {
            genNumCell($areport[$key]['age'][$i], $cnum++);
          }
        }
        else if ($value == '3') { // Sex
          genNumCell($areport[$key]['wom'], $cnum++);
          genNumCell($areport[$key]['men'], $cnum++);
        }
        else if ($value == '4') { // Religion
          foreach ($arr_titles['rel'] as $title => $nothing) {
            genNumCell($areport[$key]['rel'][$title], $cnum++);
          }
        }
        else if ($value == '5') { // Nationality
          foreach ($arr_titles['nat'] as $title => $nothing) {
            genNumCell($areport[$key]['nat'][$title], $cnum++);
          }
        }
        else if ($value == '6') { // Marital Status
          foreach ($arr_titles['mar'] as $title => $nothing) {
            genNumCell($areport[$key]['mar'][$title], $cnum++);
          }
        }
        else if ($value == '7') { // State/Parish
          foreach ($arr_titles['sta'] as $title => $nothing) {
            genNumCell($areport[$key]['sta'][$title], $cnum++);
          }
        }
        else if ($value == '8') { // Occupation
          foreach ($arr_titles['occ'] as $title => $nothing) {
            genNumCell($areport[$key]['occ'][$title], $cnum++);
          }
        }
        else if ($value == '10') { // City
          foreach ($arr_titles['cit'] as $title => $nothing) {
            genNumCell($areport[$key]['cit'][$title], $cnum++);
          }
        }
        else if ($value == '11') { // Education
          foreach ($arr_titles['edu'] as $title => $nothing) {
            genNumCell($areport[$key]['edu'][$title], $cnum++);
          }
        }
        else if ($value == '12') { // Income
          foreach ($arr_titles['inc'] as $title => $nothing) {
            genNumCell($areport[$key]['inc'][$title], $cnum++);
          }
        }
        else if ($value == '13') { // Provider
          foreach ($arr_titles['pro'] as $title => $nothing) {
            genNumCell($areport[$key]['pro'][$title], $cnum++);
          }
        }
      }

      // Write the Total column data.
      if ($form_output != 3) {
        $atotals[$cnum] += $totalsvcs;
        genAnyCell($totalsvcs, true, 'dehead');
      }

      genEndRow();
    } // end foreach

    if ($form_output != 3) {
      // Generate the line of totals.
      genStartRow("bgcolor='#dddddd'");

      // If the key is an MA or IPPF code, then add a column for its description.
      if ($form_by === '4' || $form_by === '102' || $form_by === '9' || $form_by === '10') {
        genHeadCell(array(xl('Totals'), ''));
      } else {
        genHeadCell(xl('Totals'));
      }

      for ($cnum = 0; $cnum < count($atotals); ++$cnum) {
        genHeadCell($atotals[$cnum], true);
      }
      genEndRow();
      // End of table.
      echo "</table>\n";
    }

  } // end of if refresh or export

  if ($form_output != 3) {
?>
</form>
</center>

<script language='JavaScript'>
 Calendar.setup({inputField:"form_from_date", ifFormat:"%Y-%m-%d", button:"img_from_date"});
 Calendar.setup({inputField:"form_to_date", ifFormat:"%Y-%m-%d", button:"img_to_date"});
<?php if ($form_output == 2) { ?>
 window.print();
<?php } ?>
</script>

</body>
</html>
<?php
  } // end not export
?>
