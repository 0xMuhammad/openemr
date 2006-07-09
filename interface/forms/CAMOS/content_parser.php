<?
include_once("../../globals.php");
include_once("../../../library/sql.inc");	

//This function was copied from billing.inc and altered to support 'justify'
function addBilling2($encounter, $code_type, $code, $code_text, $modifier="",$units="",$fee="0.00",$justify)
{
  $justify_string = '';
  if ($justify)
  {
    $justify_string = implode(":",$justify).":";
  }
  $sql = "insert into billing (date, encounter, code_type, code, code_text, pid, authorized, user, groupname,activity,billed,provider_id,modifier,units,fee,justify) values (NOW(), '".$_SESSION['encounter']."', '$code_type', '$code', '$code_text', '".$_SESSION['pid']."', '$authorized', '" . $_SESSION['authId'] . "', '" . $_SESSION['authProvider'] . "',1,0,".$_SESSION['authUserID'].",'$modifier','$units','$fee','$justify_string')";
	
  return sqlInsert($sql);
	
}

function content_parser($input) {

   // parse content field
   $content = $input;

//   comments should really be removed in save.php
//   $content = remove_comments($content);

   //reduce more than two empty lines to no more than two.
   $content = preg_replace("/([^\n]\r[^\n]){2,}/","\r\r",$content);
   $content = preg_replace("/([^\r]\n[^\r]){2,}/","\n\n",$content);
   $content = preg_replace("/(\r\n){2,}/","\r\n\r\n",$content);


   return $content;
}

// implement C style comments ie remove anything between /* and */
function remove_comments($string_to_process) {
   return preg_replace("/\/\*.*?\*\//","",$string_to_process);
}
// This function is useless for now, don't use it
function remove_dangling_comments($string_to_process) {
   return preg_replace("/(\/\*)|(\*\/)/","",$string_to_process);
}

//process commands embedded in C style comments where function name is first
//followed by args separated by :: delimiter and nothing else
//must run this before remove_comments or there will be nothing left to process :)

function process_commands($string_to_process) {

  $camos_return_data = array(); // to be filled with additional camos form submissions if any embedded
  $command_array = array();  //to be filled with potential commands
  $matches= array();  //to be filled with potential commands
  if (!preg_match_all("/\/\*.*?\*\//",$string_to_process, $matches)) {return $camos_return_data;}
  $command_array = $matches[0];
  foreach($command_array as $val) {
    //process each command 
    $comm = preg_replace("/(\/\*)|(\*\/)/","",$val);
    $comm_array = split('::', $comm); //array where first element is command and rest are args
    //Here is where we process particular commands
    if (trim($comm_array[0])== 'billing') {
      array_shift($comm_array); //couldn't do it in 'if' or would lose element 0 for next if
      //insert data into the billing table, see, easy!
      $type = trim(array_shift($comm_array));  
      $code = trim(array_shift($comm_array));  
      $text = trim(array_shift($comm_array));  
      $modifier = trim(array_shift($comm_array));  
      $units = trim(array_shift($comm_array));  
      $fee = sprintf("%01.2f",trim(array_shift($comm_array)));  
      //in function call 'addBilling' note last param is the remainder of the array.  we will look for justifications here...
      addBilling2($encounter, $type, $code, $text, $modifier,$units,$fee,$comm_array);
    }
    if (trim($comm_array[0]) == 'camos') {
      //data to be submitted as separate camos forms
      //this is for embedded prescriptions, test orders etc... usually within a soap note or something  
      //data collected here will be returned so that save.php can give it special treatment and insert
      //into the database after the main form data is submitted so it will be in a sensible order 
      array_push($camos_return_data, 
        array("category" => trim($comm_array[1]), 
        "subcategory" => trim($comm_array[2]), 
        "item" => trim($comm_array[3]), 
        "content" => trim($comm_array[4]))); 
    }
  }
  return $camos_return_data;
} 
