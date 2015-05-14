<?php 

//echo "Register yourself here";
//$user_id = $_GET['user_id'];
$name = $_POST['name'];
$email = $_POST['email'];
$phone_no = $_POST['phone_no'];
$password = $_POST['password'];

//check if this user already exists based on emailid
$isPresent = 0;
$sql = "select email from user_details";
$result = mysqli_query($con, $sql);
while($row = mysqli_fetch_array($result))
{
	if($row['email'] == $email)
	{
		$isPresent = 1;
	}
}

//insert it into the database and create a user_id if email not present
if($isPresent == 0)
{
	$sql = "insert into user_details (name, email, phone_no, password) values ('$name', '$email', '$phone_no', '$password')";
	if (mysqli_query($con, $sql)) {
		$last_id = mysqli_insert_id($con);
		$arr= array("user_id"=>$last_id, "name"=>$name, "email"=>$email, "phone_no"=>$phone_no, "password"=>$password);
		print_r(json_encode($arr));
	} else {
		echo "Error: " . $sql . "<br>" . mysqli_error($con);
	}
}
else
{
	echo "Sorry, this email id already exists.";
}	

?>