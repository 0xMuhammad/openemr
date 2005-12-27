<?
include_once("../../globals.php");
include_once("$srcdir/calendar.inc");
include_once("$srcdir/patient.inc");

$pnote_link == "";
if ($_GET['show_pnote_link'] == true || $_POST['show_pnote_link'] == true) {
  $pnote_link = "&show_pnote_link=1";
}
//the maximum number of patient records to display:
$M = 2000;

if (isset($_POST["mode"]) && ($_POST["mode"] == "editappt")) {
  //echo "saved appt";
  $body_code = ' onload="javascript:parent.Calendar.location.href=parent.Calendar.location.href;" ';
  $year = $_POST["year"];
  $month = $_POST["month"];
  $day = $_POST["day"];
  $hour = $_POST["hour"];
  $minute = $_POST["minute"];
  if ($_POST["ampm"] == "pm") {
    $hour += 12;
  }
  $timesave = "$year-$month-$day $hour:$minute";
  //echo $timesave;
  $providerres = sqlQuery("select name from groups where user='".$_POST["provider"]."' limit 1");

  saveCalendarUpdate($_POST["calid"],$_POST["pid"],$timesave,$_POST["reason"],$_POST["provider"],$providerres{"name"});
}
elseif (isset($_POST["mode"]) && ($_POST["mode"] == "deleteappt")) {
  $body_code = ' onload="javascript:parent.Calendar.location.href=parent.Calendar.location.href;" ';

  deleteCalendarItem($_POST["calid"],$_POST["pid"]);
}
elseif (isset($_POST["mode"]) && ($_POST["mode"] == "saveappt")) {
  $body_code = ' onload="javascript:parent.Calendar.location.href=parent.Calendar.location.href;" ';
  $year = $_POST["year"];
  $month = $_POST["month"];
  $day = $_POST["day"];
  $hour = $_POST["hour"];
  $minute = $_POST["minute"];
  if ($_POST["ampm"] == "pm") {
    $hour += 12;
  }
  $timesave = "$year-$month-$day $hour:$minute";
  $providerres = sqlQuery("select name from groups where user='".$_POST["provider"]."' limit 1");
  newCalendarItem($_POST["pid"],$timesave,$_POST["reason"],$_POST["provider"],$providerres{"name"});
} else {
  $body_code = "";
  $category = $_GET["event_category"];
  if(empty($category))
  {
    $category = $_POST['category'];
  }
}

if (isset($_GET["mode"]) && ($_GET["mode"] == "reset")) {
  $_SESSION["lastname"] = "";
  $_SESSION["firstname"] = "";
  //$_SESSION["category"] = $_POST["category"];
  $category = $_POST["category"];
}

if (isset($_POST["mode"]) && ($_POST["mode"] == "findpatient")) {
  $_SESSION["findby"] = $_POST["findBy"];
  $_SESSION["lastname"] = $_POST["lastname"];
  $_SESSION["firstname"] = $_POST["firstname"];
  $category = $_POST["category"];
}

$findby = $_SESSION["findby"];
$lastname = $_SESSION["lastname"];
$firstname = $_SESSION["firstname"];

?>
<html>
<head>
<link rel=stylesheet href="<?echo $css_header;?>" type="text/css">
<script type="text/javascript" src="../../../library/dialog.js"></script>

<script language='JavaScript'>

 // This is called from the event editor popup to refresh the display.
 function refreshme() {
  var cf = parent.frames[0].frames[0]; // calendar frame
  if (cf && cf.refreshme) cf.refreshme();
 }

 // Cloned from interface/main/calendar/.../views/day/default.html:
 function newEvt(startampm, starttimeh, starttimem, eventdate, providerid, patientid) {
  dlgopen('add_edit_event.php?startampm=' + startampm +
   '&starttimeh=' + starttimeh + '&starttimem=' + starttimem +
   '&date=' + eventdate + '&userid=' + providerid +
   '&patientid=' + patientid,
   '_blank', 550, 270);
 }

</script>

</head>
<body <?echo $bottom_bg_line;?> topmargin=0 rightmargin=0 leftmargin=2 bottommargin=0 marginwidth=2 marginheight=0 <?echo $body_code;?>>

<table border=0 cellpadding=3 cellspacing=0>
 <tr>
  <td width=150 valign=top>

<?
if ($userauthorized == 1) {
?>
   <span class='bold'>Patient&nbsp;Appointment</span>
<? if (empty($pnote_link)) { ?>
   <a class="more" style="font-size:8pt;"
    href="../authorizations/authorizations.php"
    name="Authorizations">(Authorizations)</a>
<? } if (!empty($pnote_link)) { ?>
   &nbsp;<a class="more" style="font-size:8pt;"
    href="../../patient_file/summary/pnotes.php" target="Notes"
    name="Patient Notes">(Patient&nbsp;Notes)</a>
<? } ?>
   <br>
<?
}
else {
?>
   <span class='bold'>Patient&nbsp;Appointment</span>
<?
}
?>
   <form name='findpatientform' action="find_patient.php?no_nav=1<?=$pnote_link?>" method='post'>
   <input type='hidden' name='mode' value="findpatient">
   <input name='lastname' size='15' value="<?echo $_SESSION["lastname"];?>"
    onfocus="javascript:document.findpatientform.lastname.value='';"><br>
   <select name="findBy" size='1'>
    <option value="ID">ID</option>
    <option value="Last" selected>Name</option>
    <option value="SSN">SSN</option>
    <option value="DOB">DOB</option>
   </select><br>
   <div align='right'>
    <a href="javascript:document.findpatientform.submit();" class='link_submit'>Search</a>
   </div>
   </form>
  </td>
  <td width='300' valign='top'>
<?
if ($lastname != "") {
?>
   <span class='bold'>Records Found</span>
   <a class='text' href="../../new/new_patient.php" target="_top">(New Patient)</a><br>
<?
  $count = 0;
  $total = 0;

  if ($findby == "Last") {
    $result = getPatientLnames("$lastname","*, DATE_FORMAT(DOB,'%m/%d/%Y') as DOB_TS");
  } elseif ($findby == "ID") {
    $result = getPatientId("$lastname","*, DATE_FORMAT(DOB,'%m/%d/%Y') as DOB_TS");
  } elseif ($findby == "DOB") {
    $result = getPatientDOB("$lastname","*, DATE_FORMAT(DOB,'%m/%d/%Y') as DOB_TS");
  } elseif ($findby == "SSN") {
    $result = getPatientSSN("$lastname","*, DATE_FORMAT(DOB,'%m/%d/%Y') as DOB_TS");
  }

  echo "<table>\n";
  echo "<tr><td><span class='text'>Name</span></td>" .
    "<td><span class='text'>SS</span></td>" .
    "<td><span class='text'>DOB</span></td>" .
    "<td><span class='text'>ID</span></td></tr>\n";

  //set ampm default for find patient results links event_startampm
  $ampm = 1;
  if (date("H") >= 12) {
    $ampm = 2;
  }
  //get the categories so you can get the details of the default category
  $dbconn = $GLOBALS['adodb']['db'];

  $sql = "SELECT pc_catid,pc_catname,pc_catcolor,pc_catdesc, " .
    "pc_recurrtype,pc_recurrspec,pc_recurrfreq,pc_duration, " .
    "pc_dailylimit,pc_end_date_flag,pc_end_date_type,pc_end_date_freq, " .
    "pc_end_all_day FROM openemr_postcalendar_categories " .
    "WHERE pc_catid = " . $GLOBALS['default_category'];
  $catresult = $dbconn->Execute($sql);

  $event_dur_minutes  = ($catresult->fields['pc_duration']%(60 * 60))/60;
  $event_dur_hours = ($catresult->fields['pc_duration']/(60 * 60));
  $event_title = $catresult->fields['pc_catname'];

  if ($result) {
    foreach ($result as $iter) {
      if ($total >= $M) {
        break;
      }
      echo "<tr>";

      $tmp = "<td><a class='link' href='javascript:newEvt($ampm," . date("H") .
        ",0," . date("Ymd") . "," . $iter["providerID"] . "," . $iter['pid'] .
        ")'>";

      echo $tmp . $iter['lname'] . ", " . $iter['fname'] . "</a></td>\n";
      echo $tmp . $iter['ss']                            . "</a></td>\n";
      echo $tmp . $iter['DOB_TS']                        . "</a></td>\n";
      echo $tmp . $iter['pubpid']                        . "</a></td>\n";

      echo "</tr>";
      $count++;
      $total++;
    }
  }

  echo "</table>\n";
}
?>
</td>

</tr>
</table>

</body>
</html>
