<?php 
//post event- userID, groupID, eventID, eventName, eventType, donationAmountPerPerson 


$event_name = $_POST['event_name'];
$event_description = $_POST['event_description'];
$group_name = $_POST['group_name'];
$userid = $_POST['userid'];
$fee = $_POST["fee"];
$creation_date = date('Y-m-d H:i:s');
$type = "event_invite";

$sql = "select * from groups_joined where group_name = '$group_name' and userid = $userid";
if ($result = mysqli_query($con, $sql))  
{
	//Post event
	$sql_post = "insert into event_details (event_name, event_description, group_name, userid, fee, creation_date) values ('$event_name', '$event_description', '$group_name', $userid, $fee, '$creation_date')";
	if (mysqli_query($con, $sql_post)) 
	{
		$last_id = mysqli_insert_id($con);
		$arr= array("event_name"=>$event_name, "event_description"=>$event_description, "group_name"=>$group_name, "userid"=>$userid, "fee"=>$fee, "creation_date"=>$creation_date);
		print_r(json_encode($arr));

		//Send event request to all group members
		$sql_request = "select * from groups_joined where group_name = '$group_name'";
		if ($result = mysqli_query($con, $sql_request))  
{
while($row = mysqli_fetch_array($result))
		{
			//print_r($row);
			if ($row['userid'] != $userid)
			{
				$to_userid = $row['userid'];
				$sql_send_requests = "insert into pending_requests (from_userid, to_userid, group_name, date_sent, type, fee, invite_description) values ($userid, $to_userid, '$group_name', '$creation_date', '$type', $fee, '$event_description')";
				if(mysqli_query($con, $sql_send_requests))
				{

				}
				else{
					echo "Error while sending event invites";
				}

			}			
		}

	} else {
	echo "Error: " . $sql . "<br>" . mysqli_error($con);
	
		}
}
}else{
	echo "Error: Sorry, you are not authorized to perform this operation.";
}	


?>


