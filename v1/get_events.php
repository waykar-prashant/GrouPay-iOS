<?php

$user_id = $_POST['user_id'];
$events = array();
$sql_getEvents = "select * from event_member where user_id = $user_id";
$result_getEvents = mysqli_query($con, $sql_getEvents);

while ($row = mysqli_fetch_array($result_getEvents)) 
	{
		$event_id = $row['event_id'];
		$sql_event_details = "select * from event where event_id = $event_id";
		$result_event_details = mysqli_query($con, $sql_event_details);

		while($row = mysqli_fetch_array($result_event_details))
		{
			array_push($events, $row['name']);
		}
	}
	print_r(json_encode($events));



?>