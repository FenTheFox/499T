<?php
	session_start();

	if(!isset($_SESSION['site']) || !isset($_SESSION['itr'])){
		$_SESSION['site'] = 0;
		$_SESSION['itr'] = 0;
		$_SESSION['type'] = 'js';
		$_SESSION['event'] = 'load';
		
		$time = time();
		$_SESSION['jsload']		= $_GET['bld'] . '-jsload.txt';
		$_SESSION['nojsload']	= $_GET['bld'] . '-nojsload.txt';
	}

	if($handle = opendir($_SESSION['type'])) {
		$i = 0;
		while(FALSE != ($entry = readdir($handle))) {
			if($entry[0] != '.' && $i++ == $_SESSION['site']) {
				$_SESSION['sitename'] = $entry;
				header('HTTP/1.1 303 See Other', TRUE, 303);
				header('Location: ' . $_SESSION['type'] . "/$entry/index.php");
				exit;
			}
		}
		echo $i;
	}
?>