<?php 
//user_id, group_name, create_date, compulsory_amount

$admin_id = $_POST['user_id'];
$name = $_POST['name'];
$created_date = date('Y-m-d');


$sql = "INSERT INTO `groupay`.`group` (`name`, `admin_id`, `created_date`) VALUES ('$name', $admin_id, '$created_date');";
if (mysqli_query($con, $sql)) {
	$last_id = mysqli_insert_id($con);
	$arr= array("group_id"=>$last_id, "name"=>$name, "admin_id"=>$admin_id, "created_date"=>$created_date);
	print_r(json_encode($arr));
	//add admin to group_member
	$sql = "insert into group_member (user_id, group_id) values ($admin_id, $last_id)";
	mysqli_query($con, $sql);
} else {
	echo "Error: " . $sql . "<br>" . mysqli_error($con);
}

?>

