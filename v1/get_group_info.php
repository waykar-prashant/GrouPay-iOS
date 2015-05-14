<?php 
//add user to the group: groupID-(check if the user is admin of that group), userID(user to be invited), userEmail
//SELECT group.group_id, group.name, group.admin_id, group.created_date
//FROM `group`
//INNER JOIN `group_member`
//ON group.group_id = group_member.group_id and group_member.user_id=101;

$group_id = $_GET['group_id'];
$members = array();
$member_details= array();

$sql = "SELECT group_id, name, admin_id, created_date FROM  `group` where group_id = $group_id";
if ($result = mysqli_query($con, $sql))  
{
	$row = mysqli_fetch_array($result);
	$details = array("group_id"=>$row['group_id'], "name"=>$row['name'], "admin_id"=>$row['admin_id'], "created_date"=>$row['created_date']);
	//print_r(json_encode($details));

}

//getting group members


$sql = "SELECT user_details.user_id, user_details.name, user_details.email, user_details.phone_no
FROM  `group_member` 
INNER JOIN  `user_details` ON group_member.group_id =$group_id
AND user_details.user_id = group_member.user_id";
if ($result = mysqli_query($con, $sql))  
{
while($row = mysqli_fetch_array($result))
{//print_r($row);
	$member_details = array("user_id"=>$row['user_id'], "name"=>$row['name'], "email"=>$row['email'], "phone_no"=>$row['phone_no']);
	
	array_push($members, $member_details);
}
	//$member_json = array("users"=>$members);
	array_push($details, $members);
}
//getting events
$events = array();
$sql_getEvents = "select * from event where group_id = $group_id";
$result_getEvents = mysqli_query($con, $sql_getEvents);

while ($row = mysqli_fetch_array($result_getEvents)) 
	{
		$event_id = $row['event_id'];
		$event_name = $row['name'];
		$event_details = array("event_id"=>$event_id, "name"=>$event_name);
		array_push($events, $event_details);
		
	}
	//$events_json = array("events"=>$events);
	array_push($details, $events);

	print_r(json_encode($details));
?>


