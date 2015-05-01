<?php
	$fh = fopen('./ffbld', 'r');
	$fname = fread($fh, filesize('./ffbld'));
	fclose($fh);

	$fh = fopen('../../../results/firefox/js/' . $fname . '.txt', 'w');
	fwrite($fh, $_POST['results']);
	fclose($fh);

	echo exec('kill `ps --no-header -C firefox -o pid`');
	exit();
?>