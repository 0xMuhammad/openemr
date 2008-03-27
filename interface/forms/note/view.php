<!-- Work/School Note Form created by Nikolai Vitsyn: 2004/02/13 and update 2005/03/30 
     Copyright (C) Open Source Medical Software 

     This program is free software; you can redistribute it and/or
     modify it under the terms of the GNU General Public License
     as published by the Free Software Foundation; either version 2
     of the License, or (at your option) any later version.

     This program is distributed in the hope that it will be useful,
     but WITHOUT ANY WARRANTY; without even the implied warranty of
     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
     GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA. -->

<?php
include_once("../../globals.php");
$returnurl = $GLOBALS['concurrent_layout'] ? 'encounter_top.php' : 'patient_encounter.php';
?>
<html><head>
<?php html_header_show();?>
<link rel="stylesheet" href="<?php echo $css_header;?>" type="text/css">
</head>
<body class="body_top">
<?php
include_once("$srcdir/api.inc");
$obj = formFetch("form_note", $_GET["id"]);

?>

<form method=post action="<?php echo $rootdir?>/forms/note/save.php?mode=update&id=<?php echo $_GET["id"];?>" name="my_form">
<span class="title"><?php xl('Work/School Note','e'); ?></span><br></br>

<a href="javascript:top.restoreSession();document.my_form.submit();" class="link_submit">[<?php xl('Save','e'); ?>]</a>
<br>
<a href="<?php echo "$rootdir/patient_file/encounter/$returnurl";?>" class="link"
 onclick="top.restoreSession()">[<?php xl('Don\'t Save Changes','e'); ?>]</a>
</br>

<tr>
<td>
<input type=entry name="note_type" value="<?php echo
stripslashes($obj{"note_type"});?>" size="50"> 
</td>
</tr>

<span class="text"><?php xl('Message:','e'); ?></span></br>
<textarea name="message" cols ="67" rows="4"  wrap="virtual name">
<?php echo stripslashes($obj{"message"});?></textarea>
<br></br>

<span class=text><?php xl('Doctor:','e'); ?> </span><input type=entry name="doctor" value="<?php echo stripslashes($obj{"doctor"});?>">
<br></br>


<span class=text><?php xl('Date:','e'); ?> </span><input type=entry name="date_of_signature" value="<?php echo stripslashes($obj{"date_of_signature"});?>" >
<br></br>

<a href="javascript:top.restoreSession();document.my_form.submit();" class="link_submit">[<?php xl('Save','e'); ?>]</a>
<br>
<a href="<?php echo "$rootdir/patient_file/encounter/$returnurl";?>" class="link"
 onclick="top.restoreSession()">[<?php xl('Don\'t Save Changes','e'); ?>]</a>
</form>
<?php
formFooter();
?>
