<?php 

$user_id = $_POST['user_id'];
$expenses = array();
$total_expense = 0;

$sql = "select event_member.paid, event.name, event.fee, event.group_id, event.event_id from event_member INNER JOIN event ON event.event_id = event_member.event_id and event_member.user_id=$user_id and event_member.status=1;";
if ($result = mysqli_query($con, $sql))  
{
while($row = mysqli_fetch_array($result))
{//print_r($row);
	$balance = $row['fee'] - $row['paid'];
	$total_expense += $balance;
	$details = array("event_id"=>$row['event_id'], "name"=>$row['name'], "group_id"=>$row['group_id'], "fee"=>$row['fee'], "paid"=>$row['paid'], "balance"=>$balance);
	array_push($expenses, $details);
}
$total = array("total_expense"=>$total_expense);
array_push($expenses, $total);
//array_push($expenses, $total_expense);
	print_r(json_encode($expenses));
}


?>
