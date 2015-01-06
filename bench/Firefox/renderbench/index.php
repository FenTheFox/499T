<?php
	session_start();

	if(isset($_GET['fid'])) {
		$fh = fopen('fid','w');
		fwrite($fh, $_GET['fid']);
		fclose($fh);
		exit;
	}

	if(!isset($_SESSION['site']) || !isset($_SESSION['itr'])){
		$_SESSION['site'] = 0;
		$_SESSION['itr'] = 0;
		$_SESSION['type'] = 'js';
		$_SESSION['event'] = 'dom';
		
		$time = time();
		$_SESSION['jsdom']		= $_GET['bld'] . '-' . date('mdHis', $time) . '-jsdom.txt';
		$_SESSION['jsload']		= $_GET['bld'] . '-' . date('mdHis', $time) . '-jsload.txt';
		$_SESSION['nojsdom']	= $_GET['bld'] . '-' . date('mdHis', $time) . '-nojsdom.txt';
		$_SESSION['nojsload']	= $_GET['bld'] . '-' . date('mdHis', $time) . '-nojsload.txt';

		fclose(fopen($_SESSION['jsdom'],	'w'));
		fclose(fopen($_SESSION['jsload'],	'w'));
		fclose(fopen($_SESSION['nojsdom'],	'w'));
		fclose(fopen($_SESSION['nojsload'], 'w'));
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