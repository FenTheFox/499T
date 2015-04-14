<?php
	session_start();

	if(!isset($_SESSION['site']) || !isset($_SESSION['itr'])){
		$_SESSION['site'] = 0;
		$_SESSION['itr'] = 0;
		$_SESSION['type'] = 'js';

		if ($_GET['bld'] != null) {
			$_SESSION['js']		= $_GET['bld'] . '-js.txt';
			$_SESSION['nojs']	= $_GET['bld'] . '-nojs.txt';
			$_SESSION['dologging']	= TRUE;
		}

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
	}
?>