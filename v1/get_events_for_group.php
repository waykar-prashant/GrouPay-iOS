<?php

$group_id = $_POST['group_id'];
$events = array();
$sql_getEvents = "select * from event where group_id = $group_id";
$result_getEvents = mysqli_query($con, $sql_getEvents);

while ($row = mysqli_fetch_array($result_getEvents)) 
	{
		$event_id = $row['event_id'];
		$event_name = $row['name'];
		$details = array("event_id"=>$event_id, "name"=>$event_name);
					array_push($events, $details);
		
	}
	print_r(json_encode($events));



?>