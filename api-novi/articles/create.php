<?php
require_once("../config.php");
require_once("../helpers.php");

$title = trim($_POST["title"] ?? "");
$body  = trim($_POST["body"] ?? "");
$image_url = trim($_POST["image_url"] ?? "");

if ($title === "" || $body === "") json_fail("Title dan body wajib diisi");

$stmt = $pdo->prepare("INSERT INTO articles(title, body, image_url) VALUES(?,?,?)");
$stmt->execute([$title, $body, $image_url]);

json_ok(["id" => $pdo->lastInsertId()], "Artikel berhasil ditambahkan");
