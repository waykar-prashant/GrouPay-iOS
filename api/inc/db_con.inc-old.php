<?php
	/*$Server = "localhost";
	$User = "root";
	$Pass = "";
	$DB = "mytimestation";*/
	
	$Server = "localhost";
	$User = "cufrin_time";
	$Pass = "Password@123";
	$DB = "cufrin_timestation";


	$con = mysql_connect($Server, $User, $Pass)
		or die('Could not connect to link: ' . mysql_error());

	mysql_select_db($DB,$con) 
	or die('Could not connect to database: ' . mysql_error());

?>