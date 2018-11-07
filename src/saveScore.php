<?php
	$username = $_POST['username'];
	$score = $_POST['score'];

	$connect = mysql_connect("localhost","","");
	mysql_select_db("hallaby_daxpy");

	$username = mysql_real_escape_string($username);

	if($username) {
		$insert = "INSERT INTO high_scores(username,score,score_date) VALUES ('$username',$score,NOW())";
		$insertquery = mysql_query($insert, $connect);
	}

	mysql_close();
?>