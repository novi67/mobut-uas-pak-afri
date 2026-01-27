<?php
require_once("../config.php");
require_once("../helpers.php");

$id = intval($_POST["id"] ?? 0);
$title = trim($_POST["title"] ?? "");
$body  = trim($_POST["body"] ?? "");
$image_url = trim($_POST["image_url"] ?? "");

if ($id <= 0) json_fail("ID tidak valid");
if ($title === "" || $body === "") json_fail("Title dan body wajib diisi");

$stmt = $pdo->prepare("UPDATE articles SET title=?, body=?, image_url=? WHERE id=?");
$stmt->execute([$title, $body, $image_url, $id]);

json_ok([], "Artikel berhasil diupdate");
