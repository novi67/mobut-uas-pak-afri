<?php
require_once("../config.php");
require_once("../helpers.php");

/**
 * Untuk tugas kampus:
 * - Create rumah tidak wajib auth.
 * Kalau mau wajib auth, aktifkan blok token di bawah.
 */

// --- OPTIONAL AUTH ---
// $token = trim($_REQUEST["token"] ?? "");
// $headers = getallheaders();
// if (isset($headers["Authorization"]) && stripos($headers["Authorization"], "Bearer ") === 0) {
//   $token = trim(substr($headers["Authorization"], 7));
// }
// if ($token === "") json_fail("Token tidak ada", 401);
// $uid = parse_token($token);
// if (!$uid) json_fail("Token tidak valid", 401);
// --- END OPTIONAL AUTH ---

$title = trim($_POST["title"] ?? "");
$price = intval($_POST["price"] ?? 0);
$location = trim($_POST["location"] ?? "");
$description = trim($_POST["description"] ?? "");
$image_url = trim($_POST["image_url"] ?? "");

if ($title === "" || $location === "") {
  json_fail("Title dan location wajib diisi");
}

try {
  $stmt = $pdo->prepare("INSERT INTO houses(title, price, location, description, image_url) VALUES(?,?,?,?,?)");
  $stmt->execute([$title, $price, $location, $description, $image_url]);

  json_ok(["id" => $pdo->lastInsertId()], "Berhasil menambah rumah");
} catch (Exception $e) {
  json_fail("Gagal menambah rumah");
}
