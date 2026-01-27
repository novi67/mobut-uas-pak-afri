<?php
require_once("../config.php");
require_once("../helpers.php");

/**
 * OPTIONAL AUTH (aktifkan kalau mau hanya user login yang bisa delete)
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
if ($id <= 0) json_fail("ID tidak valid");

$stmt = $pdo->prepare("SELECT id FROM houses WHERE id=? LIMIT 1");
$stmt->execute([$id]);
$exist = $stmt->fetch();
if (!$exist) json_fail("Data tidak ditemukan", 404);

try {
  $stmt = $pdo->prepare("DELETE FROM houses WHERE id=?");
  $stmt->execute([$id]);

  json_ok([], "Berhasil hapus rumah");
} catch (Exception $e) {
  json_fail("Gagal hapus rumah");
}
