<?
include_once("../../globals.php");

include_once("$srcdir/forms.inc");
include_once("$srcdir/billing.inc");
include_once("$srcdir/pnotes.inc");
include_once("$srcdir/patient.inc");

?>
<html>
<head>

<link rel=stylesheet href="<?echo $css_header;?>" type="text/css">

</head>
<body <?echo $top_bg_line;?> topmargin=0 rightmargin=0 leftmargin=2 bottommargin=0 marginwidth=2 marginheight=0>

<a href="patient_history.php" target="Main"><font class="title">Past Encounters</font><font class=back><?echo $tback;?></font></a><br>

<table width='100%'>
<tr>
<td><span class='bold'>Date</span></td>
<td><span class='bold'>Reason</span></td>
<td><span class='bold'>Billing</span></td>
<td><span class='bold'>Insurance</span></td>
</tr>

<?
if ($result = getEncounters($pid)) {
	foreach ($result as $iter ) {

		$reason_string = "";
		if ($result4 = sqlQuery("select * from form_encounter where encounter='" . $iter{"encounter"} . "' and pid='$pid'")) {
			$raw_encounter_date = date("Y-m-d", strtotime($result4{"date"}));
			$encounter_date = date("D F jS", strtotime($result4{"date"}));
			$reason_string .= $result4{"reason"} . "<br>\n";
		}

		print "<tr>\n";
		print "<td valign='top'><a target='Main' href=\"javascript:parent.Title.location.href='../encounter/encounter_title.php?set_encounter=".$iter{"encounter"}."';parent.Main.location.href='../encounter/patient_encounter.php?set_encounter=".$iter{"encounter"}."'\" class='text'>" . $encounter_date . "</a></td>\n";
		print "<td valign='top'><a target='Main' href=\"javascript:parent.Title.location.href='../encounter/encounter_title.php?set_encounter=".$iter{"encounter"}."';parent.Main.location.href='../encounter/patient_encounter.php?set_encounter=".$iter{"encounter"}."'\" class='text'>" . $reason_string . "</a></td>\n";

		$coded = "";
		if ($subresult2 = getBillingByEncounter($pid, $iter{"encounter"})) {
			//this is where we print out the text of the billing that occurred on this encounter
			foreach ($subresult2 as $iter2) {
				$coded .= "<span title='" . addslashes($iter2{"code_text"}) . "'>";
				$coded .= $iter2{"code"} . "</span>, ";
			}
			$coded = substr($coded, 0, strlen($coded) - 2);
		}

		print "<td valign='top'><a target='Main' href=\"javascript:parent.Title.location.href='../encounter/encounter_title.php?set_encounter=".$iter{"encounter"}."';parent.Main.location.href='../encounter/patient_encounter.php?set_encounter=".$iter{"encounter"}."'\" class='text'>" . $coded . "</a></td>\n";

		$insured = "$raw_encounter_date";
		$subresult5 = getInsuranceDataByDate($pid, $raw_encounter_date, "primary");
		if ($subresult5 && $subresult5{"provider_name"}) {
			$insured = "<span class='text'>Primary: " . $subresult5{"provider_name"} . "</span><br>\n";
		}
		$subresult6 = getInsuranceDataByDate($pid, $raw_encounter_date, "secondary");
		if ($subresult6 && $subresult6{"provider_name"}) {
			$insured .= "<span class='text'>Secondary: ".$subresult6{"provider_name"}."</span><br>\n";
		}
		$subresult7 = getInsuranceDataByDate($pid, $raw_encounter_date, "tertiary");
		if ($subresult6 && $subresult7{"provider_name"}) {
			$insured .= "<span class='text'>Tertiary: ".$subresult7{"provider_name"}."</span><br>\n";
		}

		print "<td valign='top'><a target='Main' href=\"javascript:parent.Title.location.href='../report/report_title.php?set_encounter=".$iter{"encounter"}."';parent.Main.location.href='../report/patient_report.php?set_encounter=".$iter{"encounter"}."'\" class='text'>" . $insured . "</a></td>\n";

		print "</tr>\n";
	}
}

?>

</table>

</body>
</html>
