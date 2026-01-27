<?php
require_once("../config.php");
require_once("../helpers.php");

$email = trim($_POST["email"] ?? "");
$password = trim($_POST["password"] ?? "");

if ($email === "" || $password === "") {
  json_fail("Email dan password wajib diisi");
}

$stmt = $pdo->prepare("SELECT id, name, email, password_hash FROM users WHERE email=? LIMIT 1");
$stmt->execute([$email]);
$user = $stmt->fetch();

if (!$user) json_fail("Akun tidak ditemukan", 401);

if (!password_verify($password, $user["password_hash"])) {
  json_fail("Password salah", 401);
}

$token = make_token($user["id"]);
json_ok([
  "token" => $token,
  "user" => ["id" => $user["id"], "name" => $user["name"], "email" => $user["email"]]
], "Login berhasil");
