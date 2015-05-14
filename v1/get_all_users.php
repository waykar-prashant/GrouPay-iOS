<?php

$sql = "select * from user_details where 1";
$result = mysqli_query($con, $sql);
$users = array();
while($row = mysqli_fetch_array($result))
{
	$user_details = array("user_id"=>$row['user_id'], "name"=>$row['name'], "email"=>$row['email']);
	array_push($users, $user_details);
}

print_r(json_encode($users));

?>
