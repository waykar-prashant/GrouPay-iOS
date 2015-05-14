<?php
//get inputs like user_id, group_id
$user_id = $_GET['user_id'];
$event_id = $_GET['event_id'];


//check if the user is a part of that group
$sql = "delete from event_member where user_id = $user_id and event_id = $event_id";
if(mysqli_query($con, $sql))
{
	$sql_event = "delete from event where event_id = $event_id";
	mysqli_query($con, $sql_event);
	$arr= array("success"=>true);
		print_r(json_encode($arr));
}
else
{
	echo "Sorry, you are not a part of this event";
}
?>