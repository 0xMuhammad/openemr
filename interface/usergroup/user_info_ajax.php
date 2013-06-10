<?php
/**
 * 
 * Controller to handle user password change requests.
 * 
 * <pre>
 * Expected REQUEST parameters
 * $_REQUEST['pk'] - The primary key being used for encryption. The browser would have requested this previously
 * $_REQUEST['curPass'] - ciphertext of the user's current password
 * $_REQUEST['newPass'] - ciphertext of the new password to use
 * $_REQUEST['newPass2']) - second copy of ciphertext of the new password to confirm proper user entry.
 * </pre>
 * Copyright (C) 2013 Kevin Yeh <kevin.y@integralemr.com> and OEMR <www.oemr.org>
 *
 * LICENSE: This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 3
 * of the License, or (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://opensource.org/licenses/gpl-license.php>;.
 *
 * @package OpenEMR
 * @author  Kevin Yeh <kevin.y@integralemr.com>
 * @author  Brady Miller <brady@sparmy.com)
 * @link    http://www.open-emr.org
 */

//SANITIZE ALL ESCAPES
$sanitize_all_escapes=true;

//STOP FAKE REGISTER GLOBALS
$fake_register_globals=false;

include_once("../globals.php");
require_once("$srcdir/authentication/rsa.php");
require_once("$srcdir/authentication/password_change.php");

if (isset($_REQUEST['pk']) & !empty($_REQUEST['pk'])) {
    // Use the rsa method to collect encrypted clear texts
    $rsa_manager = new rsa_key_manager();
    $rsa_manager->load_from_db($_REQUEST['pk']);
    $curPass=$rsa_manager->decrypt($_REQUEST['curPass']);
    $newPass=$rsa_manager->decrypt($_REQUEST['newPass']);
    $newPass2=$rsa_manager->decrypt($_REQUEST['newPass2']);
    if($newPass!=$newPass2)
    {
        echo xlt("Passwords Don't match!");
        exit;
    }
}
else {
    // rsa method not available, so collect and organize the client side hashes
    // by placing them in arrays; downstream functions will act accordingly.
    $curPass = array('phash_client' => $_REQUEST['curPass']);
    $newPass = array('phash_client' => $_REQUEST['newPass']);
    $newPass2 = array('phash_client' => $_REQUEST['newPass2']);
    if($newPass['phash_client']!=$newPass2['phash_client'])
    {
        echo xlt("Passwords Don't match!");
        exit;
    }
}

$errMsg='';
$success=update_password($_SESSION['authId'],$_SESSION['authId'],$curPass,$newPass,$errMsg);
if($success)
{
    echo xlt("Password change successful");
}
else
{
    // If update_password fails the error message is returned
    echo text($errMsg);
}
?>
