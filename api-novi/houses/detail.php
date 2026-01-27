<?php
require_once("../config.php");
require_once("../helpers.php");

$id = intval($_GET["id"] ?? 0);
if ($id <= 0) json_fail("ID tidak valid");

$stmt = $pdo->prepare("SELECT * FROM houses WHERE id=?");
$stmt->execute([$id]);
$house = $stmt->fetch();

if (!$house) json_fail("Data tidak ditemukan", 404);
json_ok($house, "Detail rumah");
