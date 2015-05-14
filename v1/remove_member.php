<?php 
//add user to the group: groupID-(check if the user is admin of that group), userID(user to be invited), userEmail
global $con;
$user_id = $_POST['user_id'];
$group_id = $_POST['group_id'];
$groupLive = 0;
$adminFound ="";
$sql_getMembers = "select user_id from group_member where group_id = $group_id";
		
//check if the user is a member of that group
$sql = "select user_id from group_member where group_id = $group_id and user_id = $user_id";
if($con != null)
	echo "Connection is not NULL";
$result = mysqli_query($con, $sql);
$row = mysqli_fetch_array($result);
print_r($row);
// if($row != null)
// 	echo "can be deleted";
// else
// 	echo "sorry";
if (true)  
{
	//check if the user is the admin of that group
	//echo "User is a part of the group : ".$group_id;

	$sql_checkAdmin = "select * from `group` where group_id = 9";
	$result_checkAdmin = mysqli_query($con, $sql_checkAdmin);

	if (mysqli_num_rows($result_checkAdmin) > 0) {
	    // output data of each row
	    while($rowData = mysqli_fetch_assoc($result_checkAdmin)) {
	        echo "id: " . $rowData['admin_id']. "<br>";
	    }
	} else {
	    echo "0 results";
	}


	/*if($result_checkAdmin!= null)
	{
		$row_checkAdmin = mysqli_fetch_array($result_checkAdmin);
		$adminFound = $row_checkAdmin['admin_id'];
		$groupLive = 1;
		echo "checking for admin";
	}*/

	/*if($groupLive == 1 && $adminFound == $user_id)
	{
		echo "The user to be deleted is admin";
		//assign a new admin to the group
		$result_searchNewAdmin = mysqli_query($con, $sql_getMembers);

			while($row = mysqli_fetch_array($result_searchNewAdmin))
		{
			if($row['admin_id'] != $user_id)
			{
				$newAdmin = $row['admin_id'];
			}
		}
		echo "found new admin as ".$newAdmin;
		$sql_updateAdmin = "UPDATE `group` SET `admin_id`=$newAdmin WHERE `group_id` = $group_id";
		mysqli_query($con, $sql_updateAdmin);
		
	}*/

	// // $sql_deleteMember = "delete from group_member where group_id = $group_id and user_id = $user_id";
	// // if (mysqli_query($con, $sql_deleteMember)) 
	// // {
	// // 	$arr= array("success"=>true);
	// // 	print_r(json_encode($arr));
	// // 	//check if anymore members are left in the group
	// // 	if($result_membersPresent = mysqli_query($con, $sql_getMembers))
	// // 	{
	// // 		//do nothing
	// // 	}
		
	// // 	else
	// // 	{
	// // 		//no members left in this group so delete the group from group table
	// // 		$sql_deleteGroup = "delete from group where group_id = $group_id";
	// // 		//also delete the events of group
	// // 		//delete the expenses from group

	// // 	}	

	// } 
// 	else 
// {
// 	echo "Error: " . $sql . "<br>" . mysqli_error($con);
// }
}
else
{
	echo "Sorry, this user is no more a part of this group";
}

?>
