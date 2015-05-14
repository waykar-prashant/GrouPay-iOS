<?php

$event_id = $_GET['event_id'];
$user_id = $_GET['user_id'];
$status = $_GET['status'];
$creator_id = 0;

$sql_checkAdmin = "select * from event where event_id=$event_id";
$result_checkAdmin = mysqli_query($con, $sql_checkAdmin);
while($row_checkAdmin = mysqli_fetch_array($result_checkAdmin))
{
	$creator_id = $row_checkAdmin['creator_id'];
}

$sql = "select * from event_member where event_id = $event_id and user_id=$user_id";
$result = mysqli_query($con, $sql);
while($row = mysqli_fetch_array($result))
{
	// $details = array("event_id"=>$row['event_id'], "name"=>$row['name'], "creator_id"=>$row['creator_id'], "start_time"=>$row['start_time'], "end_time"=>$row['end_time'], "description"=>$row["description"], "fee"=>$row['fee']);
	if($row['paid'] == 0)
	{
		if($creator_id != $user_id)
		{
			$sql_update = "update event_member set status = $status where user_id = $user_id and event_id = $event_id";
			mysqli_query($con, $sql_update);
			$details = array("success"=>"true");
			print_r(json_encode($details));
		}
	}
	else
	{
		echo "Sorry you have already paid for this event";
	}
	
}
// print_r(json_encode($details));

?>
