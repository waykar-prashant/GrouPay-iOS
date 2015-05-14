<?php 
//add user to the group: groupID-(check if the user is admin of that group), userID(user to be invited), userEmail

$user_id = $_POST['user_id'];
$group_id = $_POST['group_id'];
$isPresent = 0;
$members = array();

$sql = "select user_id from group_member where group_id = '$group_id'";
$result = mysqli_query($con, $sql);  

while($row = mysqli_fetch_array($result))
{//print_r($row);
	$member_id = $row['user_id'];
	if($member_id == $user_id)
	{
		$isPresent = 1;
		break;
	}
	else
	{
		array_push($members, $member_id);
	}
}


if($isPresent == 0)
{	
	$sql = "insert into group_member (user_id, group_id) values ($user_id, $group_id)";
	if (mysqli_query($con, $sql)) 
	{
		array_push($members, $user_id);
		$arr= array("group_id"=>$group_id, "members"=>$members);
		print_r(json_encode($arr));
	} else 
{
	echo "Error: " . $sql . "<br>" . mysqli_error($con);
}
}else
{
	echo "Sorry, this user is already in the group.";
}

?>


