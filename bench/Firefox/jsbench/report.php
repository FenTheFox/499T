<?php
	session_start();
	$fh = fopen('../../../results/firefox/js/' . $_SESSION['bld'] . '-' . date('mdHis', time()) . '.txt', 'w');
	fwrite($fh, $_POST['results']);
	fclose($fh);
	
	echo exec('kill `ps --no-header -C firefox -o pid`');
?>