<?php 
//add user to the group: groupID-(check if the user is admin of that group), userID(user to be invited), userEmail

$from_userid = $_POST['from_userid'];
$to_userid = $_POST['to_userid'];
$group_name = $_POST['group_name'];
$date_sent = date('Y-m-d H:i:s');
$type = "group_invite";
$fee = $_POST['fee'];
$invite_description = "Invitaion to join group ". $group_name;

$sql = "select * from group_details where group_name = '$group_name'";
if ($result = mysqli_query($con, $sql))  
{
$row = mysqli_fetch_array($result);
//print_r($row);
if($row['adminid'] == $from_userid)
{
	$sql = "insert into pending_requests (from_userid, to_userid, group_name, date_sent, type, fee, invite_description) values ($from_userid, $to_userid, '$group_name', '$date_sent', '$type', $fee, '$invite_description')";
	if (mysqli_query($con, $sql)) 
	{
		$last_id = mysqli_insert_id($con);
		$arr= array("from_userid"=>$from_userid, "to_userid"=>$to_userid, "group_name"=>$group_name, "date_sent"=>$date_sent, "type"=>$type, "fee"=>$fee, "invite_description"=>$invite_description);
		print_r(json_encode($arr));
	} else {
	echo "Error: " . $sql . "<br>" . mysqli_error($con);
}
}
else{
	echo "Error: Sorry, you are not authorized to perform this operation.";
}	
}

?>


