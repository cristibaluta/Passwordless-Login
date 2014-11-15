<?php  

require_once('../config.php');

$con = mysql_connect("localhost", $db_user, $db_pass);  
mysql_select_db('ralcr_qreminders');
if (!$con) die('Could not connect: ' . mysql_error());

$sqlstr = mysql_query("select * FROM users");
$output = "{\"users\":[";
$max_rows = mysql_numrows($sqlstr);
$current_row = 0;
if ($max_rows > 0) {
	while ($row = mysql_fetch_array($sqlstr)) {
		$current_row ++;
		$output = $output.
		"{\"uuid\":\"".$row['uuid'].
		"\",\"name\":\"".$row['name'].
		"\",\"email\":\"".$row['email'].
		"\",\"date_added\":\"".$row['date_added'].
		"\",\"fb_uid\":\"".$row['fb_uid'].
		"\",\"loc_latitude\":\"".$row['loc_latitude'].
		"\",\"loc_longitude\":\"".$row['loc_longitude'].
		"\"}".
		($current_row < $max_rows ? ", " : "");
	}
}

$output = $output."]}";
echo $output;

?>
