<?php
require_once("../config.php");
require_once("../helpers.php");

$name = trim($_POST["name"] ?? "");
$email = trim($_POST["email"] ?? "");
$password = trim($_POST["password"] ?? "");

if ($name === "" || $email === "" || $password === "") {
  json_fail("Semua field wajib diisi");
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
  json_fail("Email tidak valid");
}

$hash = password_hash($password, PASSWORD_BCRYPT);

try {
  $stmt = $pdo->prepare("INSERT INTO users(name, email, password_hash) VALUES(?,?,?)");
  $stmt->execute([$name, $email, $hash]);
  json_ok([], "Register berhasil");
} catch (Exception $e) {
  json_fail("Email sudah terdaftar atau error", 409);
}
