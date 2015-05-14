<?php 
//UserWantstoJoinGroup: userID, groupID, messageToAdmin

$userid = $_POST['userid'];
$group_name = $_POST['group_name'];
$message = $_POST['message'];

$sql = "select * from groups_joined where group_name = '$group_name' and userid = '$userid'";
$result = mysqli_query($con, $sql);
$row = mysqli_fetch_array($result);
if ($row == null)  
{
	$sql = "insert into group_requests values ($userid, '$group_name', '$message')";
	if (mysqli_query($con, $sql)) 
	{
		$arr= array("userid"=>$userid, "group_name"=>$group_name, "message"=>$message);
		print_r(json_encode($arr));
	} else {
	echo "Error: " . $sql . "<br>" . mysqli_error($con);
}
}
else{
	
	echo "Error: You are already a part of ". $group_name . " group.";
}	


//


?>

