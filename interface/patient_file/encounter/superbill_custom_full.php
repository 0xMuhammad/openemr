<?
include_once("../../globals.php");
include_once("../../../custom/code_types.inc.php");
include_once("$srcdir/sql.inc");

if (isset($mode)) {

	// ERROR!  $id and other variables here are not set!

	if ($mode == "delete" ) {
		sqlStatement("delete from codes where id='$id'");
	} elseif ($mode == "add" ) {
		$sql = "REPLACE INTO codes set 
										code		= '" . mysql_real_escape_string($code) . "',
										code_type	= '" . mysql_real_escape_string($code_type) . "',
										code_text	= '" . mysql_real_escape_string($code_text) . "',
										modifier 	= '" . mysql_real_escape_string($modifier) . "',
										units 		= '" . mysql_real_escape_string($units) . "',
										fee 		= '" . mysql_real_escape_string($fee) . "',
										superbill 	= '" . mysql_real_escape_string($superbill) . "',
										id 	= '" . mysql_real_escape_string($id) . "'";
		sqlStatement($sql);
		$code=$code_type=$code_text=$modifier=$units=$fee=$superbill=$id="";
	}
	elseif ($mode == "edit" ) {
		$sql = "select * from codes where id = " . mysql_real_escape_string($id);
		$results = sqlQ($sql);
		while ($row = mysql_fetch_assoc($results)) {
			$GLOBALS['code'] = $row['code'];
			$GLOBALS['code_text'] = $row['code_text'];
			$GLOBALS['code_type'] = $row['code_type'];
			$GLOBALS['modifier'] = $row['modifier'];
			$GLOBALS['units'] = $row['units'];
			$GLOBALS['fee'] = $row['fee'];
			$GLOBALS['superbill'] = $row['superbill'];
			$GLOBALS['id'] = $row['id'];
		}
	}

}

//the number of records to display before forming a new column:
$N = 12;
?>

<html>
<head>

<link rel=stylesheet href="<?echo $css_header;?>" type="text/css">

</head>
<body <?echo $top_bg_line;?> topmargin=0 rightmargin=0 leftmargin=2 bottommargin=0 marginwidth=2 marginheight=0>

<a href="patient_encounter.php?codefrom=superbill" target="Main"><span class=title><? xl('Superbill Codes','e'); ?></span><font class=more><?echo $tback;?></font></a>

<form action="superbill_custom_full.php" name=add_code>
<input type=hidden name=mode value="add">
<br>
<table border=0 cellpadding=0 cellspacing=0>
<tr>
<td colspan="3"> <? xl('Not all fields are required for all codes or code types.','e'); ?><br><br></td>
</tr>
<tr>
	<td><? xl('Code Type','e'); ?>:</td>
	<td width="5" rowspan="7"></td>
	<td>
		<select name="code_type">
<? foreach ($code_types as $key => $value) { ?>
			<option value="<? echo $value['id'] ?>"<?if ($GLOBALS['code_type'] == $value['id']) echo " selected" ?>><? echo $key ?></option>
<? } ?>
		</select>
	</td>
</tr>
<tr>
	<td><? xl('Code','e'); ?>:</td><td><input type=entry size=25 name="code" value="<?=$GLOBALS['code']?>"></td>
</tr>
<tr>
	<td><? xl('Code Text','e'); ?>:</td><td><input type=entry size=25 name="code_text" value="<?=$GLOBALS['code_text']?>"></td>
</tr>
<tr>
	<td><? xl('Modifier','e'); ?>:</td><td><input type=entry size=3 name="modifier" value="<?=$GLOBALS['modifier']?>"></td>
</tr>
<tr>
	<td><? xl('Units','e'); ?>:</td><td><input type=entry size=4 name="units" value="<?=$GLOBALS['units']?>"></td>
</tr>
<tr>
	<td><? xl('Fee','e'); ?>:</td><td><input type=entry size=6 name="fee" value="<?=$GLOBALS['fee']?>" ></td>
</tr>
<tr>
	<td><? xl('Include in Superbill','e'); ?>:</td><td><select name="superbill"><option value="0" <?if ($GLOBALS['superbill'] == 0) echo "selected"?>>No</option><option value="1" <?if ($GLOBALS['superbill'] == 1) echo "selected"?>><? xl('Yes','e'); ?></option></td>
</tr>
<tr>
	<td colspan="3" align="center">
	<input type="hidden" name="id" value="<?=$GLOBALS['id']?>"> 
	<br><a href='javascript:document.add_code.submit();' class=link>[<? xl('Add Code','e'); ?>]</a></td>
</tr>

</table>
<?

$fstart = $_GET['fstart'];
if (empty($fstart)) {
	$fstart = 0;
}
elseif (!is_numeric($fstart)) {
	$fstart = 100;	
}

$fend = $fstart + 100;

?>

</form>
<form method="get" action="superbill_custom_full.php">
<table>
<tr>
<? if ($fstart > 0) { ?>
<td>
<a href="superbill_custom_full.php?fstart=<?=($fstart - 100)?>&filter=<?=$_GET['filter']?>&search=<?=$_GET['search']?>"><? xl('Prev 100','e'); ?></a>
&nbsp;&nbsp;
</td>
<? } ?>

<td>
<a href="superbill_custom_full.php?fstart=<?=($fstart + 100)?>&filter=<?=$_GET['filter']?>&search=<?=$_GET['search']?>"><? xl('Next 100','e'); ?></a>
&nbsp;&nbsp;
</td>
<td>
<a href="superbill_custom_full.php?fstart=<?=$_GET['fstart']?>&filter="><? xl('ALL','e'); ?></a>&nbsp;&nbsp;
</td>

<? foreach ($code_types as $key => $value) { ?>
<td>
<a href="superbill_custom_full.php?fstart=<?=$_GET['fstart']?>&filter=<? echo $value['id'] ?>"><? echo $key ?></a>&nbsp;&nbsp;
</td>
<? } ?>

<td>
<input type="text" name="search" size="5">&nbsp;<input type="submit" name="go" value="search">
</td>
</tr>
</table>
</form>

<table border=0 cellpadding=0 cellspacing=0>
<tr>
<td valign=top>
<table border=0 cellpadding=5 cellspacing=0>
<th><td></td><td><span class=bold><? xl('Code','e'); ?></span></td><td><span class=bold><? xl('Modifier','e'); ?></span></td><td><span class=bold><? xl('Type','e'); ?></span></td><td><span class=bold><? xl('Text','e'); ?></span></td><td><span class=bold><? xl('Modifier','e'); ?></span></td><td><span class=bold><? xl('Units','e'); ?></span></td><td><span class=bold><? xl('Fee','e'); ?></span></td><td></td></th>
<?

$filter = $_GET['filter'];
$search = $_GET['search'];

$sql = "select * from codes ";
if (!is_numeric($filter) && empty($search)) {
	$filter = "";
}
elseif (!empty($search)) {
	$sql .= " where code like '%" . mysql_real_escape_string($search) . "%'";
}
else {
	$sql .= " where code_type = $filter ";	
}
$sql .= " order by code_type, code, units, code_text limit $fstart, $fend";

$res = sqlStatement($sql);
for ($iter = 0;$row = sqlFetchArray($res);$iter++)
	$all[$iter] = $row;

if ($all) {
	$count =0;
	foreach($all as $iter) {
		$count++;

		$has_fees = false;
		foreach ($code_types as $key => $value) {
			if ($value['id'] == $iter['code_type']) {
				$has_fees = $value['fee'];
				break;
			}
		}

		print "<tr><td></td><td><span class=text target=Diagnosis href='diagnosis.php?mode=add" .
			"&type=" . urlencode($iter{"code_type"}) .
			"&code=" . urlencode($iter{"code"}) .
			"&text=" . urlencode($iter{"code_text"})."'>";
		print "</td><td><span class=text>" . $iter["code"] .
			"</span></td><td><span class=text" .
			$iter["modifier"] . "</span></td><td><span class=text>" .
			$key .
			"</span></td><td><span class=text>" . $iter{"code_text"};
		print "</span></td><td>";
		if ($has_fees) {
			echo "<span class=text>" . $iter['modifier'] . "</span>";
		}
		echo "</td><td>";
		if ($has_fees) {
			echo "<span class=text>" . $iter['units'] . "</span>";
		}
		echo "</td><td>";
		if ($has_fees) {
			echo "<span class=text>$" . sprintf("%01.2f", $iter['fee']) . "</span>";
		}
		echo "</td><td><a class=link href='superbill_custom_full.php?mode=delete&id=".$iter{"id"}."'>[Delete]</a></td>\n";
		echo "<td><a class=link href='superbill_custom_full.php?mode=edit&id=".$iter{"id"}."'>[Edit]</a></td></tr>\n";

	}
}

?>

</td></tr></table>
</table>

</body>
</html>
