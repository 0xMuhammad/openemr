<?php
include_once("../../globals.php");
?>
<html>
<head>
<? html_header_show();?>
<title><? xl('Patient Summary','e'); ?></title>
</head>

<frameset rows="50%,50%">
 <frame src="demographics.php" name="Demographics" scrolling="auto">
<?php if ($GLOBALS['athletic_team']) { ?>
 <frameset cols="50%,50%">
<?php } else { ?>
 <frameset cols="20%,80%">
<?php } ?>
  <frame src="stats.php" name="Stats" scrolling="auto">
  <frame src="pnotes.php" name="Notes" scrolling="auto">
 </frameset>
</frameset>

</html>
