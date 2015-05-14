<?php

$event_id = $_GET['event_id'];

$sql = "select * from event where event_id = $event_id";
$result = mysqli_query($con, $sql);
while($row = mysqli_fetch_array($result))
{
	$details = array("event_id"=>$row['event_id'], "name"=>$row['name'], "creator_id"=>$row['creator_id'], "start_time"=>$row['start_time'], "end_time"=>$row['end_time'], "description"=>$row["description"], "fee"=>$row['fee']);
	
}
$sql_members = "select event_member.user_id, event_member.status, event_member.paid, user_details.name from event_member INNER JOIN user_details ON user_details.user_id = event_member.user_id and event_member.event_id=$event_id and event_member.status=1;";
$result_members = mysqli_query($con, $sql_members);
$members = array();
while($row_members = mysqli_fetch_array($result_members))
{
	$member_details = array("user_id"=>$row_members['user_id'], "name"=>$row_members['name'],"status"=>$row_members['status'], "paid"=>$row_members['paid']);
	array_push($members, $member_details);
}
array_push($details, $members);
print_r(json_encode($details));
//api=create_event&group_id=16&creator_id=101&start_time=2015-04-11+00%3A00%3A00&end_time=2015-04-18+00%3A00%3A00&fee=20&name=Brain+Storm&description=Classic+Session
?>
