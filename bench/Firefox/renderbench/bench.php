<?php
	session_start();

	$logf = '../../../results/firefox/render/' . $_SESSION[$_SESSION['type'] . $_SESSION['event']];
	$fh = fopen( $logf, 'a' );
	fwrite( $fh, $_SESSION['sitename'] . ': ' . ($_SERVER['REQUEST_TIME_FLOAT'] - $_POST['time']) . "\n" );
	fclose( $fh );

	if(++$_SESSION['site'] == 21){
		$_SESSION['site'] = 0;
		if(++$_SESSION['itr'] == 3){
			$_SESSION['itr'] = 0;
			if($_SESSION['type'] == 'js') {
				$_SESSION['type'] = 'nojs';
			} elseif ($_SESSION['event'] == 'dom') {
				$_SESSION['type'] = 'js';
				$_SESSION['event'] = 'load';
			} else {				
				$fid = fopen('fid', 'r');
				exec('kill ' . fgets($fid));
				fclose($fid);
				unlink('fid');
				
				unset($_SESSION['site']);
				header('HTTP/1.1 302 Found', TRUE, 302);
				header('Location: report.php');
				exit;
			}
		}
	}

	header('HTTP/1.1 302 Found', TRUE, 302);
	header('Location: index.php');
	exit;
?>