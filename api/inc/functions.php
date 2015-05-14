<?php 
date_default_timezone_set ("Asia/Calcutta");
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
	
	function getMakeIdFromName($makeName){
		
	}
	
	function getColumnName($rec)
	{
		$num_fields = mysql_num_fields($rec);
$column_names=array();
for($i = 0; $i < $num_fields; $i++ )
{
 //sepatated field name by comma
$column_names[$i]=mysql_field_name($rec,$i);
}
return $column_names;
	}

?>
