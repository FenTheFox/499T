<?php
	session_start();
	$loadjs    = str_replace("\n", "<br />", file_get_contents($_SESSION['jsload']));
	$loadnojs  = str_replace("\n", "<br />", file_get_contents($_SESSION['nojsload']));
?>

<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8" />
		<title>Firefox Bench Results</title>
	</head>
	<body>
		<h3>Load JS</h3>
		<p><?php echo $loadjs; ?></p>

		<h3>load no JS</h3>
		<p><?php echo $loadnojs; ?></p>
	</body>
</html>