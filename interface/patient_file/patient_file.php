<?
include_once("../globals.php");
include_once("$srcdir/pid.inc");

setpid($_GET["set_pid"]);
?>

<HTML>
<HEAD>
<TITLE>
OpenEMR
</TITLE>
</HEAD>
<frameset rows="<?echo "$GLOBALS[navBarHeight],$GLOBALS[titleBarHeight]" ?>,*" cols="*" frameborder="0" border="0" framespacing="0">
<?
if (isset($_GET["calenc"])) {
?>
  <frame src="navigation.php" name="Navigation" scrolling="NO" noresize frameborder="0">
  <frame src="encounter/encounter_title.php" name="Title" scrolling="no" noresize frameborder="0">
  <frame src="encounter/patient_encounter.php?mode=new&calenc=<?echo $_GET["calenc"];?>" name="Main" scrolling="AUTO" noresize frameborder="0">
  <?
} elseif ($_GET['go'] == "encounter"){
?>
  <frame src="navigation.php?pid=<?=$_GET['pid']?>&set_pid=<?=$_GET['pid']?>" name="Navigation" scrolling="NO" noresize frameborder="0">
  <frame src="encounter/encounter_title.php?pid=<?=$_GET['pid']?>&set_pid=<?=$_GET['pid']?>" name="Title" scrolling="no" noresize frameborder="0">
  <frame src="encounter/patient_encounter.php?mode=new&pid=<?=$_GET['pid']?>&set_pid=<?=$_GET['pid']?>" name="Main" scrolling="AUTO" noresize frameborder="0">
<?
} else {
?>
  <frame src="navigation.php" name="Navigation" scrolling="NO" noresize frameborder="0">
  <frame src="summary/summary_title.php" name="Title" scrolling="no" noresize frameborder="0">
  <frame src="summary/patient_summary.php" name="Main" scrolling="AUTO" noresize frameborder="0">
<?
}
?>
</frameset>

<noframes><body bgcolor="#FFFFFF">

</body></noframes>

</HTML>
