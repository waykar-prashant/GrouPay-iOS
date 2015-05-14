<?php

$event_id = $_POST['event_id'];
$to_email = $_POST['to_email'];
$from_user_id = $_POST['from_user_id'];
$from_user_name = "";
$from_user_email ="";
$event_name = "";
$event_description = "";
$start_time = "";
$end_time = "";
$fee = "";

$sql_checkPresence = "select * from user_details where email = '$to_email'";
$result_checkPresence = "";
$result_checkPresence = mysqli_query($con, $sql_checkPresence);

if (mysqli_num_rows($result_checkPresence) <= 0)
{
	$sql = "select * from user_details where user_id = $from_user_id";
if($result = mysqli_query($con, $sql))
{
	while ($row = mysqli_fetch_array($result)) 
	{
		$from_user_name = $row['name'];
		$from_user_email = $row['email'];
	}
	echo $from_user_name . "  " . $from_user_email;
}
//get the evnt info to be written in the mail
echo "getting event info";
$sql_getEventInfo = "select * from event where event_id = $event_id";
$result_event = mysqli_query($con, $sql_getEventInfo);
$row = mysqli_fetch_array($result_event);
$event_name = $row['name'];
$event_description = $row['description'];
$start_time = $row['start_time'];
$end_time = $row['end_time'];
$fee = $row['fee'];
echo $event_name . "  " . $event_description . "  " . $start_time . "  " . $end_time . "  " . $fee; 


	//using these values send email to to_email 
}

else
{
	echo "This user is already in Groupay";
}



?>