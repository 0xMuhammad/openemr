<?php
include_once("../globals.php");
include_once("../../library/acl.inc");
include_once("$srcdir/md5.js");
include_once("$srcdir/sql.inc");
require_once(dirname(__FILE__) . "/../../library/classes/WSProvider.class.php");

$alertmsg = '';

if (isset($_POST["mode"])) {
  if ($_POST["mode"] == "facility") {
    sqlStatement("insert into facility set
    name='{$_POST['facility']}',
    phone='{$_POST['phone']}',
    fax='{$_POST['fax']}',
    street='{$_POST['street']}',
    city='{$_POST['city']}',
    state='{$_POST['state']}',
    postal_code='{$_POST['postal_code']}',
    country_code='{$_POST['country_code']}',
    federal_ein='{$_POST['federal_ein']}',
    facility_npi='{$_POST['facility_npi']}'");
  }
  else if ($_POST["mode"] == "new_user") {
    if ($_POST["authorized"] != "1") {
      $_POST["authorized"] = 0;
    }
    $_POST["info"] = addslashes($_POST["info"]);

    $res = sqlStatement("select distinct username from users where username != ''");
    $doit = true;
    while ($row = mysql_fetch_array($res)) {
      if ($doit == true && $row['username'] == $_POST["username"]) {
        $doit = false;
      }
    }

    if ($doit == true) {
      $prov_id = idSqlStatement("insert into users set " .
        "username = '"         . $_POST["username"] .
        "', password = '"      . $_POST["newauthPass"] .
        "', fname = '"         . $_POST["fname"] .
        "', mname = '"         . $_POST["mname"] .
        "', lname = '"         . $_POST["lname"] .
        "', federaltaxid = '"  . $_POST["federaltaxid"] .
        "', authorized = '"    . $_POST["authorized"] .
        "', info = '"          . $_POST["info"] .
        "', federaldrugid = '" . $_POST["federaldrugid"] .
        "', upin = '"          . $_POST["upin"] .
        "', npi  = '"          . $_POST["npi"].
        "', facility = '"      . $_POST["facility"] .
        "', specialty = '"     . $_POST["specialty"] .
        "', see_auth = '"      . $_POST["see_auth"] .
        "'");
      sqlStatement("insert into groups set name = '" . $_POST["groupname"] .
        "', user = '" . $_POST["username"] . "'");

      if (isset($phpgacl_location) && acl_check('admin', 'acl') && $_POST["access_group"]) {
        // Set the access control group of user
        set_user_aro($_POST["access_group"], $_POST["username"], $_POST["fname"], $_POST["mname"], $_POST["lname"]);
      }

      $ws = new WSProvider($prov_id);
    } else {
      $alertmsg .= "User " . $_POST["username"] . " already exists. ";
    }
  }
  else if ($_POST["mode"] == "new_group") {
    $res = sqlStatement("select distinct name, user from groups");
    for ($iter = 0; $row = sqlFetchArray($res); $iter++)
      $result[$iter] = $row;
    $doit = 1;
    foreach ($result as $iter) {
      if ($doit == 1 && $iter{"name"} == $_POST["groupname"] && $iter{"user"} == $_POST["username"])
        $doit--;
    }
    if ($doit == 1) {
      sqlStatement("insert into groups set name = '" . $_POST["groupname"] .
        "', user = '" . $_POST["username"] . "'");
    } else {
      $alertmsg .= "User " . $_POST["username"] .
        " is already a member of group " . $_POST["groupname"] . ". ";
    }
  }
}

if (isset($_GET["mode"])) {

  // This is the code to delete a user.  Note that the link which invokes
  // this is commented out.  Somebody must have figured it was too dangerous.
  //
  if ($_GET["mode"] == "delete") {
    $res = sqlStatement("select distinct username, id from users where id = '" .
      $_GET["id"] . "'");
    for ($iter = 0; $row = sqlFetchArray($res); $iter++)
      $result[$iter] = $row;

    // TBD: Before deleting the user, we should check all tables that
    // reference users to make sure this user is not referenced!

    foreach($result as $iter) {
      sqlStatement("delete from groups where user = '" . $iter{"username"} . "'");
    }
    sqlStatement("delete from users where id = '" . $_GET["id"] . "'");
  }

  elseif ($_GET["mode"] == "delete_group") {
    $res = sqlStatement("select distinct user from groups where id = '" .
      $_GET["id"] . "'");
    for ($iter = 0; $row = sqlFetchArray($res); $iter++)
      $result[$iter] = $row;
    foreach($result as $iter)
      $un = $iter{"user"};
//  $res = sqlStatement("select name,user from groups where user = '" .
//    $iter{"user"} . "' and id != {$_GET["id"]}\n");
    $res = sqlStatement("select name, user from groups where user = '$un' " .
      "and id != '" . $_GET["id"] . "'");

    // Remove the user only if they are also in some other group.  I.e. every
    // user must be a member of at least one group.
    if (sqlFetchArray($res) != FALSE) {
      sqlStatement("delete from groups where id = '" . $_GET["id"] . "'");
    } else {
      $alertmsg .= "You must add this user to some other group before " .
        "removing them from this group. ";
    }
  }
}
?>
<html>
<head>

<link rel=stylesheet href="<?echo $css_header;?>" type="text/css">

</head>
<body <?echo $top_bg_line;?> topmargin=0 rightmargin=0 leftmargin=2 bottommargin=0 marginwidth=2 marginheight=0>

<span class="title"><? xl('User and Facility Administration','e'); ?></span>

<br><br>

<table width=100%>
<tr>

<td valign=top>

<form name='facility' method='post' action="usergroup_admin.php"
 onsubmit='return top.restoreSession()'>
<input type=hidden name=mode value="facility">
<span class=bold><? xl('New Facility Information','e'); ?>: </span>
</td><td>

<table border=0 cellpadding=0 cellspacing=0>
<tr>
<td><span class=text><? xl('Name','e'); ?>: </span></td><td><input type=entry name=facility size=20 value=""></td>
<td><span class=text><? xl('Phone','e'); ?>: </span></td><td><input type=entry name=phone size=20 value=""></td>
</tr>
<tr>
<td>&nbsp;</td><td>&nbsp;</td>
<td><span class=text><? xl('Fax','e'); ?>: </span></td><td><input type=entry name=fax size=20 value=""></td>
</tr>
<tr>
<td><span class=text><? xl('Address','e'); ?>: </span></td><td><input type=entry size=20 name=street value=""></td>
<td><span class=text><? xl('City','e'); ?>: </span></td><td><input type=entry size=20 name=city value=""></td>
</tr>
<tr>
<td><span class=text><? xl('State','e'); ?>: </span></td><td><input type=entry size=20 name=state value=""></td>
<td><span class=text><? xl('Zip Code','e'); ?>: </span></td><td><input type=entry size=20 name=postal_code value=""></td>
</tr>
<tr>
<td height="22"><span class=text><? xl('Country','e'); ?>: </span></td>
<td><input type=entry size=20 name=country_code value=""></td>
<td><span class=text><? xl('Federal EIN','e'); ?>: </span></td><td><input type=entry size=20 name=federal_ein value=""></td>
</tr>
<tr>
<td>&nbsp;</td><td>&nbsp;</td>

<td><span class=text><? xl('Facility NPI','e'); ?>: </span></td><td><input type=entry size=20 name=facility_npi value=""></td>

</tr>
<tr>
<td>&nbsp;</td><td>&nbsp;</td>
<td>&nbsp;</td><td><input type="submit" value=<? xl('Add Facility','e'); ?>></td>
</tr>
</table>
</form>
<br>
</tr>
<tr>
<td valign=top>

<form name='facility' method='post' action="usergroup_admin.php"
 onsubmit='return top.restoreSession()'>
<input type=hidden name=mode value=<? xl('facility','e'); ?>>
<span class=bold><? xl('Edit Facilities','e'); ?>: </span>
</td><td valign=top>
<?php
$fres = 0;
$fres = sqlStatement("select * from facility order by name");
if ($fres) {
  $result2 = array();
  for ($iter3 = 0;$frow = sqlFetchArray($fres);$iter3++)
    $result2[$iter3] = $frow;
  foreach($result2 as $iter3) {
?>
<span class=text><?echo $iter3{name};?></span>
<a href="facility_admin.php?fid=<?echo $iter3{id};?>" class=link_submit
 onclick="top.restoreSession()">(Edit)</a><br>
<?php
  }
}
?>

</td>
</tr>
<tr><td valign=top>
<form name='new_user' method='post' action="usergroup_admin.php"
 onsubmit='return top.restoreSession()'>
<input type=hidden name=mode value=new_user>
<span class=bold><? xl('New User','e'); ?>:</span>
</td><td>
<table border=0 cellpadding=0 cellspacing=0>
<tr>
<td><span class=text><? xl('Username','e'); ?>: </span></td><td><input type=entry name=username size=20> &nbsp;</td>
<td><span class=text><? xl('Password','e'); ?>: </span></td><td><input type="password" size=20 name=clearPass></td>
</tr>
<tr>
<td><span class=text><? xl('Groupname','e'); ?>: </span></td><td>
<select name=groupname>
<?php
$res = sqlStatement("select distinct name from groups");
$result2 = array();
for ($iter = 0;$row = sqlFetchArray($res);$iter++)
  $result2[$iter] = $row;
foreach ($result2 as $iter) {
  print "<option value='".$iter{"name"}."'>" . $iter{"name"} . "</option>\n";
}
?>
</select></td>
<td><span class=text><? xl('Authorized','e'); ?>: </span></td><td><input type=checkbox name='authorized' value="1"></td>
</tr>
<tr>
<td><span class=text><? xl('First Name','e'); ?>: </span></td><td><input type=entry name='fname' size=20></td>
<td><span class=text><? xl('Middle Name','e'); ?>: </span></td><td><input type=entry name='mname' size=20></td>
</tr>
<tr>
<td><span class=text><? xl('Last Name','e'); ?>: </span></td><td><input type=entry name='lname' size=20></td>
<td><span class=text><? xl('Default Facility','e'); ?>: </span></td><td><select name=facility>
<?php
$fres = sqlStatement("select * from facility order by name");
if ($fres) {
  for ($iter = 0;$frow = sqlFetchArray($fres);$iter++)
    $result[$iter] = $frow;
  foreach($result as $iter) {
?>
<option value="<?echo $iter{name};?>"><?echo $iter{name};?></option>
<?php
  }
}
?>
</select></td>
</tr>
<tr>
<td><span class=text><? xl('Federal Tax ID','e'); ?>: </span></td><td><input type=entry name='federaltaxid' size=20></td>
<td><span class=text><? xl('Federal Drug ID','e'); ?>: </span></td><td><input type=entry name='federaldrugid' size=20></td>
</tr>
<tr>
<td><span class="text"><? xl('UPIN','e'); ?>: </span></td><td><input type="entry" name="upin" size="20"></td>
<td class='text'><? xl('See Authorizations','e'); ?>: </td>
<td><select name="see_auth">
<?php
 foreach (array(1 => xl('None'), 2 => xl('Only Mine'), 3 => xl('All')) as $key => $value)
 {
  echo " <option value='$key'";
  echo ">$value</option>\n";
 }
?>
</select></td>

<tr>
<td><span class="text"><? xl('NPI','e'); ?>: </span></td><td><input type="entry" name="npi" size="20"></td>
<td><span class="text"><? xl('Job Description','e'); ?>: </span></td><td><input type="entry" name="specialty" size="20"></td>
</tr>
<!-- (CHEMED) Calendar UI preference -->
<tr>
<td><span class="text"><? xl('Calendar UI','e'); ?>: </span></td><td><select name="cal_ui">
<?php
 foreach (array(1 => xl('Default'), 2 => xl('Fancy'), 3 => xl('Outlook')) as $key => $value)
 {
  echo " <option value='$key'";
  if ($key == $iter['cal_ui']) echo " selected";
  echo ">$value</option>\n";
 }
?>
</select></td>
<td>&nbsp;</td>
</tr>
<!-- END (CHEMED) Calendar UI preference -->

<?php
 // List the access control groups if phpgacl installed
 if (isset($phpgacl_location) && acl_check('admin', 'acl')) {
?>
  <tr>
  <td class='text'><? xl('Access Control','e'); ?>:</td>
  <td><select name="access_group[]" multiple>
  <?php
   $list_acl_groups = acl_get_group_title_list();
   $default_acl_group = 'Administrators';
   foreach ($list_acl_groups as $value) {
    if ($default_acl_group == $value) {
     echo " <option selected>$value</option>\n";
    }
    else {
     echo " <option>$value</option>\n";
    }
   }
  ?>
  </select></td></tr>
<?php
 }
?>

</table>
<span class=text><? xl('Additional Info','e'); ?>: </span><br>
<textarea name=info cols=40 rows=4 wrap=auto></textarea>
<br><input type="hidden" name="newauthPass">
<input type="submit" onClick="javascript:this.form.newauthPass.value=MD5(this.form.clearPass.value);this.form.clearPass.value='';" value=<? xl('Add User','e'); ?>>
</form>
</td>

</tr>

<tr<?php if ($GLOBALS['disable_non_default_groups']) echo " style='display:none'"; ?>>

<td valign=top>
<form name='new_group' method='post' action="usergroup_admin.php"
 onsubmit='return top.restoreSession()'>
<br>
<input type=hidden name=mode value=new_group>
<span class=bold><? xl('New Group','e'); ?>:</span>
</td><td>
<span class=text><? xl('Groupname','e'); ?>: </span><input type=entry name=groupname size=10>
&nbsp;&nbsp;&nbsp;
<span class=text><? xl('Initial User','e'); ?>: </span>
<select name=username>
<?php
$res = sqlStatement("select distinct username from users where username != ''");
for ($iter = 0;$row = sqlFetchArray($res);$iter++)
  $result[$iter] = $row;
foreach ($result as $iter) {
  print "<option value='".$iter{"username"}."'>" . $iter{"username"} . "</option>\n";
}
?>
</select>
&nbsp;&nbsp;&nbsp;
<input type="submit" value=<? xl('Add Group','e'); ?>>
</form>
</td>

</tr>

<tr<?php if ($GLOBALS['disable_non_default_groups']) echo " style='display:none'"; ?>>

<td valign=top>
<form name='new_group' method='post' action="usergroup_admin.php"
 onsubmit='return top.restoreSession()'>
<input type=hidden name=mode value=new_group>
<span class=bold><? xl('Add User To Group','e'); ?>:</span>
</td><td>
<span class=text>
<? xl('User','e'); ?>
: </span>
<select name=username>
<?php
$res = sqlStatement("select distinct username from users where username != ''");
for ($iter = 0;$row = sqlFetchArray($res);$iter++)
  $result3[$iter] = $row;
foreach ($result3 as $iter) {
  print "<option value='".$iter{"username"}."'>" . $iter{"username"} . "</option>\n";
}
?>
</select>
&nbsp;&nbsp;&nbsp;
<span class=text><? xl('Groupname','e'); ?>: </span>
<select name=groupname>
<?php
$res = sqlStatement("select distinct name from groups");
$result2 = array();
for ($iter = 0;$row = sqlFetchArray($res);$iter++)
  $result2[$iter] = $row;
foreach ($result2 as $iter) {
  print "<option value='".$iter{"name"}."'>" . $iter{"name"} . "</option>\n";
}
?>
</select>
&nbsp;&nbsp;&nbsp;
<input type="submit" value=<? xl('Add User To Group','e'); ?>>
</form>
</td>

</tr>

</table>

<hr>

<table border=0 cellpadding=1 cellspacing=2>
<tr><td><span class=bold><? xl('Username','e'); ?></span></td><td><span class=bold><? xl('Real Name','e'); ?></span></td><td><span class=bold><? xl('Info','e'); ?></span></td><td><span class=bold><? xl('Authorized','e'); ?>?</span></td></tr>
<?php
$res = sqlStatement("select * from users where username != '' order by username");
for ($iter = 0;$row = sqlFetchArray($res);$iter++)
  $result4[$iter] = $row;
foreach ($result4 as $iter) {
  if ($iter{"authorized"}) {
    $iter{"authorized"} = xl('yes');
  } else {
      $iter{"authorized"} = "";
  }

  print "<tr><td><span class=text>" . $iter{"username"} .
    "</span><a href='user_admin.php?id=" . $iter{"id"} .
    "' class='link_submit' onclick='top.restoreSession()'>(Edit)</a>" .
    "</td><td><span class=text>" .
    $iter{"fname"} . ' ' . $iter{"lname"}."</span></td><td><span class=text>" .
    $iter{"info"} . "</span></td><td align='center'><span class=text>" .
    $iter{"authorized"} . "</span></td>";
  print "<td><!--<a href='usergroup_admin.php?mode=delete&id=" . $iter{"id"} .
    "' class='link_submit'>[Delete]</a>--></td>";
  print "</tr>\n";
}
?>

</table>

<hr>

<?php
if (empty($GLOBALS['disable_non_default_groups'])) {
  $res = sqlStatement("select * from groups order by name");
  for ($iter = 0;$row = sqlFetchArray($res);$iter++)
    $result5[$iter] = $row;

  foreach ($result5 as $iter) {
    $grouplist{$iter{"name"}} .= $iter{"user"} .
      "(<a class='link_submit' href='usergroup_admin.php?mode=delete_group&id=" .
      $iter{"id"} . "' onclick='top.restoreSession()'>Remove</a>), ";
  }

  foreach ($grouplist as $groupname => $list) {
    print "<span class=bold>" . $groupname . "</span><br>\n<span class=text>" .
      substr($list,0,strlen($list)-2) . "</span><br>\n";
  }
}
?>

<script language="JavaScript">
<?php
  if ($alertmsg = trim($alertmsg)) {
    echo "alert('$alertmsg');\n";
  }
?>
</script>

</body>
</html>
