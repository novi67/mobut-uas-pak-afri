import 'package:shared_preferences/shared_preferences.dart';

class Session {
  // ===== SIMPAN LOGIN =====
  static Future<void> saveLogin({
    required String token,
    required String name,
    required String email,
  }) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString("token", token);
    await sp.setString("name", name);
    await sp.setString("email", email);
  }

  // ===== AMBIL TOKEN (INI YANG HILANG) =====
  static Future<String?> token() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString("token");
  }

  // ===== AMBIL USER =====
  static Future<Map<String, String>> user() async {
    final sp = await SharedPreferences.getInstance();
    return {
      "name": sp.getString("name") ?? "",
      "email": sp.getString("email") ?? "",
    };
  }

  // ===== CEK SUDAH LOGIN =====
  static Future<bool> isLoggedIn() async {
    final t = await token();
    return t != null && t.isNotEmpty;
  }

  // ===== LOGOUT =====
  static Future<void> clear() async {
    final sp = await SharedPreferences.getInstance();
    await sp.clear();
  }
}
