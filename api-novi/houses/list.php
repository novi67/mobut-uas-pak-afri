<?php
require_once("../config.php");
require_once("../helpers.php");

$q = trim($_GET["q"] ?? "");
if ($q !== "") {
  $stmt = $pdo->prepare("SELECT * FROM houses WHERE title LIKE ? OR location LIKE ? ORDER BY id DESC");
  $like = "%$q%";
  $stmt->execute([$like, $like]);
} else {
  $stmt = $pdo->query("SELECT * FROM houses ORDER BY id DESC");
}

$data = $stmt->fetchAll();
json_ok($data, "List rumah");
