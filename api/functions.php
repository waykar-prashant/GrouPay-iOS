<?php 

	// This file is the place to store all basic functions

	function mysql_prep( $value ) {
		$magic_quotes_active = get_magic_quotes_gpc();
		$new_enough_php = function_exists( "mysql_real_escape_string" ); // i.e. PHP >= v4.3.0
		if( $new_enough_php ) { // PHP v4.3.0 or higher
			// undo any magic quote effects so mysql_real_escape_string can do the work
			if( $magic_quotes_active ) { $value = stripslashes( $value ); }
			$value = mysql_real_escape_string( $value );
		} else { // before PHP v4.3.0
			// if magic quotes aren't already on then add slashes manually
			if( !$magic_quotes_active ) { $value = addslashes( $value ); }
			// if magic quotes are active, then the slashes already exist
		}
		return $value;
	}

	function redirect_to( $location = NULL ) {
		if ($location != NULL) {
			header("Location: {$location}");
			exit;
		}
	}
	
	function Query($Q)
	{
		$r = mysql_query($Q)
			or die("Database query failed: " . mysql_error());
		return $r;
	}
	
	function QueryLength($r)
	{
		$size = mysql_num_rows($r);
		return $size;	
	}

	function GetArrar($r)
	{
		echo $o = mysql_fetch_array($r, MYSQL_ASSOC);
		return $o;
	}

	function GetObj($r)
	{
		$o = mysql_fetch_object($r);
		return $o;
	}
	
	function Num($r)
	{
		$n = mysql_num_rows($r);
		return $n;
	}

	function Encode( $str )
	{
		return trim( mysql_real_escape_string( htmlentities( $str ) ) );
	}

	function Encrypt($password)
	{
		return crypt(md5($password), md5($password));
	}
		
	function Decode( $str )
	{
		return html_entity_decode( $str );	
	}
	
	//This section should deal with the MagicQuotes and slashes
	function nukeMagicQuotes() 
	{
		if (get_magic_quotes_gpc()) 
		{
			function stripslashes_deep($value) 
			{
				$value = is_array($value) ? array_map('stripslashes_deep', $value) : 	stripslashes($value);
				return $value;
			}
			$_POST = array_map('stripslashes_deep', $_POST);
			$_GET = array_map('stripslashes_deep', $_GET);
			$_COOKIE = array_map('stripslashes_deep', $_COOKIE);
		}
	}
	
	function stripallslashes($string) 
	{ 
	    while(strchr($string,'\\')) 
		{ 
	        $string = stripslashes($string); 
	    } 
		return $string;
	} 
	
	function LastInsertId()
	{
		return mysql_insert_id();
	}


	function checkIfCompanyExists($companyId = NULL){
		if($companyId != NULL){
			$r = Query("select * from company where id = '$companyId' LIMIT 1");
			$len = QueryLength($r);
			if($len > 0)
				return true;
			else
				return false;	
		}else{
			return false;	
		}
	}

	function convertEmployeeToArray($employee){
		/* {employee_id:”1” ,department_id:”” ,pin:””,barcode_id:”” ,
entries  [{status: ”” ,in_time:””,out_time:””,date:” ”}]  },*/
		$status = "";
		$intime = "0000-00-00 00:00:00";
		$outtime = "0000-00-00 00:00:00";
		$emp_id = $employee->id;
		$emp_name = $employee->name;
		
		$emp_dept_id = $employee->department_id;
		$entry_id = $employee->entry_id;
		$pin = $employee->pin;
		$barcode = $employee->barcode_id;
		$companyId = $employee->company_id;
		//Now get the status values from the status flag and entry table.
		$entryObject = getEntryObjectFromUserId($entry_id);
		if($entryObject != NULL){
			$status = $entryObject->status;
			$intime = $entryObject->in_time;
			$outtime = $entryObject->out_time;
		}
			
		if($emp_id != NULL || $emp_id != ""){
			$temp = array();
			$temp[0] = array('status'=>$status, 'in_time'=>$intime, 'out_time'=>$outtime);
			return array('employee_id'=>$emp_id, 'employee_name'=>$emp_name, 'department_id'=>$emp_dept_id, 'pin'=>$pin, 'barcode_id'=>$barcode, 'entries'=>$temp);			
		}
	}
	
	function getAllEmployees($companyId){
		$company_name = "";
		$companyObject = getCompanyObjectFromCompanyId($companyId);		
		if($companyObject != NULL){
			$company_name = $companyObject->name;	
		}

		$r = Query("select * from users where company_id = '$companyId'");
		$employees = array();
		$i = 0;
		while($o = GetObj($r)) {
			$employees[$i] = convertEmployeeToArray($o);
			$i++;
		}
		$finalArray = array('company_id'=>$companyId, 'company_name'=>$company_name ,'employees'=>$employees);
		return $finalArray;
	}
	
	function getEntryObjectFromUserId($entryId = NULL){
		if($entryId != NULL){
			//$r = Query("select * from users, entry where users.id = entry.user_id and users.entry_id = entry.id LIMIT 1");
			$r = Query("select * from entry where id = $entryId LIMIT 1");
			$o = GetObj($r);
			return $o;
		}
	}
	
	function getCompanyObjectFromCompanyId($companyId=NULL){
		if($companyId != NULL){
			$r = Query("select * from company where id = '$companyId'");
			$o = GetObj($r);
			return $o;
		}else{
			return NULL;	
		}
	}
	
	
	function insertStatusInformation($statusInfo){
		
		//Insert the status information in the entries table
		$r = Query( "INSERT INTO entry (user_id, status, in_time) VALUES ('" . $statusInfo['user_id'] . "', '" . $statusInfo['status'] . "', '" . $statusInfo['intime'] . "')" );
		if($r){
			//Update the last insert id in the user table
			$r = Query("UPDATE users SET entry_id ='".Encode(LastInsertId())."' WHERE id = '". Encode($statusInfo['user_id'])."'");
			if($r){
				return true;
			}else{
				return false;	
			}
		}else{
			return false;	
		}
	}
	
	
	function updateStatusInformation($statusInfo){
		//Insert the status information in the entries table

		$uid = $statusInfo['user_id'];
		$r = Query("select * from users where id = $uid LIMIT 1");
		$o = GetObj($r);
		
		if($o != NULL){
			$r = Query("UPDATE entry SET out_time='".Encode($statusInfo['outtime'])."', in_time='".Encode($statusInfo['intime'])."', status='".Encode($statusInfo['status'])."' WHERE id = '". Encode($o->entry_id)."'");
			//echo Num($r);
			if($r){
				return true;	
			}else{
				return false;	
			}
		}else{
			return false;	
		}
	}
	
	function returnCompanyInformation($companyName, $companyId, $errorId){
		
		$arr = array('companyName'=>$companyName, 'companyId'=>$companyId, 'status'=>$errorId);
		print_r(json_encode($arr));
			
	}

	

?>