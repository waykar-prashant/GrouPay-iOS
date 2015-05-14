<?php 
include_once('../inc/db_con.inc.php');
include_once('functions.php');
$company_id = $_GET['company_id'];
$id = $_GET['id'];
//If id == all then return all the employees
//If id == 1 | 2  then return specific employee details
if(isset($company_id) && intval($company_id)){
	//Check if the company exists in the database
	$exists = checkIfCompanyExists($company_id);
	$json = '';
	
		
	if($exists){
		if(isset($id)){
			if($id == 'all'){
				//Return all the employees details
				echo $json = json_encode(getAllEmployees($company_id));
			}else if(intval($id)){
				//Return Specific employee details
			}
		}
	}
	
}


?>