<?php
	session_start();
	$fh = fopen('../../../results/firefox/js/' . $_SESSION['bld'] . '-' . date('mdHis', time()) . '.txt', 'w');
	fwrite($fh,$_POST['results']);
	fclose($fh);
	
	$fid = fopen('fid','r');
	exec('kill ' . fgets($fid));
	fclose($fid);
	unlink('fid');
?>