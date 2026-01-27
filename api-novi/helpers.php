<?php

function json_ok($data = [], $message = "OK") {
  echo json_encode(["success" => true, "message" => $message, "data" => $data]);
  exit;
}

function json_fail($message = "Failed", $code = 400) {
  http_response_code($code);
  echo json_encode(["success" => false, "message" => $message]);
  exit;
}

/**
 * Token sederhana (untuk tugas kuliah OK).
 * Untuk produksi, pakai JWT yang benar.
 */
function make_token($user_id) {
  return base64_encode("uid:$user_id|" . time());
}

function parse_token($token) {
  $decoded = base64_decode($token);
  if (!$decoded) return null;
  if (!str_starts_with($decoded, "uid:")) return null;
  $parts = explode("|", $decoded);
  $uidPart = $parts[0]; // uid:123
  $uid = intval(str_replace("uid:", "", $uidPart));
  return $uid > 0 ? $uid : null;
}
