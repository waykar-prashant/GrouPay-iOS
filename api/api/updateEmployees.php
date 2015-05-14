<?php 
include_once('functions.php');
include_once('../inc/db_con.inc.php');
//Parse Json
echo $json = stripallslashes($_GET['json']);

if(isset($json)){
	$jsonDecode = json_decode($json);
	if($jsonDecode != NULL){
		$company_id = "";
		$company_name = "";
		
		foreach($jsonDecode->employees as $employee){
			$emp_id = "";
			$dept_id = "";
			$pin = "";
			$barcode = "";
			if($employee->employee_id != ""){
				$emp_id = $employee->employee_id;
			}
			if($employee->department_id != ""){
				$dept_id = $employee->department_id;
			}
			if($employee->pin != ""){
				$pin = $employee->pin;
			}
			if($employee->barcode_id != ""){
				$barcode = $employee->barcode_id;
			}
	
			foreach($employee->entries as $entry){
				$status = "";
				$intime = "";
				$outtime = "";
				print_r($entry);
				if($entry->status != ""){
					$status = $entry->status;
				}
				if($entry->in_time != ""){
					$intime = $entry->in_time;
				}
				if($entry->out_time != ""){
					$outtime = $entry->out_time;
				}
				//Insert this imformation in the entries table
				if($status=="1" && $intime!=""){
					//insert the status and the intime of the record
					//Update the record no of the entry table in the users table
					echo insertStatusInformation(array('user_id'=>$emp_id, 'status'=>$status, 'intime'=>$intime, 'outtime'=>$outtime ));
				}else if($status=="0" && $outtime!=""){
					//Update the entrie table out time of the record
					echo updateStatusInformation(array('user_id'=>$emp_id, 'status'=>$status, 'intime'=>$intime, 'outtime'=>$outtime ));	
				}
			}
		}	
	}	
}else{
	echo false;
}

?>