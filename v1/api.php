<?php
include_once('../inc/db_con.inc.php');
include_once('functions.php');

$api = $_GET['api'];
if(isset($api)){
	switch($api){
		case 'register':
			include_once('register.php');
		break;

		case 'login':
			include_once('login.php');
		break;	

		case 'get_current_user':
			include_once('get_current_user.php');
		break;
		
		case 'create_group':
			include_once('create_group.php');
		break;

		case 'get_group_members':
			include_once('get_group_members.php');
		break;

		case 'get_group_info':
			include_once('get_group_info.php');
		break;

		case 'get_user_groups':
			include_once('get_user_groups.php');
		break;

		case 'delete_member':
			include_once('delete_member.php');
		break;

		case 'add_member_to_group':
			include_once('add_member_to_group.php');
		break;

		case 'create_event':
			include_once('create_event.php');
		break;	

		case 'request_group_access':
			include_once('request_group_access.php');
		break;

		case 'send_invite_for_event':
			include_once('send_invite_for_event.php');
		break;	

		case 'send_invite_for_groupay':
			include_once('send_invite_for_groupay.php');
		break;

		case 'invite_to_event_externally':
			include_once('invite_to_event_externally.php');
		break;

		case 'get_events':
			include_once('get_events.php');
		break;

		case 'get_event_details':
			include_once('get_event_details.php');
		break;	

		case 'rsvp_event':
			include_once('rsvp_event.php');
		break;

		case 'pay_for_event':
			include_once('pay_for_event.php');
		break;	

		case 'get_events_for_group':
			include_once('get_events_for_group.php');
		break;	

		case 'get_expenses':
			include_once('get_expenses.php');
		break;

		case 'get_all_users':
			include_once('get_all_users.php');
		break;

		case 'leave_event':
			include_once('leave_event.php');
		break;
		
	}
	
}else{
	echo "INVALID URL";	
}


?>