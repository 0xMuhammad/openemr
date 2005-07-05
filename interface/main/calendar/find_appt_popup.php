<?
 // Copyright (C) 2005 Rod Roark <rod@sunsetsystems.com>
 //
 // This program is free software; you can redistribute it and/or
 // modify it under the terms of the GNU General Public License
 // as published by the Free Software Foundation; either version 2
 // of the License, or (at your option) any later version.

 include_once("../../globals.php");
 include_once("$srcdir/patient.inc");

 // Record an event into the slots array for a specified day.
 function doOneDay($catid, $udate, $starttime, $duration) {
  global $slots, $slotsecs, $slotstime, $slotbase, $slotcount;
  $udate = strtotime($starttime, $udate);
  if ($udate < $slotstime) return;
  $i = (int) ($udate / $slotsecs) - $slotbase;
  $iend = (int) (($duration + $slotsecs - 1) / $slotsecs) + $i;
  if ($iend > $slotcount) $iend = $slotcount;
  if ($iend <= $i) $iend = $i + 1;
  for (; $i < $iend; ++$i) {
   if ($catid == 2) {        // in office
    $slots[$i] |= 1;
    break;
   } else if ($catid == 3) { // out of office
    $slots[$i] |= 2;
    break;
   } else { // all other events reserve time
    $slots[$i] |= 4;
   }
  }
 }

 // seconds per time slot
 $slotsecs = $GLOBALS['calendar_interval'] * 60;

 $info_msg = "";

 $searchdays = 7; // default to a 1-week lookahead
 if ($_REQUEST['searchdays']) $searchdays = $_REQUEST['searchdays'];

 // Get a start date.
 if ($_REQUEST['startdate'] && preg_match("/(\d\d\d\d)\D*(\d\d)\D*(\d\d)/",
     $_REQUEST['startdate'], $matches))
 {
  $sdate = $matches[1] . '-' . $matches[2] . '-' . $matches[3];
 } else {
  $sdate = date("Y-m-d");
 }

 // Get an end date - actually the date after the end date.
 preg_match("/(\d\d\d\d)\D*(\d\d)\D*(\d\d)/", $sdate, $matches);
 $edate = date("Y-m-d",
  mktime(0, 0, 0, $matches[2], $matches[3] + $searchdays, $matches[1]));

 // compute starting time slot number and number of slots.
 $slotstime = strtotime("$sdate 00:00:00");
 $slotetime = strtotime("$edate 00:00:00");
 $slotbase  = (int) ($slotstime / $slotsecs);
 $slotcount = (int) ($slotetime / $slotsecs) - $slotbase;

 if ($slotcount <= 0 || $slotcount > 100000) die("Invalid date range.");

 $slotsperday = (int) (60 * 60 * 24 / $slotsecs);

 // If we have a provider, search.
 //
 if ($_REQUEST['providerid']) {
  $providerid = $_REQUEST['providerid'];

  // Create and initialize the slot array. Values are bit-mapped:
  //   bit 0 = in-office occurs here
  //   bit 1 = out-of-office occurs here
  //   bit 2 = reserved
  // So, values may range from 0 to 7.
  //
  $slots = array_pad(array(), $slotcount, 0);

  // Note there is no need to sort the query results.
  $query = "SELECT pc_eventDate, pc_endDate, pc_startTime, pc_duration, " .
   "pc_recurrtype, pc_recurrspec, pc_alldayevent, pc_catid " .
   "FROM openemr_postcalendar_events WHERE " .
   "pc_aid = '$providerid' AND " .
   "((pc_endDate >= '$sdate' AND pc_eventDate < '$edate') OR " .
   "(pc_endDate = '0000-00-00' AND pc_eventDate >= '$sdate' AND pc_eventDate < '$edate'))";
  $res = sqlStatement($query);

  while ($row = sqlFetchArray($res)) {
   $thistime = strtotime($row['pc_eventDate'] . " 00:00:00");
   if ($row['pc_recurrtype']) {
    preg_match('/"event_repeat_freq_type";s:1:"(\d)"/', $row['pc_recurrspec'], $matches);
    $repeattype = $matches[1];
    $endtime = strtotime($row['pc_endDate'] . " 00:00:00") + (24 * 60 * 60);
    if ($endtime > $slotetime) $endtime = $slotetime;
    while ($thistime < $endtime) {
     doOneDay($row['pc_catid'], $thistime, $row['pc_startTime'], $row['pc_duration']);
     $adate = getdate($thistime);
     if ($repeattype == 0)        { // daily
      $adate['mday'] += 1;
     } else if ($repeattype == 1) { // weekly
      $adate['mday'] += 7;
     } else if ($repeattype == 2) { // monthly
      $adate['mon'] += 1;
     } else if ($repeattype == 3) { // yearly
      $adate['year'] += 1;
     } else if ($repeattype == 4) { // work days
      if ($adate['wday'] == 5)      // if friday, skip to monday
       $adate['mday'] += 3;
      else if ($adate['wday'] == 6) // saturday should not happen
       $adate['mday'] += 2;
      else
       $adate['mday'] += 1;
     } else {
      die("Invalid repeat type '$repeattype'");
     }
     $thistime = mktime(0, 0, 0, $adate['mon'], $adate['mday'], $adate['year']);
    }
   } else {
    doOneDay($row['pc_catid'], $thistime, $row['pc_startTime'], $row['pc_duration']);
   }
  }

  // Mark all slots reserved where the provider is not in-office.
  // Actually we could do this in the display loop instead.
  $inoffice = false;
  for ($i = 0; $i < $slotcount; ++$i) {
   if (($i % $slotsperday) == 0) $inoffice = false;
   if ($slots[$i] & 1) $inoffice = true;
   if ($slots[$i] & 2) $inoffice = false;
   if (! $inoffice) $slots[$i] |= 4;
  }
 }
?>
<html>
<head>
<title>Find Available Appointments</title>
<link rel=stylesheet href='<? echo $css_header ?>' type='text/css'>

<style>
td { font-size:10pt; }
</style>

<script language="JavaScript">

 function setappt(year,mon,mday,hours,minutes) {
  if (opener.closed || ! opener.setappt)
   alert('The destination form was closed; I cannot act on your selection.');
  else
   opener.setappt(year,mon,mday,hours,minutes);
  window.close();
  return false;
 }

</script>

</head>

<body <?echo $top_bg_line;?>>
<?
?>
<form method='post' name='theform' action='find_appt_popup.php?providerid=<? echo $providerid ?>'>
<center>

<table border='0' cellpadding='5' cellspacing='0'>

 <tr>
  <td height="1">
  </td>
 </tr>

 <tr bgcolor='#ddddff'>
  <td>
   <b>
   Start date:
   <input type='text' name='startdate' size='10' value='<? echo $sdate ?>'
    title='yyyy-mm-dd starting date for search' />
   for
   <input type='text' name='searchdays' size='3' value='<? echo $searchdays ?>'
    title='Number of days to search from the start date' />
   days&nbsp;
   <input type='submit' value='Search'>
   </b>
  </td>
 </tr>

 <tr>
  <td height="1">
  </td>
 </tr>

</table>

<? if (!empty($slots)) { ?>

<table border='0'>
 <tr>
  <td><b>Day</b></td>
  <td><b>Date</b></td>
  <td><b>Available Times</b></td>
 </tr>
<?
  $lastdate = "";
  for ($i = 0; $i < $slotcount; ++$i) {
   if ($slots[$i] >= 4) continue;
   $utime = ($slotbase + $i) * $slotsecs;
   $thisdate = date("Y-m-d", $utime);
   if ($thisdate != $lastdate) {
    if ($lastdate) {
     echo "</td>\n";
     echo " </tr>\n";
    }
    $lastdate = $thisdate;
    echo " <tr>\n";
    echo "  <td valign='top'>" . date("l", $utime) . "</td>\n";
    echo "  <td valign='top'>" . date("Y-m-d", $utime) . "</td>\n";
    echo "  <td valign='top'>";
   }
   $adate = getdate($utime);
   $anchor = "<a href='' onclick='return setappt(" .
    $adate['year'] . "," .
    $adate['mon'] . "," .
    $adate['mday'] . "," .
    $adate['hours'] . "," .
    $adate['minutes'] . ")'>";
   echo $anchor . date("H:i", $utime) . "</a> ";
  }
  if ($lastdate) {
   echo "</td>\n";
   echo " </tr>\n";
  } else {
   echo " <tr><td colspan='3'>No openings were found for this period.</td></tr>\n";
  }
?>
</table>

<? } ?>

</center>
</form>
</body>
</html>
