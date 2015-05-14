<?php

$user_id = $_POST['user_id'];
$event_id = $_POST['event_id'];
$amount = $_POST['amount'];

$sql_update = "update event_member set paid = $amount where user_id = $user_id and event_id = $event_id";
if($result = mysqli_query($con, $sql_update))
{
	$details = array("success"=>"true");
	print_r(json_encode($details));
}
else
{
	echo "Sorry, the amount could not be updated";
}



?>