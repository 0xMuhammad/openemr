<!-- Forms generated from formsWiz -->
<?php
include_once("../../globals.php");
?>
<html><head>
<link rel=stylesheet href="<?echo $css_header;?>" type="text/css">
</head>
<body <?echo $top_bg_line;?> topmargin=0 rightmargin=0 leftmargin=2 bottommargin=0 marginwidth=2 marginheight=0>
<?php
include_once("$srcdir/api.inc");
$obj = formFetch("form_vision", $_GET["id"]);
?>
<form method=post action="<?echo $rootdir?>/forms/vision/save.php?mode=update&id=<?echo $_GET["id"];?>" name="my_form">
<span class="title">Vision</span><Br><br>
<span class=bold>Keratometry</span><br>

<table>
<tr>
<td><span class=text>OD K1: </span></td><td><input size=3 type=entry name="od_k1" value="<?echo $obj{"od_k1"};?>" ></td>
<td><span class=text>OD K1 Axis: </span></td><td><input size=3 type=entry name="od_k1_axis" value="<?echo $obj{"od_k1_axis"};?>" ></td>
<td><span class=text>OD K2: </span></td><td><input size=3 type=entry name="od_k2" value="<?echo $obj{"od_k2"};?>" ></td>
<td><span class=text>OD K2 Axis: </span></td><td><input size=3 type=entry name="od_k2_axis" value="<?echo $obj{"od_k2_axis"};?>" ></td>
</tr>
<tr>
<td colspan=8>
<span class=text>OD Testing Status: </span><input type=entry name="od_testing_status" value="<?echo $obj{"od_testing_status"};?>" >
</td>
</tr>
</table>


<table>
<tr>
<td><span class=text>OS K1: </span></td><td><input size=3 type=entry name="os_k1" value="<?echo $obj{"os_k1"};?>" ></td>
<td><span class=text>OS K1 Axis: </span></td><td><input size=3 type=entry name="os_k1_axis" value="<?echo $obj{"os_k1_axis"};?>" ></td>
<td><span class=text>OS K2: </span></td><td><input size=3 type=entry name="os_k2" value="<?echo $obj{"os_k2"};?>" ></td>
<td><span class=text>OS K2 Axis: </span></td><td><input size=3 type=entry name="os_k2_axis" value="<?echo $obj{"os_k2_axis"};?>" ></td>
</tr>
<tr>
<td colspan=8>
<span class=text>OS Testing Status: </span><input type=entry name="os_testing_status" value="<?echo $obj{"os_testing_status"};?>" >
</td>
</tr>
</table>


<span class=text>Additional Notes: </span><br><textarea cols=40 rows=8 wrap=virtual name="additional_notes" ><?echo $obj{"additional_notes"};?></textarea>
<br>
<a href="javascript:document.my_form.submit();" class="link_submit">[Save]</a>
<br>
<a href="<?php echo $GLOBALS['form_exit_url']; ?>" class="link">[Don't Save Changes]</a>
</form>
<?php
formFooter();
?>
