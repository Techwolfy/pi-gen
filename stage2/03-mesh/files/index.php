<?php
	$datadir = "/var/lib/mesh";

	echo "You are connected to: " . $_SERVER["SERVER_ADDR"] . "<p>\n";

	$nodes = array_diff(scandir($datadir), array(".", ".."));

	foreach($nodes as $nodefile) {
		$node = file_get_contents($datadir . "/" . $nodefile);
		$data = json_decode($node, true);
		$lastseen = time() - $data["time"];
		print($nodefile . " (last seen " . $lastseen . "s ago):<br>\n");
		print_r($data);
		print("<p>\n");
	}
?>
