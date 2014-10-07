<?php

require_once('../config.php');

if (isset($_POST['uuid'])) {
	$con = mysql_connect("localhost", $db_user, $db_pass);  
	mysql_select_db('ralcr_qreminders');
	if (!$con) die("{\"error\":\"Could not connect to the database\"}");
	
	$loc_latitude = $_POST['loc_latitude'];
	$loc_longitude = $_POST['loc_longitude'];
	$uuid = $_POST['uuid'];
	$fb_uid = $_POST['fb_uid'];
	$name = $_POST['name'];
	$email = $_POST['email'];
	
	// Check if this unique id exists
	$sqlstr = mysql_query("select * FROM users WHERE uuid = '".$uuid."'");
	
	if (mysql_numrows($sqlstr) == 0) {
		
		// This id was not registered before, register now
		$set = "insert INTO users (`uuid`,`loc_latitude`,`loc_longitude`,`fb_uid`,`name`,`email`) VALUES ('$uuid','$loc_latitude','$loc_longitude','$fb_uid','$name','$email')";
		mysql_query($set);
		echo "{\"success\":\"User registered\"}";
	}
	else {
		// If the user id exists already, update its location
		mysql_query("update users SET `loc_latitude`='$loc_latitude', `loc_longitude`='$loc_longitude' WHERE `uuid`='$uuid'");
		echo "{\"success\":\"User location updated on server\"}";
	}
}
else {
	echo "{\"warn\":\"Not enough info to register this user\"}";
}

?>