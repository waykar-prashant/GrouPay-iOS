<?php 
//post event- userID, groupID, eventID, eventName, eventType, donationAmountPerPerson 
//name=BlahEvetn&description=Fun filled event&group_id=12&start_time=2015-5-11 00:00:00&end_time=2015-5-20 00:00:00&fee=10&creator_id=101

$name = $_GET['name'];
$description = $_GET['description'];
$group_id = $_GET['group_id'];
$start_time = $_GET['start_time'];
$fee = $_GET["fee"];
$end_time = $_GET['end_time'];
$creator_id = $_GET['creator_id'];
$sql_send_requests = "";
$last_id = 0;

//check if the member is a part of that group
$sql = "select * from group_member where group_id = '$group_id' and user_id = $creator_id";
if ($result = mysqli_query($con, $sql))  
{
	//Post event
	//echo "posting event";
	$sql_post = "insert into event (name, description, creator_id, fee, start_time, end_time, group_id) values ('$name', '$description', $creator_id, $fee, '$start_time', '$end_time', $group_id)";
	if ($result_post = mysqli_query($con, $sql_post)) 
	{
		//echo "new event created...";
		$last_id = mysqli_insert_id($con);
		$arr= array("event_id"=>$last_id, "name"=>$name, "description"=>$description, "creator_id"=>$creator_id, "fee"=>$fee, "start_time"=>$start_time, "end_time"=>$end_time);
		print_r(json_encode($arr));

		//Send event request to all group members
		$sql_request = "select * from group_member where group_id = '$group_id'";
		if ($result = mysqli_query($con, $sql_request))  
{
while($row = mysqli_fetch_array($result))
		{
			//print_r($row);
				$recieving_userid = $row['user_id'];
				if($recieving_userid == $creator_id)
				{
					$sql_send_requests = "insert into event_member (user_id, event_id, status, paid) values ($recieving_userid, $last_id, 1, 0)";
				}else
					{
						$sql_send_requests = "insert into event_member (user_id, event_id, status, paid) values ($recieving_userid, $last_id, 0, 0)";
						
					}
				if(mysqli_query($con, $sql_send_requests))
				{
					//echo "Success";
				}
				else{
					//echo "Error while sending event invites";
				}

			}			
		}

	} else {
	//echo "Error: " . $sql . "<br>" . mysqli_error($con);
	
		}
}
else{
	//echo "Error: Sorry, you are not authorized to perform this operation.";
}	


?>


