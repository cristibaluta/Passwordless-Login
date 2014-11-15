<?php  

require_once('../config.php');

//$_POST['uuid'] = "BD33F2CF-6DC5-4282-A5E0-ECC9C4BF4E3D";

if ( isset ( $_POST['uuid'])) {
	
	$con = mysql_connect("localhost", $db_user, $db_pass);  
	mysql_select_db('ralcr_qreminders');
	if (!$con) die('Could not connect: ' . mysql_error());
	
	$uuid = $_POST['uuid'];
	$email = $_POST['email'];
	$fb_uid = $_POST['facebookID'];
	
	$sql_get_user = mysql_query("select * FROM users WHERE uuid='$uuid'");
	$user = mysql_fetch_assoc($sql_get_user);
	// print_r($user);
	// printf('<br/><br/>');

	if ($user['fb_uid'] != "") {
		$fb_uid = $user['fb_uid'];
	}
	if ($user['email'] != "") {
		$email = $user['email'];
	}
	// printf('fb_uid %s</br>', $fb_uid);
	// printf('email %s</br>', $email);
	
	$uuids = array();
	
	$sql_get_associated_users = mysql_query("select * FROM users 
		WHERE (email='$email' AND email != '') 
		OR (fb_uid='$fb_uid' AND fb_uid != '')");
		
	while ($row = mysql_fetch_array($sql_get_associated_users)) {
		array_push($uuids, $row['uuid']);
		// print_r($row);
		// printf('<br/>');
	}
	// echo $uuids.count($uuids);
	if (count($uuids) == 0) {
		array_push($uuids, $uuid);
	}
	// echo $uuids.count($uuids);
	
	$uuids_string = "'" . implode("','", $uuids) . "'";
	$uuids_string2 = "\"" . implode("\",\"", $uuids) . "\"";
	// echo $uuids_string;
	// printf('<br/><br/>');
	// echo count($uuids);
	// printf('<br/><br/>');
	
}

?>
