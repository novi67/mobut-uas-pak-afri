<?php
require_once("../config.php");
require_once("../helpers.php");

$id = intval($_GET["id"] ?? 0);
if ($id <= 0) json_fail("ID tidak valid");

$stmt = $pdo->prepare("SELECT * FROM articles WHERE id=?");
$stmt->execute([$id]);
$row = $stmt->fetch();

if (!$row) json_fail("Data tidak ditemukan", 404);
json_ok($row, "Detail artikel");
