<?
include_once("../../globals.php");

?>

<HTML>
<HEAD>
<TITLE>
OpenEMR
</TITLE>
</HEAD>
<frameset rows="*" cols="33%,33%,33%" frameborder="NO" border="0" framespacing="0">

  <frame src="medications.php?active=<?echo $active;?>" name="Medications" scrolling="auto" noresize frameborder="NO">
  <frame src="allergies.php?active=<?echo $active;?>" name="Allergies" scrolling="auto" noresize frameborder="NO">
  <frame src="immunizations.php?active=<?echo $active;?>" name="Immunizations" scrolling="auto" noresize frameborder="NO">
  
</frameset>


<noframes><body bgcolor="#FFFFFF">

</body></noframes>



</HTML