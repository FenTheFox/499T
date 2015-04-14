<?php
	session_start();
	$loadjs    = str_replace("\n", "<br />", file_get_contents($_SESSION['js']));
	$loadnojs  = str_replace("\n", "<br />", file_get_contents($_SESSION['nojs']));
?>

<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8" />
		<title>Firefox Bench Results</title>
	</head>
	<body>
		<h3>JS</h3>
		<p><?php echo $loadjs; ?></p>

		<h3>no JS</h3>
		<p><?php echo $loadnojs; ?></p>
	</body>
</html>