<?php

//$event_id = $_GET['event_id'];
$to_email = $_POST['to_email'];
$from_user_id = $_POST['from_user_id'];
$from_user_name = "";
$from_user_email ="";

$sql_checkPresence = "select * from user_details where email = '$to_email'";// to find if the to_email already exists or not
$result_checkPresence = "";
$result_checkPresence = mysqli_query($con, $sql_checkPresence);

if (mysqli_num_rows($result_checkPresence) <= 0)
{
	$sql = "select * from user_details where user_id = $from_user_id";//to get the name and email of sender
if($result = mysqli_query($con, $sql))
{
	while ($row = mysqli_fetch_array($result)) 
	{
		$from_user_name = $row['name'];
		$from_user_email = $row['email'];
	}
	echo $from_user_name . "  " . $from_user_email;
}
//using these values send email to to_email 
}

else
{
	echo "This user is already in Groupay";
}



?>