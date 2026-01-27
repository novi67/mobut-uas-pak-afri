<?php
require_once("../config.php");
require_once("../helpers.php");

/**
 * OPTIONAL AUTH (aktifkan kalau mau hanya user login yang bisa update)
 */
// $token = trim($_REQUEST["token"] ?? "");
// $headers = getallheaders();
// if (isset($headers["Authorization"]) && stripos($headers["Authorization"], "Bearer ") === 0) {
//   $token = trim(substr($headers["Authorization"], 7));
// }
// if ($token === "") json_fail("Token tidak ada", 401);
// $uid = parse_token($token);
// if (!$uid) json_fail("Token tidak valid", 401);

$id = intval($_POST["id"] ?? 0);
$title = trim($_POST["title"] ?? "");
$price = intval($_POST["price"] ?? 0);
$location = trim($_POST["location"] ?? "");
$description = trim($_POST["description"] ?? "");
$image_url = trim($_POST["image_url"] ?? "");

if ($id <= 0) json_fail("ID tidak valid");
if ($title === "" || $location === "") json_fail("Title dan location wajib diisi");

$stmt = $pdo->prepare("SELECT id FROM houses WHERE id=? LIMIT 1");
$stmt->execute([$id]);
$exist = $stmt->fetch();
if (!$exist) json_fail("Data tidak ditemukan", 404);

try {
  $stmt = $pdo->prepare("UPDATE houses SET title=?, price=?, location=?, description=?, image_url=? WHERE id=?");
  $stmt->execute([$title, $price, $location, $description, $image_url, $id]);

  json_ok([], "Berhasil update rumah");
} catch (Exception $e) {
  json_fail("Gagal update rumah");
}
