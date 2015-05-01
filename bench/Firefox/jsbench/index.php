<?php
	$fh = fopen('./ffbld', 'w');
	fwrite($fh, $_GET['bld']);
	fclose($fh);
	exit();
?>