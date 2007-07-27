<!-- view.php -->
<?php
include_once("../../globals.php");
include_once("../../../library/api.inc");
formHeader("Form: CAMOS");
$returnurl = $GLOBALS['concurrent_layout'] ? 'encounter_top.php' : 'patient_encounter.php';
?>
<html><head>
<link rel=stylesheet href="<?echo $css_header;?>" type="text/css">
</head>
<body <?echo $top_bg_line;?> topmargin=0 rightmargin=0 leftmargin=2 bottommargin=0 marginwidth=2 marginheight=0>
<form method="post" action="<?echo $rootdir?>/forms/CAMOS/save.php?mode=delete&id=<?echo $_GET["id"];?>"
 name="my_form" onsubmit="top.restoreSession()">
<h1> <?php xl('CAMOS','e'); ?> </h1>
</table><input type="submit" name="submit form" value="<?php xl('Delete','e'); ?>" /><?
echo "<a href='".$GLOBALS['webroot'] .
  "/interface/patient_file/encounter/$returnurl' onclick='top.restoreSession()'>[" .
  xl('do nothing') . "]</a>";
?>
</form>
<?php
formFooter();
?>
