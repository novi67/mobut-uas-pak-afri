<?php
require_once("../config.php");
require_once("../helpers.php");

/**
 * Token bisa dikirim via:
 * - Header: Authorization: Bearer <token>
 * atau
 * - GET/POST: token=<token>
 */

$token = "";

// Ambil dari header Authorization
$headers = getallheaders();
if (isset($headers["Authorization"])) {
  $auth = $headers["Authorization"];
  if (stripos($auth, "Bearer ") === 0) {
    $token = trim(substr($auth, 7));
  }
}

// fallback ambil dari request
if ($token === "") {
  $token = trim($_REQUEST["token"] ?? "");
}

if ($token === "") json_fail("Token tidak ada", 401);

$user_id = parse_token($token);
if (!$user_id) json_fail("Token tidak valid", 401);

$stmt = $pdo->prepare("SELECT id, name, email, created_at FROM users WHERE id=? LIMIT 1");
$stmt->execute([$user_id]);
$user = $stmt->fetch();

if (!$user) json_fail("User tidak ditemukan", 404);

json_ok($user, "Profil user");
