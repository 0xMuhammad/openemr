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
function postToGet($arin) {
$getstring="";
foreach ($arin as $key => $val) {
$getstring.=urlencode($key)."=".urlencode($val)."&";
}
return $getstring;
}
?>

<html>
<head>


<link rel=stylesheet href="<?echo $css_header;?>" type="text/css">


</head>
<body bgcolor="#ffffff" topmargin=0 rightmargin=0 leftmargin=2 bottommargin=0 marginwidth=2 marginheight=0>

<?
if (sizeof($_GET) > 0) {
$ar = $_GET;
} else {
$ar = $_POST;
}

$titleres = getPatientData($pid, "fname,lname,providerID");
$sql = "select * from facility where billing_location = 1";
$db = $GLOBALS['adodb']['db'];
$results = $db->Execute($sql);
$facility = array();
if (!$results->EOF) {
	$facility = $results->fields; 	
} 

?>
<p>
<h2><?=$facility['name']?></h2>
<?=$facility['street']?><br>
<?=$facility['city']?>, <?=$facility['state']?> <?=$facility['postal_code']?><br>

</p>

<a href="javascript:window.close();"><font class=title><?print $titleres{"fname"} . " " . $titleres{"lname"};?></font></a><br>
<span class=text>Generated on: <?print date("Y-m-d");?></span>
<br>

<?
//$provider = getProviderName($titleres['providerID']);

//print "Provider: " . $provider  . "</br>";

$inclookupres = sqlStatement("select distinct formdir from forms where pid='$pid'");
while($result = sqlFetchArray($inclookupres)) {
	include_once("{$GLOBALS['incdir']}/forms/" . $result{"formdir"} . "/report.php");
}

$printed = false;

foreach ($ar as $key => $val) {
if(!empty($ar['newpatient'])){
	foreach ($ar['newpatient'] as $be) {	
						
		$ta = split(":",$be);
		$billing = getPatientBillingEncounter($pid,$ta[1]);

		if(!$printed){		
			foreach ($billing as $b) {
				if(!empty($b['provider_name'])){
					echo "Provider: " . $b['provider_name'] . "<br>";
					$printed = true;
					break;
				}
			}
		}
	}
}

if (stristr($key,"include_")) {
	//print "include: $val<br>\n";

	if ($val == "demographics") {
		
		print "<font class=bold>Patient Data:</font><br>";
		printRecDataOne($patient_data_array, getRecPatientData ($pid), $N);
	
		} elseif ($val == "history") {
	
			print "<font class=bold>History Data:</font><br>";
			printRecDataOne($history_data_array, getRecHistoryData ($pid), $N);
		
		} elseif ($val == "employer") {
	
			print "<font class=bold>Employer Data:</font><br>";
			printRecDataOne($employer_data_array, getRecEmployerData ($pid), $N);
	
		} elseif ($val == "insurance") {
		
			print "<font class=bold>Primary Insurance Data:</font><br>";
			printRecDataOne($insurance_data_array, getRecInsuranceData ($pid,"primary"), $N);		
			print "<font class=bold>Secondary Insurance Data:</font><br>";	
			printRecDataOne($insurance_data_array, getRecInsuranceData ($pid,"secondary"), $N);
			
			print "<font class=bold>Tertiary Insurance Data:</font><br>";
			printRecDataOne($insurance_data_array, getRecInsuranceData ($pid,"tertiary"), $N);
			
		} elseif ($val == "billing") {
			print "<font class=bold>Billing Information:</font><br>";
			if (count($ar['newpatient']) > 0) {
				$billings = array();
				echo "<table>";
				echo "<tr><td width=\"400\" class=bold>Code</td><td class=bold>Fee</td></tr>\n";
				$total = 0.00;
				$copays = 0.00;
				foreach ($ar['newpatient'] as $be) {
				  $ta = split(":",$be);
				  $billing = getPatientBillingEncounter($pid,$ta[1]);
				  $billings[] = $billing;
				  foreach ($billing as $b) {
				    echo "<tr>\n";
				    echo "<td class=text>";
				    echo $b['code_type'] . ":\t" . $b['code'] . "&nbsp;&nbsp;&nbsp;" . $b['code_text'] . "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
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
											    echo "<tr><td class=bold>Sub-Total</td><td class=text>" . sprintf("%0.2f",$total) . "</td></tr>";
											    echo "<tr><td class=bold>Paid</td><td class=text>" . sprintf("%0.2f",$copays) . "</td></tr>";
				echo "<tr><td class=bold>Total</td><td class=text>" . sprintf("%0.2f",($total - $copays)) . "</td></tr>";
				echo "</table>";
				echo "<pre>";
				//print_r($billings);
				echo "</pre>";
			}
			else {
				printPatientBilling($pid);
			}
			
		} elseif ($val == "allergies") {
			print "<font class=bold>Patient Allergies:</font><br>";
			printListData($pid, "allergy", "1");
		} elseif ($val == "medications") {
			print "<font class=bold>Patient Medications:</font><br>";
			printListData($pid, "medication", "1");
		} elseif ($val == "medical_problems") {
				print "<font class=bold>Patient Medical Problems:</font><br>";
				printListData($pid, "medical_problem", "1");
		} elseif ($val == "immunizations") {
				print "<font class=bold>Patient Immunization:</font><br>";
                                $sql = "select if(i1.administered_date,concat(i1.administered_date,' - ',i2.name) ,substring(i1.note,1,20) ) as immunization_data from immunizations i1 left join immunization i2 on i1.immunization_id = i2.id where i1.patient_id = $pid order by administered_date desc";

                                $result = sqlStatement($sql);

                                while ($row=sqlFetchArray($result)){
                                        echo "<span class=text> " . $row{'immunization_data'} . "</span>
<br>\n";
                                }
		} elseif ($val == "notes") {
				print "<font class=bold>Patient Notes:</font><br>";
				printPatientNotes($pid);
		} elseif ($val == "transactions") {
			print "<font class=bold>Patient Transactions:</font><br>";
			printPatientTransactions($pid);
		}	
	} else {
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
					echo "<b>NOTE</b>: Document '" . $fname ."' cannot be displayed inline becuase its type is not supported by the browser.<br><br>";	
				}
			}
		}
		else {
		//print "$key:$val<br>\n";
		foreach ($val as $valkey => $valvalue ) {
			preg_match_all('/^(\d+?)\:(\d+?)$/',$valvalue,$res);
			
			$form_id = $res[1][0];
			$form_encounter = $res[2][0];
			//print $res[0][0] . " " . $res[1][0] . " " . $res[2][0] . "<br>\n";
		
			$formres = getFormNameByFormdir($key);
			$dateres = getEncounterDateByEncounter($form_encounter);
			print "<span class=bold>" . $formres{"form_name"} . "</span><span class=text>(" . date("Y-m-d",strtotime($dateres{"date"})) . ")" . "</span><br>\n";
			call_user_func($key . "_report", $pid, $form_encounter, $N, $form_id);
		}
		}
	}
}

print "</br></br>Signature: _______________________________</br>";

?>


</body>
</html>
