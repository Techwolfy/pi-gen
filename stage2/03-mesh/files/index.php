<html>

<head>
	<title>Self-Sustaining Mesh Network</title>
	<style>
		body {
			background-color: #222222;
			color: #DDDDDD;
		}
		table {
			border-collapse: collapse;
			margin-top: 4px;
		}
		table, th, td {
			border: 1px solid #DDDDDD;
			padding: 4px;
		}
	</style>
</head>

<body>
<?php
	$datadir = "/var/lib/mesh";

	print("<h2>You are connected to: <b>" . $_SERVER["SERVER_ADDR"] . "</b></h2><p>\n");

	$nodes = array_diff(scandir($datadir), array(".", ".."));

	foreach($nodes as $nodefile) {
		$node = file_get_contents($datadir . "/" . $nodefile);
		$data = json_decode($node, true);
		$lastseen = time() - $data["time"];
		print("Node <b>" . $nodefile . "</b> (last seen " . $lastseen . "s ago):<br>\n");

		print("<table style=\"border: \"><tr>\n");
		for($i = 0; $i < count($data["gpio"]); $i++) {
			print("\t<td>" . "GPIO " . $i . "</td>\n");
		}
		print("</tr>\n<tr>\n");
		foreach($data["gpio"] as $gpio) {
			print("\t<td>" . $gpio . "</td>\n");
		}
		print("</tr></table><p>\n");
	}
?>
</body>

</html>
