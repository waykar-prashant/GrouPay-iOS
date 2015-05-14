<?php

//get inputs like user_id, group_id
$user_id = $_GET['user_id'];
$group_id = $_GET['group_id'];
$admin_id = 0;
$sql_getMembers = "";
$newAdmin_id = 0;


//check if the user is a part of that group
$sql_checkPresence = "select user_id from group_member where group_id = $group_id and user_id = $user_id";
$result_presence = mysqli_query($con, $sql_checkPresence);
$row_presence = mysqli_fetch_array($result_presence);
if($row_presence != null)
{
	//user eligible for being deleted
	$sql_checkAdmin = "select * from `group` where group_id = $group_id";
	$result_checkAdmin = mysqli_query($con, $sql_checkAdmin);
	while($rowData = mysqli_fetch_assoc($result_checkAdmin)) 
	{
	       $admin_id = $rowData['admin_id'];
	}
	//check if the person to be deleted is the admin
	if($admin_id == $user_id)
	{
		//choose another admin
		echo "you are going to delete the admin";
		$sql_getMembers = "select user_id from group_member where group_id = $group_id";
		$result_getAdmin = mysqli_query($con, $sql_getMembers);
		
		while($row_getAdmin = mysqli_fetch_array($result_getAdmin))
		{
			if($row_getAdmin['user_id'] != $user_id)
			{
				$newAdmin_id = $row_getAdmin['user_id'];
				break;
			}
		}
		//map newAdmin to group's admin
		echo " NewAdmin is: ". $newAdmin_id;
		if($newAdmin_id != 0)
		{
			echo "new admin found";
			$sql_updateAdmin = "UPDATE `group` SET `admin_id`=$newAdmin_id WHERE `group_id` = $group_id";
			mysqli_query($con, $sql_updateAdmin);
		}
		else
		{
			echo "only person";
			//he is the only member of the group so delete the group itself
			//echo "deleting group"
			$sql_delete_group = "delete from `group` where group_id=$group_id";
			mysqli_query($con, $sql_delete_group);
		}

	}
	
	//in any case delete the person from group_member
	$sql_deleteMember = "delete from group_member where group_id = $group_id and user_id = $user_id";
	if(mysqli_query($con, $sql_deleteMember))
	{
		//success
		$arr= array("success"=>true);
		print_r(json_encode($arr));
	}
	else
	{
		echo "Error: " . $sql . "<br>" . mysqli_error($con);
	}

}
else
{
	echo "Sorry, the user is not a part of this group";
}
//delete the membership of events that the user is into from that group:


?>