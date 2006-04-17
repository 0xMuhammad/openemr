<?
 include_once("../../globals.php");
 include_once("$srcdir/forms.inc");
 include_once("$srcdir/billing.inc");
 include_once("$srcdir/pnotes.inc");
 include_once("$srcdir/patient.inc");
 include_once("$srcdir/report.inc");
 include_once(dirname(__file__) . "/../../../library/classes/Document.class.php");
 include_once(dirname(__file__) . "/../../../library/classes/Note.class.php");

 $N = 6;
 $first_issue = 1;

 function postToGet($arin) {
  $getstring="";
  foreach ($arin as $key => $val) {
   if (is_array($val)) {
    foreach ($val as $k => $v) {
     $getstring .= urlencode($key . "[]") . "=" . urlencode($v) . "&";
    }
   }
   else {
    $getstring .= urlencode($key) . "=" . urlencode($val) . "&";
   }
  }
  return $getstring;
 }
?>
<html>
<head>
<link rel=stylesheet href="<?echo $css_header;?>" type="text/css">
</head>

<body <?echo $top_bg_line;?> topmargin='0' rightmargin='0' leftmargin='2'
 bottommargin='0' marginwidth='2' marginheight='0'>

<?
 if (sizeof($_GET) > 0) {
  $ar = $_GET;
 } else {
  $ar = $_POST;
 }
?>

<a href="patient_report.php">
 <font class='title'><? xl('Patient Report','e'); ?></font>
 <font class='back'><?echo $tback;?></font>
</a><br><br>

<a href="print_custom_report.php?<?print postToGet($ar);?>" class='link_submit' target='new'>
 [<? xl('Printable Version','e'); ?>]
</a><br>

<?
 $inclookupres = sqlStatement("select distinct formdir from forms where pid = '$pid'");
 while($result = sqlFetchArray($inclookupres)) {
  include_once("{$GLOBALS['incdir']}/forms/" . $result{"formdir"} . "/report.php");
 }

 // For each form field from patient_report.php...
 //
 foreach ($ar as $key => $val) {

  // These are the top checkboxes (demographics, allergies, etc.).
  //
  if (stristr($key,"include_")) {
   //print "include: $val<br>\n";

   if ($val == "demographics") {

    print "<br><font class='bold'>".xl('Patient Data').":</font><br>";
    printRecDataOne($patient_data_array, getRecPatientData ($pid), $N);

   } elseif ($val == "history") {

    print "<br><font class='bold'>".xl('History Data').":</font><br>";
    printRecDataOne($history_data_array, getRecHistoryData ($pid), $N);

   } elseif ($val == "employer") {

    print "<br><font class='bold'>".xl('Employer Data').":</font><br>";
    printRecDataOne($employer_data_array, getRecEmployerData ($pid), $N);

   } elseif ($val == "insurance") {

    print "<br><font class=bold>".xl('Primary Insurance Data').":</font><br>";
    printRecDataOne($insurance_data_array, getRecInsuranceData ($pid,"primary"), $N);		
    print "<font class=bold>".xl('Secondary Insurance Data').":</font><br>";	
    printRecDataOne($insurance_data_array, getRecInsuranceData ($pid,"secondary"), $N);
    print "<font class=bold>".xl('Tertiary Insurance Data').":</font><br>";
    printRecDataOne($insurance_data_array, getRecInsuranceData ($pid,"tertiary"), $N);

   } elseif ($val == "billing") {

    print "<br><font class=bold>".xl('Billing Information').":</font><br>";
    if (count($ar['newpatient']) > 0) {
     $billings = array();
     echo "<table>";
     echo "<tr><td width='400' class='bold'>Code</td><td class='bold'>".xl('Fee')."</td></tr>\n";
     $total = 0.00;
     $copays = 0.00;
     foreach ($ar['newpatient'] as $be) {
      $ta = split(":",$be);
      $billing = getPatientBillingEncounter($pid,$ta[1]);
      $billings[] = $billing;
      foreach ($billing as $b) {
       echo "<tr>\n";
       echo "<td class=text>";
       echo $b['code_type'] . ":\t" . $b['code'] . "&nbsp;". $b['modifier'] . "&nbsp;&nbsp;&nbsp;" . $b['code_text'] . "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
       echo "</td>\n";
       echo "<td class=text>";
       echo $b['fee'];
       echo "</td>\n";
       echo "</tr>\n";
       $total += $b['fee'];
       if ($b['code_type'] == "COPAY") {
        $copays += $b['fee'];
       }
      }
     }
     echo "<tr><td>&nbsp;</td></tr>";
     echo "<tr><td class=bold>".xl('Sub-Total')."</td><td class=text>" . sprintf("%0.2f",$total + abs($copays)) . "</td></tr>";
     echo "<tr><td class=bold>".xl('Paid')."</td><td class=text>" . sprintf("%0.2f",abs($copays)) . "</td></tr>";
     echo "<tr><td class=bold>".xl('Total')."</td><td class=text>" . sprintf("%0.2f",$total) . "</td></tr>";
     echo "</table>";
     echo "<pre>";
     //print_r($billings);
     echo "</pre>";
    }
    else {
     printPatientBilling($pid);
    }

   /****

   } elseif ($val == "allergies") {

    print "<font class=bold>Patient Allergies:</font><br>";
    printListData($pid, "allergy", "1");

   } elseif ($val == "medications") {

    print "<font class=bold>Patient Medications:</font><br>";
    printListData($pid, "medication", "1");

   } elseif ($val == "medical_problems") {

    print "<font class=bold>Patient Medical Problems:</font><br>";
    printListData($pid, "medical_problem", "1");

   ****/

   } elseif ($val == "immunizations") {

    print "<font class=bold>".xl('Patient Immunization').":</font><br>";
    $sql = "select if(i1.administered_date,concat(i1.administered_date,' - ',i2.name) ,substring(i1.note,1,20) ) as immunization_data from immunizations i1 left join immunization i2 on i1.immunization_id = i2.id where i1.patient_id = $pid order by administered_date desc";
    $result = sqlStatement($sql);
    while ($row=sqlFetchArray($result)) {
     echo "<span class=text> " . $row{'immunization_data'} . "</span><br>\n";
    }
   // communication report
   } elseif ($val == "batchcom") {

	   print "<font class=bold>".xl('Patient Communication sent').":</font><br>";
	   $sql="SELECT concat( 'Messsage Type: ', batchcom.msg_type, ', Message Subject: ', batchcom.msg_subject, ', Sent on:', batchcom.msg_date_sent ) AS batchcom_data, batchcom.msg_text, concat( users.fname, users.lname ) AS user_name FROM `batchcom` JOIN `users` ON users.id = batchcom.sent_by WHERE batchcom.patient_id='$pid'";
	   // echo $sql;
	   $result = sqlStatement($sql);
	   while ($row=sqlFetchArray($result)) {
			 echo "<span class=text>".$row{'batchcom_data'}.", By: ".$row{'user_name'}."<br>Text:<br> ".$row{'msg_txt'}."</span><br>\n";
	    }

   } elseif ($val == "notes") {

    print "<font class=bold>".xl('Patient Notes').":</font><br>";
    printPatientNotes($pid);

   } elseif ($val == "transactions") {

    print "<font class=bold>".xl('Patient Transactions').":</font><br>";
    printPatientTransactions($pid);

   }

  } else {

   // Documents is an array of checkboxes whose values are document IDs.
   //
   if ($key == "documents") {
    echo "<br><br>";
    foreach($val as $valkey => $valvalue) {
     $document_id = $valvalue;
     if (!is_numeric($document_id)) continue;
     $d = new Document($document_id);
     $fname = basename($d->get_url());
     $extension = substr($fname, strrpos($fname,"."));
     echo "Document '" . $fname ."'<br>";
     $notes = Note::notes_factory($d->get_id());
     echo "<table>";
     foreach ($notes as $note) {
      echo '<tr>';
      echo '<td>Note #' . $note->get_id() . '</td>';
      echo '</tr>';
      echo '<tr>';
      echo '<td>Date: '.$note->get_date().'</td>';
      echo '</tr>';
      echo '<tr>';
      echo '<td>'.$note->get_note().'<br><br></td>';
      echo '</tr>';
     }
     echo "</table>";
     if ($extension == ".png" || $extension == ".jpg" || $extension == ".jpeg" || $extension == ".gif") {
      echo '<img src="' . $GLOBALS['webroot'] . "/controller.php?document&retrieve&patient_id=&document_id=" . $document_id . '"><br><br>';
     }
     else {
      echo "<b>NOTE</b>: ".xl('Document')."'" . $fname ."' ".xl('cannot be displayed inline because its type is not supported by the browser.')."<br><br>";	
     }
    }
   }

   else if (strpos($key, "issue_") === 0) {

    if ($first_issue) {
     $first_issue = 0;
     echo "<br>\n";
    }
    preg_match('/^(.*)_(\d+)$/', $key, $res);
    $rowid = $res[2];
    $irow = sqlQuery("SELECT type, title, comments, diagnosis " .
     "FROM lists WHERE id = '$rowid'");
    $diagnosis = $irow['diagnosis'];
    echo "<span class='bold'>" . $irow['title'] . ":</span><span class='text'> " .
     $irow['comments'] . "</span><br>\n";
    // Show issue's chief diagnosis and its description:
    if ($diagnosis) {
     $crow = sqlQuery("SELECT code_text FROM codes WHERE " .
      "code = '$diagnosis' AND " .
      "(code_type = 2 OR code_type = 4 OR code_type = 5)" .
      "LIMIT 1");
     echo "<span class='bold'>&nbsp;".xl('Diagnosis').": </span><span class='text'>" .
      $irow['diagnosis'] . " " . $crow['code_text'] . "</span><br>\n";
    }
   }

   // Otherwise we have an "encounter form" form field whose name is like
   // dirname_formid, with a value which is the encounter ID.
   //
   else {

    $form_encounter = $val;
    preg_match('/^(.*)_(\d+)$/', $key, $res);
    $form_id = $res[2];
    $formres = getFormNameByFormdir($res[1]);
    $dateres = getEncounterDateByEncounter($form_encounter);
    if ($res[1] == 'newpatient') print "<br>\n";
    print "<span class='bold'>" . $formres{"form_name"} .
     "</span><span class=text>(" . date("Y-m-d",strtotime($dateres{"date"})) .
     ")" . "</span><br>\n";
    call_user_func($res[1] . "_report", $pid, $form_encounter, $N, $form_id);
    if ($res[1] == 'newpatient') {
     $bres = sqlStatement("SELECT date, code, code_text FROM billing WHERE " .
      "pid = '$pid' AND encounter = '$form_encounter' AND activity = 1 AND " .
      "(code_type = 'CPT4' OR code_type = 'OPCS') " .
      "ORDER BY date");
     while ($brow=sqlFetchArray($bres)) {
      echo "<span class='bold'>&nbsp;".xl('Procedure').": </span><span class='text'>" .
        $brow['code'] . " " . $brow['code_text'] . "</span><br>\n";
     }
    }

   }

  }
 }
?>

</body>
</html>
