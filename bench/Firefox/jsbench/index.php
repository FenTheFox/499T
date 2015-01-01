<?php
	if(isset($_GET['fid'])) {
		$fh = fopen('fid','w');
		fwrite($fh, $_GET['fid']);
		fclose($fh);
		exit;
	}
	
	session_start();
	$_SESSION['bld'] = $_GET['bld'];
	header('HTTP/1.1 302 Found', TRUE, 302);
	header('Location: harness.html');
?>