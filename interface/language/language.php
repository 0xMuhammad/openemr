<?php
//INCLUDES, DO ANY ACTIONS, THEN GET OUR DATA
include_once("../globals.php");
include_once("$srcdir/registry.inc");
include_once("$srcdir/sql.inc");
include_once("../../library/acl.inc");
require_once("language.inc.php");
require_once("$srcdir/formdata.inc.php");

//START OUT OUR PAGE....
?>
<html>
<head>
<?php html_header_show();?>
<link rel="stylesheet" href="<?php echo $css_header;?>" type="text/css">
<script type="text/javascript" src="../../library/overlib_mini.js"></script>
<script type="text/javascript" src="../../library/calendar.js"></script>
</head>

<body class="body_top">	
<form name='translation' id='translation' method='get' action='language.php' onsubmit="return top.restoreSession()">
<input type='hidden' name='m' value='<?php echo strip_escape_custom($_GET['m']); ?>' />
<input type='hidden' name='edit' value='<?php echo strip_escape_custom($_GET['edit']); ?>' />
<span class="title"><?php  xl('Multi Language Tool','e') ?></span>
<table>
 <tr>
  <td class="small" colspan='4'>
   <a href="?m=definition" onclick="top.restoreSession()"><?php xl('Edit Definitions','e'); ?></a> | 
   <a href="?m=language" onclick="top.restoreSession()"><?php xl('Add Language','e'); ?></a> | 
   <a href="?m=constant" onclick="top.restoreSession()"><?php xl('Add Constant','e'); ?></a> |
   <a href="?m=manage" onclick="top.restoreSession()"><?php xl('Manage Translations','e'); ?></a>
  </td>
 </tr>
</table>
</form>

<?php
switch ($_GET['m']):
	case 'definition':
		include_once('lang_definition.php');
	        break;
	case 'constant':
		include_once('lang_constant.php');
	        break;
	case 'language':
		include_once('lang_language.php');
	        break;
        case 'manage':
                include_once('lang_manage.php');
                break;
endswitch;
?>

<BR><A HREF="lang.info.html" TARGET="_blank"><?php xl('Info','e'); ?></A>
</body>
</html>