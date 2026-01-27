<?php
require_once("../config.php");
require_once("../helpers.php");

$id = intval($_POST["id"] ?? 0);
if ($id <= 0) json_fail("ID tidak valid");

$stmt = $pdo->prepare("DELETE FROM articles WHERE id=?");
$stmt->execute([$id]);

json_ok([], "Artikel berhasil dihapus");
