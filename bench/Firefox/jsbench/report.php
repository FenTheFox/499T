<?php
	session_start();
	if($_SESSION['bld'] != null) {
		$fh = fopen('../../../results/firefox/js/' . $_SESSION['bld'] . '.txt', 'w');
		fwrite($fh, $_POST['results']);
		fclose($fh);
	}
	
	echo exec('kill `ps --no-header -C firefox -o pid`');
?>