<?php 
//echo "checking authentication...";
$user_id = $_POST['user_id'];

//check if this user already exists based on emailid
$sql = "select * from user_details where user_id = $user_id";
if($result = mysqli_query($con, $sql))
{
	$row = mysqli_fetch_array($result);
	$arr= array("user_id"=>$row['user_id'], "name"=>$row['name'], "email"=>$row['email'], "phone_no"=>$row['phone_no'], "password"=>$row['password']);
		print_r(json_encode($arr));
} else {
		echo "Error: " . $sql . "<br>" . mysqli_error($con);
	}
?>