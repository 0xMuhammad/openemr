<?
require_once(dirname(__FILE__) . "/../includes/config.php");
//Global variable file in which colors and paths are set for the interface.
//Pennington Firm (PennFirm.com), San Diego, California
//888-480-5050
///////////////////////////////////////////////////////////////////
//THESE VALUES MUST BE SET BEFORE OPENEMR WILL FUNCTION:
///////////////////////////////////////////////////////////////////
//Set this to the full absolute directory path for openemr:
$webserver_root = "/var/www/html/openemr";

//Set this to the relative html path, ie. what you would type into the web
//browser after the server address to get to OpenEMR
//For example, if you type "http://127.0.0.1/pennfirm/openemr/"
//to load OpenEMR, set $web_root to "/pennfirm/openemr" without the
//trailing slash.
$web_root = "/openemr";


///////////////////////////////////////////////////////////////////

//This is the return mail address used when sending prescriptions by email
$GLOBALS['practice_return_email_path'] = "prescription_mail@example.com";

//root directory, relative to the webserver root:
$GLOBALS['rootdir'] = "$web_root/interface";
//absolute path to the source code include and headers file directory (Full path):
$GLOBALS['srcdir'] = "$webserver_root/library";
//absolute path to the location of interface root directory for use with include statements:
$GLOBALS['fileroot'] = "$webserver_root";
//absolute path to the location of interface root directory for use with include statements:
$include_root = "$webserver_root/interface";
//absolute path to the location of interface root directory for use with include statements:
$GLOBALS['webroot'] = $web_root;
$GLOBALS['template_dir'] = $GLOBALS['fileroot'] . "/templates/";
$GLOBALS['incdir'] = $include_root;
//location of the login screen file
$GLOBALS['login_screen'] = "$rootdir/login_screen.php";
//default category for find_patient screen
$GLOBALS['default_category'] = 5;
$GLOBALS['default_event_title'] = 'Office Visit';

//SESSION SETTINGS
session_name("OpenEMR");
session_start();
#print(session_id());

//this is the theme definition for a beige theme:


$top_bg_line = ' bgcolor="#94d6e7" ';
$GLOBALS['style']['BGCOLOR2'] = "#94d6e7";
$bottom_bg_line = ' background="'.$rootdir.'/pic/aquabg.gif" ';
$login_filler_line = ' bgcolor="#f7f0d5" ';
$login_body_line = ' background="'.$rootdir.'/pic/aquabg.gif" ';
$title_bg_line = ' bgcolor="#aaffff" ';
$nav_bg_line = ' bgcolor="#94d6e7" ';
$css_header = "$rootdir/themes/style_sky_blue.css";
$logocode="<img src='$rootdir/pic/logo_sky.gif'>";
$linepic = "$rootdir/pic/repeat_vline9.gif";
$table_bg = ' bgcolor="#cccccc" ';
$GLOBALS['style']['BGCOLOR1'] = "#cccccc";
$GLOBALS['style']['TEXTCOLOR11'] = "#222222";
$GLOBALS['style']['HIGHLIGHTCOLOR'] = "#dddddd";
$GLOBALS['style']['BOTTOM_BG_LINE'] = $bottom_bg_line;

// the height in pixels of the Logo bar at the top of the login page.
$GLOBALS['logoBarHeight'] = 110;
// the height in pixels of the Navigation bar
$GLOBALS['navBarHeight'] = 20;
// the height in pixels of the Title bar
$GLOBALS['titleBarHeight'] = 20;


//the assistant word, MORE printed next to titles that can be clicked
$tmore = "(More)";

//the assistant word, BACK printed next to titles that return to previous screens
$tback = "(Back)";

//This is the idle logout function:
//if a page has not been refreshed within this many seconds, the interface
//will return to the login page
if ($special_timeout > 0) {
	$timeout = intval($special_timeout);
	//echo "Setting special timeout as $special_timeout";
}
else {
	//echo "setting regular timeout";
	// Max Idle Time before logout.  Default 3600 (60 minutes)
	$timeout = 3600;
}

//Version tags

$v_major = '2';
$v_minor = '7';
$v_patch = '0';


$tag = ''; //early access

$openemr_version = "$v_major.$v_minor.$v_patch".$tag;	// Version tag used by program

$rootdir = $GLOBALS['rootdir'];
$srcdir = $GLOBALS['srcdir'];
$login_screen = $GLOBALS['login_screen'];
$GLOBALS['css_header'] = $css_header;
$GLOBALS['backpic'] = $backpic;
$GLOBALS['rootdir'] = $rootdir;
//change these to reflect when the daily view should start to display times
//as well as it should end. ex schedule_start = 9 schedule_end = 17
// start end times in hours
$GLOBALS['schedule_start'] = 9;
$GLOBALS['schedule_end'] = 17;
// the interval in minutes that the day calendar will display
$GLOBALS['calendar_interval'] =15;
// the width in charactors that the day view calendar will display the title and patient name
$GLOBALS['day_view_td_width'] =30;
//include the authentication module code here, but the rule is
//if the file has the word "login" in the source code file name,
//don't include the authenticatio module - we do this to avoid
//include loops
if (!$ignoreAuth) {
	include_once("$srcdir/auth.inc");
}

// If you do not want your accounting system to have a customer added to it
// for each insurance company, then set this to true.  SQL-Ledger currently
// (2005-03-21) does nothing useful with insurance companies as customers.
//
$GLOBALS['insurance_companies_are_not_customers'] = false;

$encounter = $_SESSION['encounter'];

if (!empty($_GET['pid']) && empty($_SESSION['pid'])) {
	$_SESSION['pid'] = $_GET['pid'];
}
elseif (!empty($_POST['pid']) && empty($_SESSION['pid'])) {
	$_SESSION['pid'] = $_POST['pid'];
}
$pid = $_SESSION['pid'];
$userauthorized = $_SESSION['userauthorized'];
$groupname = $_SESSION['authProvider'];

//global interface function to format text length using ellipses
function strterm($string,$length) {
	if (strlen($string) >= ($length-3)) {
		return substr($string,0,$length-3) . "...";
	} else {
		return $string;
	}
}

//required for normal operation because of recent changes in PHP:
$ps = strpos($_SERVER['REQUEST_URI'],"myadmin");
if ($ps === false) {
	extract($_GET);
	extract($_POST);
}

//turn off PHP compatibility warnings
ini_set("session.bug_compat_warn","off");
?>
