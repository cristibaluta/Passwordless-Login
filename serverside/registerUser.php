<?php

require_once('../config.php');

if (isset($_POST['uuid'])) {
	$con = mysql_connect("localhost", $db_user, $db_pass);  
	mysql_select_db('ralcr_qreminders');
	if (!$con) die("{\"error\":\"Could not connect to the database\"}");
	
	$loc_latitude = $_POST['loc_latitude'];
	$loc_longitude = $_POST['loc_longitude'];
	$uuid = $_POST['uuid'];
	$deviceModel = $_POST['deviceModel'];
	$deviceName = $_POST['deviceName'];
	$systemVersion = $_POST['systemVersion'];
	$facebookID = $_POST['facebookID'];
	$email = $_POST['email'];
	$name = $_POST['name'];
	$output = "";
	
	// Check if this unique id exists
	$sqlstr = mysql_query("select * FROM users WHERE uuid = '".$uuid."'");
	
	if (mysql_numrows($sqlstr) == 0) {
		
		// This id was not registered before, register now
		$set = "insert INTO users (`uuid`,
		`device_model`,
		`device_name`,
		`system_version`,
		`loc_latitude`,
		`loc_longitude`,
		`fb_uid`,
		`name`,
		`email`) VALUES ('$uuid',
		'$deviceModel',
		'$deviceName',
		'$systemVersion',
		'$loc_latitude',
		'$loc_longitude',
		'$facebookID',
		'$name',
		'$email')";
		
		mysql_query($set);
		$output = "{\"success\":\"User registered\"";
	}
	else {
		// If the user id exists already, update all other infos
		if ($name == "") $name = NULL;
		if ($email == "") $email = NULL;
		if ($facebookID == "") $facebookID = NULL;
		
		mysql_query("update users SET 
			`loc_latitude`='$loc_latitude', 
			`loc_longitude`='$loc_longitude', 
			`fb_uid`=COALESCE($facebookID, fb_uid), 
			`name`='COALESCE($name, name)', 
			`email`=COALESCE($email, email), 
			`system_version`='$systemVersion', 
			`device_model`='$deviceModel' 
			`device_name`='$deviceName', 
			WHERE `uuid`='$uuid'");
		
		$output = "{\"success\":\"User info updated to server wh: $name\"";
	}
	
	// Request all assciated users
	require_once('associatedUsers.php');
	$sqlstr = mysql_query("select * FROM users WHERE uuid IN($uuids_string)");
	$output = $output.",\"users\":[";
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
			"\",\"device_model\":\"".$row['device_model'].
			"\",\"device_name\":\"".$row['device_name'].
			"\",\"system_version\":\"".$row['system_version'].
			"\",\"loc_latitude\":\"".$row['loc_latitude'].
			"\",\"loc_longitude\":\"".$row['loc_longitude'].
			"\"}".
			($current_row < $max_rows ? ", " : "");
		}
	}

	$output = $output."]";
	$output = $output.",\"asociated_users\":[$uuids_string2]}";
	echo $output;
}
else {
	echo "{\"warn\":\"Not enough info to register this user\"}";
}

?>