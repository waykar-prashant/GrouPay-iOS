<?php 
//add user to the group: groupID-(check if the user is admin of that group), userID(user to be invited), userEmail
//SELECT group.group_id, group.name, group.admin_id, group.created_date
//FROM `group`
//INNER JOIN `group_member`
//ON group.group_id = group_member.group_id and group_member.user_id=101;

$user_id = $_POST['user_id'];
$groups = array();

$sql = "SELECT group.group_id, group.name, group.admin_id, group.created_date FROM `group` INNER JOIN `group_member`ON group.group_id = group_member.group_id and group_member.user_id=$user_id;";
if ($result = mysqli_query($con, $sql))  
{
while($row = mysqli_fetch_array($result))
{//print_r($row);
	$details = array("group_id"=>$row['group_id'], "name"=>$row['name'], "admin_id"=>$row['admin_id'], "created_date"=>$row['created_date']);
	array_push($groups, $details);
}
	print_r(json_encode($groups));
}


?>


