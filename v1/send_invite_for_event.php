<?php 

$user_id = $_POST['user_id'];
$event_id = $_POST['event_id'];

$sql_checkPresence = "select * from event_member where user_id = $user_id and event_id = $event_id";
$result_checkPresence = mysqli_query($con, $sql_checkPresence);
if (mysqli_num_rows($result_checkPresence) <= 0)
{
	$sql = "select * from user_details where user_id = $user_id";
if ($result = mysqli_query($con, $sql))  
{
while($row = mysqli_fetch_array($result))
{//print_r($row);
	$to_email = $row['email'];
	$arr= array("email"=>$to_email);
	print_r(json_encode($arr));
}
//add the user in event_member with status=false and paid=0
$sql_insert = "insert into event_member values ($user_id, $event_id, 0, 0)";
mysqli_query($con, $sql_insert);
}
else
{
	echo "send request externally";
}
}
else
{
	echo "The user is already a part of this event";
}	



?>

