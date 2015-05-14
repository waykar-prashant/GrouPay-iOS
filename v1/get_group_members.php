<?php 
//add user to the group: groupID-(check if the user is admin of that group), userID(user to be invited), userEmail
//SELECT group.group_id, group.name, group.admin_id, group.created_date
//FROM `group`
//INNER JOIN `group_member`
//ON group.group_id = group_member.group_id and group_member.user_id=101;

$group_id = $_POST['group_id'];
$members = array();

$sql = "SELECT user_details.user_id, user_details.name
FROM  `group_member` 
INNER JOIN  `user_details` ON group_member.group_id =$group_id
AND user_details.user_id = group_member.user_id";
if ($result = mysqli_query($con, $sql))  
{
while($row = mysqli_fetch_array($result))
{//print_r($row);
	$details = array("user_id"=>$row['user_id'], "name"=>$row['name']);
	array_push($members, $details);
}
	print_r(json_encode($members));
}


?>


