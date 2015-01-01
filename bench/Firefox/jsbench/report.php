<?php
	session_start();
	$fh = fopen($_SESSION['bld'] . '-' . date('mdHis', time()) . '.log', 'w');
	fwrite($fh,$_POST['results']);
	fclose($fh);
	
	$fid = fopen('fid','r');
	exec('kill ' . fgets($fid));
	fclose($fid);
?>