<?php 
//echo "checking authentication...";
$email = $_POST['email'];
$password = $_POST['password'];

//check if this user already exists based on emailid
$sql = "select * from user_details where email = '$email' and password = '$password'";
if($result = mysqli_query($con, $sql))
{
	$row = mysqli_fetch_array($result);
	$arr= array("user_id"=>$row['user_id'], "name"=>$row['name'], "email"=>$row['email'], "phone_no"=>$row['phone_no'], "password"=>$row['password']);
		print_r(json_encode($arr));
} else {
		echo "Error: " . $sql . "<br>" . mysqli_error($con);
	}
?>