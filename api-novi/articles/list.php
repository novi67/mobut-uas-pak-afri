<?php
require_once("../config.php");
require_once("../helpers.php");

$stmt = $pdo->query("SELECT * FROM articles ORDER BY id DESC");
$data = $stmt->fetchAll();
json_ok($data, "List artikel");
