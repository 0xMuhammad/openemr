<?
include_once("../../globals.php");

?>

<HTML>
<HEAD>
<TITLE>
Patient Summary
</TITLE>
</HEAD>


<frameset rows="50%,50%" cols="*">
         <frame src="demographics.php" name="Demographics" scrolling="auto">
      <frameset rows="*" cols="20%,80%">
        <frame src="stats.php" name="Stats" scrolling="auto">
	<frame src="pnotes.php" name="Notes" scrolling="auto">
     </frameset>
</frameset>




<noframes><body bgcolor="#FFFFFF">

</body></noframes>



</HTML>
