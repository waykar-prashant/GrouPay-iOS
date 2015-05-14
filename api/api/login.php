<?php 
include_once('../inc/db_con.inc.php');
include_once('functions.php');
//username (email id) and the password
if(isset($_GET['submitted'])){ // Form has been submitted.
	$errorstring = " ";
	$Error = 0;
	// perform validations on the form data
	$username = trim(mysql_prep($_GET['username']));
	$password = trim(mysql_prep($_GET['password']));
	
	if(!empty($username)){// Validate the username:
	}
	else{
		$username = FALSE;
		$Error = 1;
		$errorstring .= 'You forgot to enter your username!';
		return returnCompanyInformation("","",$Error);
	}
	
	if(!empty($password)){ // Validate the password:
		
	}
	else{	
		$password = FALSE;
		$Error = 2;
		$errorstring .= 'You forgot to enter your password!';
		return returnCompanyInformation("","",$Error);
	}
	
	if($username && $password)	{// If everything's OK.
		$r = Query("select * from company where email = '".$username."' and password = '".$password. "' LIMIT 1");
		if(Num($r) == 1){
			$o = GetObj($r);
			//$_SESSION = GetArrar($r);
			//$_SESSION['password'] = $password;
			//redirect_to("main.php");
			$Error = 0;
			$errorstring = "";
			return returnCompanyInformation($o->name,$o->id,$Error);
		}else{// No match was made.
		
			$Error = 3;
			$errorstring .= 'Either the username and password entered do not match those in account.';		
			return returnCompanyInformation("","",$Error);	
		}
	}else { // If everything wasn't OK.
		$Error = 4;
		$errorstring .= 'Please try again.';
		return returnCompanyInformation("","",$Error);
	}
	
}

?>