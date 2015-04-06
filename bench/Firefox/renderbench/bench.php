<?php
	session_start();

	if ($_SESSION['dologging'] === TRUE) {
		$logf = '../../../results/firefox/render/' . $_SESSION[$_SESSION['type'] . $_SESSION['event']];
		$fh = fopen( $logf, 'a' );
		fwrite( $fh, $_SESSION['sitename'] . ': ' . ($_SERVER['REQUEST_TIME_FLOAT'] - $_POST['time']) . "\n" );
		fclose( $fh );
	}

	if(++$_SESSION['site'] == 21){
		$_SESSION['site'] = 0;
		if(++$_SESSION['itr'] == 7){
			$_SESSION['itr'] = 0;
			if($_SESSION['type'] == 'js') {
				$_SESSION['type'] = 'nojs';
			} else {				
				exec('kill `ps --no-header -C firefox -o pid`');
				
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