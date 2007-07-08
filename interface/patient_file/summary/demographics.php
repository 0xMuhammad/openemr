<?php
 require_once("../../globals.php");
 require_once("$srcdir/patient.inc");
 require_once("$srcdir/acl.inc");
 require_once("$srcdir/classes/Address.class.php");
 require_once("$srcdir/classes/InsuranceCompany.class.php");

 if ($GLOBALS['concurrent_layout'] && $_GET['set_pid']) {
  include_once("$srcdir/pid.inc");
  setpid($_GET['set_pid']);
 }

function print_as_money($money) {
	preg_match("/(\d*)\.?(\d*)/",$money,$moneymatches);
	$tmp = wordwrap(strrev($moneymatches[1]),3,",",1);
	$ccheck = strrev($tmp);
	if ($ccheck[0] == ",") {
		$tmp = substr($ccheck,1,strlen($ccheck)-1);
	}
	if ($moneymatches[2] != "") {
		return "$ " . strrev($tmp) . "." . $moneymatches[2];
	} else {
		return "$ " . strrev($tmp);
	}
}

/****
function get_billing_note($pid) {
	$conn = $GLOBALS['adodb']['db'];
	$billing_note = "";
	$sql = "select genericname2, genericval2 " .
		"from patient_data where pid = '$pid' limit 1";
	$resnote = $conn->Execute($sql);
	if($resnote && !$resnote->EOF && $resnote->fields['genericname2'] == 'Billing') {
		$billing_note = $resnote->fields['genericval2'];
	}
	return $billing_note;
}
****/

function get_patient_balance($pid) {
	require_once($GLOBALS['fileroot'] . "/library/classes/WSWrapper.class.php");
	$conn = $GLOBALS['adodb']['db'];
	$customer_info['id'] = 0;
	$sql = "SELECT foreign_id FROM integration_mapping AS im " .
		"LEFT JOIN patient_data AS pd ON im.local_id = pd.id WHERE " .
		"pd.pid = '" . $pid . "' AND im.local_table = 'patient_data' AND " .
		"im.foreign_table = 'customer'";
	$result = $conn->Execute($sql);
	if($result && !$result->EOF) {
		$customer_info['id'] = $result->fields['foreign_id'];
	}
	$function['ezybiz.customer_balance'] = array(new xmlrpcval($customer_info,"struct"));
	$ws = new WSWrapper($function);
	if(is_numeric($ws->value)) {
		return sprintf('%01.2f', $ws->value);
	}
	return '';
}

?>
<html>

<head>
<link rel=stylesheet href="<?echo $css_header;?>" type="text/css">
<script type="text/javascript" src="../../../library/dialog.js"></script>
<script language="JavaScript">

 function oldEvt(eventid) {
  dlgopen('../../main/calendar/add_edit_event.php?eid=' + eventid, '_blank', 550, 270);
 }

 function refreshme() {
  location.reload();
 }

 // Process click on Delete link.
 function deleteme() {
  dlgopen('../deleter.php?patient=<?php echo $pid ?>', '_blank', 500, 450);
  return false;
 }

 // Called by the deleteme.php window on a successful delete.
 function imdeleted() {
<?php if ($GLOBALS['concurrent_layout']) { ?>
  parent.left_nav.clearPatient();
<?php } else { ?>
  top.location.href = '../main/main_screen.php';
<?php } ?>
 }

</script>
</head>

<body <?echo $top_bg_line;?> topmargin=0 rightmargin=0 leftmargin=2 bottommargin=0 marginwidth=2 marginheight=0>

<?php
 $result = getPatientData($pid);
 $result2 = getEmployerData($pid);

 $thisauth = acl_check('patients', 'demo');
 if ($thisauth) {
  if ($result['squad'] && ! acl_check('squads', $result['squad']))
   $thisauth = 0;
 }

 if (!$thisauth) {
  echo "<p>(".xl('Demographics not authorized').")</p>\n";
  echo "</body>\n</html>\n";
  exit();
 }

 if ($thisauth == 'write') {
  echo "<p><a href='demographics_full.php'";
   if (! $GLOBALS['concurrent_layout']) echo " target='Main'";
   echo "><font class='title'>" . xl('Demographics') . "</font>" .
   "<font class='more'>$tmore</font></a>";
  if (acl_check('admin', 'super')) {
   echo "&nbsp;&nbsp;<a href='' onclick='return deleteme()'>" .
    "<font class='more' style='color:red'>(".xl('Delete').")</font></a>";
  }
  echo "</p>\n";
 }

// Get the document ID of the patient ID card if access to it is wanted here.
$document_id = 0;
if ($GLOBALS['patient_id_category_name']) {
  $tmp = sqlQuery("SELECT d.id, d.date, d.url FROM " .
    "documents AS d, categories_to_documents AS cd, categories AS c " .
    "WHERE d.foreign_id = $pid " .
    "AND cd.document_id = d.id " .
    "AND c.id = cd.category_id " .
    "AND c.name LIKE '" . $GLOBALS['patient_id_category_name'] . "' " .
    "ORDER BY d.date DESC LIMIT 1");
  if ($tmp) $document_id = $tmp['id'];
}
?>

<table border="0" width="100%">
 <tr>
  <td align="left" valign="top">
   <table border='0' cellpadding='0' width='100%'>
    <tr>
     <td valign='top' width='33%'>
      <span class='bold'><?php xl('Name','e'); ?>: </span>
      <span class='text'>
<?php
if ($document_id) echo "<a href='/openemr/controller.php?document&retrieve" .
  "&patient_id=$pid&document_id=$document_id' style='color:#00cc00'>";
if (!$GLOBALS['omit_employers']) echo $result['title'] . ' ';
echo $result['fname'] . ' ' . $result['mname'] . ' ' . $result['lname'];
if ($document_id) echo "</a>";
?>
      </span><br>
      <span class='bold'><? xl('Number','e'); ?>: </span><span class='text'><?echo $result{"pubpid"}?></span>
     </td>
     <td valign='top' width='33%'>
<?
 if ($result{"DOB"} && $result{"DOB"} != "0000-00-00") {
?>
      <span class='bold'><? xl('DOB','e'); ?>: </span>
      <span class='text'>
<?
  echo $result{"DOB"};
 }
?>
      </span><br>
<?php if ($result{"ss"} != "") { ?>
      <span class='bold'><?php xl('S.S.','e'); ?>: </span>
<?php } ?>
      <span class='text'><?php echo $result{"ss"} ?></span>
     </td>
     <td valign='top' width='34%'>
<?php if ($result{"sex"} != "") { ?>
      <span class='bold'><?php xl('Sex','e'); ?>: </span>
<?php } ?>
      <span class='text'><?php echo $result{"sex"} ?></span>
     </td>
    </tr>
    <tr>
     <td valign='top'>
<?php if (($result{"street"} != "") || ($result{"city"} != "") || ($result{"state"} != "") || ($result{"country_code"} != "") || ($result{"postal_code"} != "")) {?>
      <span class='bold'><? xl('Address','e'); ?>: </span>
<?php } ?>
      <br><span class='text'><?echo $result{"street"}?><br><?echo $result{"city"}?><?if($result{"city"} != ""){echo ", ";}?><?echo $result{"state"};?>
<? if($result{"country_code"} != ""){ echo ", "; }?><?echo $result{"country_code"}?>
<?echo " ";
echo $result{"postal_code"}?>
      </span>
     </td>
     <td valign='top'>
<?
	if (	($result{"contact_relationship"} != "") ||
		($result{"phone_contact"} != "") ||
		($result{"phone_home"} != "") ||
		($result{"phone_biz"} != "") ||
		($result{"email"} != "")  ||
		($result{"phone_cell"} != "")    ){
?>
      <span class='bold'><? xl('Emergency Contact','e'); ?>: </span><?}?><span class='text'><?echo $result{"contact_relationship"}?><?echo " "?>
<?
	if ($result{"phone_contact"} != "") {
		echo " " . $result{"phone_contact"};
	}
	if ($result{"phone_home"} != "") {
		echo "<br><span class='bold'>Home:</span> ";
		echo $result{"phone_home"};
	}
	if ($result{"phone_biz"} != "") {
		echo "<br><span class='bold'>Work:</span> ";
		echo $result{"phone_biz"};
	}
	if ($result{"phone_cell"} != "") {
		echo "<br><span class='bold'>Mobile:</span> ";
		echo $result{"phone_cell"};
	}
	if ($result{"email"} != "") {
		echo "<br><span class='bold'>".xl('Email').": </span>";
		echo '<a class=link_submit href="mailto:' . $result{"email"} . '">' . $result{"email"} . '</a>';
	}
?>
     </td>
     <td valign='top'>
<?
	if ($result{"status"} != "") {
		echo "<span class='bold'>".xl('Marital Status').": </span>";
		echo "<span class='text'>" .  $result{"status"} . "</span>";
	}
?>
     </td>
    </tr>

<?php if (!$GLOBALS['athletic_team']) { ?>
    <tr>
     <td colspan='3' valign='top'>
	<?php
		$opt_out = ($result{"hipaa_mail"} == 'YES') ? 'ALLOWS' : 'DOES NOT ALLOW';
		echo "<span class='text'>Patient $opt_out Mailed Information </span>";
	?>
     </td>
    </tr>
    <tr>
     <td colspan='2' valign='top'>
	<?php
		$opt_out = ($result{"hipaa_voice"} == 'YES') ? 'ALLOWS' : 'DOES NOT ALLOW';
		echo "<span class='text'>Patient $opt_out Voice Messages </span>";
	?>
     </td>
     <td colspan='1' valign='top'>
<?php
	echo "<span class='bold'><font color='#ee6600'>Balance Due: $" .
		get_patient_balance($pid) . "</font>";
	if ($result['genericname2'] == 'Billing')
		echo "<br>" . xl('Billing Note') . ":";
	echo "</span>";
?>
     </td>
    </tr>
    <tr>
     <td colspan='2' valign='top'>
<?php
		$opt_out = ($result{"hipaa_notice"} == 'YES') ? 'RECEIVED' : 'DID NOT RECEIVE';
		echo "<span class='text'>Patient $opt_out Notice Information </span>";
?>
     </td>
     <td colspan='1' valign='top'>
<?php
	if ($result['genericname2'] == 'Billing')
		echo "<span class='bold'><font color='red'>" .
		$result['genericval2'] . "</font></span>";
?>
     </td>
    </tr>
    <tr>
     <td colspan='3' valign='top'>
	<?php
		if ( $result["hipaa_message"] == "" ) {
			echo "<span class='text'><b>Leave a message with :</b> " .
				$result{"fname"} . " " . $result{"mname"} . " " .
				$result{"lname"} . "</span>";
		}
		else {
			echo "<span class='text'><b>Leave a message with :</b> " .
				$result{"hipaa_message"} . "</span>";
		}
	?>
     </td>
    </tr>

<?php } else { ?>
    <tr>
     <td colspan='3' valign='top'>
      &nbsp;
     </td>
    </tr>
<?php } ?>

<?php if ($GLOBALS['omit_employers']) { ?>

    <tr>
     <td valign='top' colspan='2'>
      <table>
       <tr>
        <td><span class='bold'>Listed Family Members:</span></td>
        <td>&nbsp;</td>
       </tr>
       <tr>
        <td><?php if ($result{"genericname1"} != "") { ?><span class='text'>&nbsp;&nbsp;&nbsp;<?=$result{"genericname1"}?></span><?php } ?></td>
        <td><?php if ($result{"genericval1"} != "") { ?><span class='text'>&nbsp;&nbsp;&nbsp;<?=$result{"genericval1"}?></span><?php } ?></td>
       </tr>
       <tr>
        <td><?php if ($result{"genericname2"} != "") { ?><span class='text'>&nbsp;&nbsp;&nbsp;<?=$result{"genericname2"}?></span><?php } ?></td>
        <td><?php if ($result{"genericval2"} != "") { ?><span class='text'>&nbsp;&nbsp;&nbsp;<?=$result{"genericval2"}?></span><?php } ?></td>
       </tr>
      </table>
     </td>
     <td valign='top'></td>
    </tr>

<?php } else { ///// end omit_employers ///// ?>

    <tr>
     <td valign='top'>
<?php if ($result{"occupation"} != "") { ?>
      <span class='bold'><?php xl('Occupation','e'); ?>: </span><span class='text'><?echo $result{"occupation"}?></span><br>
<?php } ?>
<?php if ($result2{"name"} != "") { ?>
      <span class='bold'><?php xl('Employer','e'); ?>: </span><span class='text'><?php echo $result2{"name"} ?></span>
<?php } ?>
     </td>
     <td valign='top'>
<?php if (($result2{"street"} != "") || ($result2{"city"} != "") || ($result2{"state"} != "") || ($result2{"country"} != "") || ($result2{"postal_code"} != "")) { ?>
      <span class='bold'><? xl('Employer Address','e'); ?>:</span>
      <br>
      <span class='text'>
<?php echo $result2{"street"}?><br><?php echo $result2{"city"} ?><?php if($result2{"city"} != "") { echo ", "; } ?><?php echo $result2{"state"} ?>
<?php if($result2{"country"} != "") { echo ", "; } echo $result2{"country"} ?>
<?php if($result2{"postal_code"} != "") {echo " "; } ?>
<?php echo $result2{"postal_code"} ?>
      </span>
<?php } ?>
     </td>
     <td valign='top'>
<?php
 // This stuff only applies to athletic team use of OpenEMR:
 if ($GLOBALS['athletic_team']) {
  //                  blue       dk green   yellow     red        orange
  $fitcolors = array('#6677ff', '#00cc00', '#ffff00', '#ff3333', '#ff8800', '#ffeecc', '#ffccaa');
  $fitcolor = $fitcolors[0];
  $fitness = $_POST['form_fitness'];
  if ($fitness) {
   sqlStatement("UPDATE patient_data SET fitness = '$fitness' WHERE pid = '$pid'");
  } else {
   $fitness = $result['fitness'];
   if (! $fitness) $fitness = 1;
  }
  $fitcolor = $fitcolors[$fitness - 1];
?>
      <form method='post' action='demographics.php'>
      <span class='bold'><? xl('Fitness to Play','e'); ?>:</span><br>
      <select name='form_fitness' onchange='document.forms[0].submit()' style='background-color:<? echo $fitcolor ?>'>
       <option value='1'<? if ($fitness == 1) echo ' selected' ?>><? xl('Full Play','e'); ?></option>
       <option value='2'<? if ($fitness == 2) echo ' selected' ?>><? xl('Full Training','e'); ?></option>
       <option value='3'<? if ($fitness == 3) echo ' selected' ?>><? xl('Restricted Training','e'); ?></option>
       <option value='4'<? if ($fitness == 4) echo ' selected' ?>><? xl('Injured Out','e'); ?></option>
       <option value='5'<? if ($fitness == 5) echo ' selected' ?>><? xl('Rehabilitation','e'); ?></option>
       <option value='6'<? if ($fitness == 6) echo ' selected' ?>><? xl('Illness','e'); ?></option>
       <option value='7'<? if ($fitness == 7) echo ' selected' ?>><? xl('International Duty','e'); ?></option>
      </select>
      </form>
<?php } // end athletic team ?>
     </td>
    </tr>
    <tr>
     <td valign='top'>
<?php if (! $GLOBALS['athletic_team']) { ?>
<?php if ($result{"ethnoracial"} != "")  { ?><span class='bold'><? xl('Race/Ethnicity','e'); ?>: </span><span class='text'><?echo $result{"ethnoracial"};?></span><br><? } ?>
<?php if ($result{"language"} != "")     { ?><span class='bold'><? xl('Language','e'); ?>: </span><span class='text'><?echo ucfirst($result{"language"});?></span><br><? } ?>
<?php if ($result{"interpretter"} != "") { ?><span class='bold'><? xl('Interpreter','e'); ?>: </span><span class='text'><?echo $result{"interpretter"};?></span><br><? } ?>
<?php if ($result{"family_size"} != "")  { ?><span class='bold'><? xl('Family Size','e'); ?>: </span><span class='text'><?echo $result{"family_size"};?></span><br><? } ?>
<?php } ?>
     </td>
     <td valign='top'>
<?php if (! $GLOBALS['athletic_team']) { ?>
<?php if ($result{"financial_review"} != "0000-00-00 00:00:00") {?><span class='bold'><? xl('Financial Review Date','e'); ?>: </span><span class='text'><?echo date("n/j/Y",strtotime($result{"financial_review"}));?></span><br><?}?>
<?php if ($result{"monthly_income"} != "") {?><span class='bold'><? xl('Monthly Income','e'); ?>: </span><span class='text'><?echo print_as_money($result{"monthly_income"});?></span><br><?}?>
<?php if ($result{"migrantseasonal"} != "") {?><span class='bold'><? xl('Migrant/Seasonal','e'); ?>: </span><span class='text'><?echo $result{"migrantseasonal"};?></span><br><?}?>
<?php if ($result{"homeless"} != "") {?><span class='bold'><? xl('Homeless, etc','e'); ?>.: </span><span class='text'><?echo $result{"homeless"};?></span><br><?}?>
<?php } ?>
     </td>
     <td valign='top'>
      <table>
       <tr>
        <td><? if ($result{"genericname1"} != "") {?><span class='bold'><?=$result{"genericname1"}?></span>:<?}?> </td>
        <td><? if ($result{"genericval1"} != "") {?><span class='text'><?=$result{"genericval1"}?></span><?}?></td>
       </tr>
       <tr>
        <td><? if ($result{"genericname2"} != "") {?><span class='bold'><?=$result{"genericname2"}?></span>:<?}?> </td>
        <td><? if ($result{"genericval2"} != "") {?><span class='text'><?=$result{"genericval2"}?></span><?}?></td>
       </tr>
      </table>
     </td>
    </tr>

<?php } ///// end not omit_employers ///// ?>

<?php

//////////////////////////////////REFERRAL SECTION

if ($result{"referrer"} != "" || $result{"referrerID"} != "")
{
?>
    <tr>
     <td valign='top' colspan='3'>
      <span class='bold'><? xl('Primary Provider','e'); ?>: </span><span class='text'><?=getProviderName($result['providerID'])?></span><br>
      <!--<span class='bold'>Primary Provider ID: </span><span class='text'><?=$result{"referrerID"}?></span>-->
     </td>
    </tr>
<?php
}

///////////////////////////////// INSURANCE SECTION

foreach (array('primary','secondary','tertiary') as $instype) {
  $enddate = 'Present';

  $query = "SELECT * FROM insurance_data WHERE " .
    "pid = '$pid' AND type = '$instype' " .
    "ORDER BY date DESC";
  $res = sqlStatement($query);
  while ($row = sqlFetchArray($res)) {
    if ($row['provider']) {
      $icobj = new InsuranceCompany($row['provider']);
      $adobj = $icobj->get_address();
      $insco_name = trim($icobj->get_name());
?>
    <tr>
     <td valign='top' colspan='3'>
      <br><span class='bold'>
      <?php if (strcmp($enddate, 'Present') != 0) echo "Old "; ?>
      <?php xl(ucfirst($instype) . ' Insurance','e'); ?>
<?php if (strcmp($row['date'], '0000-00-00') != 0) { ?>
      <?php xl(' from','e'); echo ' ' . $row['date']; ?>
<?php } ?>
      <?php xl(' until ','e'); echo $enddate; ?>
      :</span>
     </td>
    </tr>
    <tr>
     <td valign='top'>
      <span class='text'>
<?php
      if ($insco_name) {
        echo $insco_name . '<br>';
        if (trim($adobj->get_line1())) {
          echo $adobj->get_line1() . '<br>';
          echo $adobj->get_city() . ', ' . $adobj->get_state() . ' ' . $adobj->get_zip();
        }
      } else {
        echo "<font color='red'><b>Unassigned</b></font>";
      }
?>
      <br>
      <?php xl('Policy Number','e'); ?>: <?php echo $row['policy_number'] ?><br>
      Plan Name: <?php echo $row['plan_name']; ?><br>
      Group Number: <?echo $row['group_number']; ?></span>
     </td>
     <td valign='top'>
      <span class='bold'><?php xl('Subscriber','e'); ?>: </span><br>
      <span class='text'><?php echo $row['subscriber_fname'] . ' ' . $row['subscriber_mname'] . ' ' . $row['subscriber_lname'] ?>
<?php
      if ($row['subscriber_relationship'] != "") {
        echo "(" . $row['subscriber_relationship'] . ")";
      }
?>
      <br>
      S.S.: <?php echo $row['subscriber_ss']; ?><br>
      <?php xl('D.O.B.','e'); ?>:
      <?php if ($row['subscriber_DOB'] != "0000-00-00 00:00:00") echo $row['subscriber_DOB']; ?><br>
      Phone: <?php echo $row['subscriber_phone'] ?>
      </span>
     </td>
     <td valign='top'>
      <span class='bold'><?php xl('Subscriber Address','e'); ?>: </span><br>
      <span class='text'><?php echo $row['subscriber_street']; ?><br>
      <?php echo $row['subscriber_city']; ?>
      <?php if($row['subscriber_state'] != "") echo ", "; echo $row['subscriber_state']; ?>
      <?php if($row['subscriber_country'] != "") echo ", "; echo $row['subscriber_country']; ?>
      <?php echo " " . $row['subscriber_postal_code']; ?></span>

<?php if (trim($row['subscriber_employer'])) { ?>
      <br><span class='bold'><?php xl('Subscriber Employer','e'); ?>: </span><br>
      <span class='text'><?php echo $row['subscriber_employer']; ?><br>
      <?php echo $row['subscriber_employer_street']; ?><br>
      <?php echo $row['subscriber_employer_city']; ?>
      <?php if($row['subscriber_employer_city'] != "") echo ", "; echo $row['subscriber_employer_state']; ?>
      <?php if($row['subscriber_employer_country'] != "") echo ", "; echo $row['subscriber_employer_country']; ?>
      <?php echo " " . $row['subscriber_employer_postal_code']; ?>
      </span>
<?php } ?>

     </td>
    </tr>
    <tr>
     <td>
<?php if ($row['copay'] != "") { ?>
      <span class='bold'><?php xl('CoPay','e'); ?>: </span>
      <span class='text'><?php echo $row['copay']; ?></span>
<?php } ?>
     </td>
     <td valign='top'></td>
     <td valign='top'></td>
   </tr>
<?php
    } // end if ($row['provider'])
    $enddate = $row['date'];
  } // end while
} // end foreach

///////////////////////////////// END INSURANCE SECTION

?>
   </table>
  </td>
  <td valign="top" class="text">
<?php
if (isset($pid)) {
 $query = "SELECT e.pc_eid, e.pc_aid, e.pc_title, e.pc_eventDate, " .
  "e.pc_startTime, u.fname, u.lname, u.mname " .
  "FROM openemr_postcalendar_events AS e, users AS u WHERE " .
  "e.pc_pid = '$pid' AND e.pc_eventDate >= CURRENT_DATE AND " .
  "u.id = e.pc_aid " .
  "ORDER BY e.pc_eventDate, e.pc_startTime";
 $res = sqlStatement($query);
 while($row = sqlFetchArray($res)) {
  $dayname = date("l", strtotime($row['pc_eventDate']));
  $dispampm = "am";
  $disphour = substr($row['pc_startTime'], 0, 2) + 0;
  $dispmin  = substr($row['pc_startTime'], 3, 2);
  if ($disphour >= 12) {
   $dispampm = "pm";
   if ($disphour > 12) $disphour -= 12;
  }
  echo "<a href='javascript:oldEvt(" . $row['pc_eid'] .
       ")'><b>$dayname " . $row['pc_eventDate'] . "</b><br>";
  echo "$disphour:$dispmin $dispampm " . $row['pc_title'] . "<br>\n";
  echo $row['fname'] . " " . $row['lname'] . "</a><br>&nbsp;<br>\n";
 }
}
?>
  </td>
 </tr>
</table>

<?php if ($GLOBALS['concurrent_layout'] && $_GET['set_pid']) { ?>
<script language='JavaScript'>
 parent.left_nav.setPatient(<?php echo "'" . $result['fname'] . " " . $result['lname'] . "',$pid,''"; ?>);
 parent.left_nav.setRadio(window.name, 'dem');
<?php if (!$_GET['is_new']) { // if new pt, do not load other frame ?>
 var othername = (window.name == 'RTop') ? 'RBot' : 'RTop';
 parent.left_nav.setRadio(othername, 'sum');
 parent.left_nav.loadFrame(othername, 'patient_file/summary/summary_bottom.php');
<?php } ?>
</script>
<?php } ?>

</body>
</html>
