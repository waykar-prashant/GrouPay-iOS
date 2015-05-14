<?php
// This page begins the HTML header for the site.

// Start output buffering:
ob_start();

session_start();

function logged_in() {
	return isset($_SESSION['username']);
}

function confirm_logged_in() {
	if (!logged_in()) {
		redirect_to("index.php");
	}
}
?>
