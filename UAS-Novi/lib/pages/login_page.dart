import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../core/api.dart';
import '../core/session.dart';
import 'register_page.dart';
import 'shell_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  Future<void> doLogin() async {
    if (loading) return;

    final email = emailC.text.trim();
    final pass = passC.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email & password wajib diisi")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final res = await Api.dio.post(
        "/auth/login.php",
        data: {"email": email, "password": pass},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      final data = res.data is String ? jsonDecode(res.data) : res.data;

      if (data["success"] == true) {
        final token = data["data"]["token"];
        final user = data["data"]["user"];

        await Session.saveLogin(
          token: data["data"]["token"],
          name: data["data"]["user"]["name"],
          email: data["data"]["user"]["email"],
        );


        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Selamat datang, ${user["name"]}! 👋"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ShellPage()),
        );
      } else {
        _showMessage("Gagal Login", data["message"] ?? "Unknown error");
      }
    } catch (e) {
      _showMessage("Error", "Tidak bisa konek ke server.\n$e");
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void _showMessage(String title, String msg) {
    // ✅ MESSAGE (Dialog)
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ✅ Container
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: const Text(
                "Selamat datang di Katalog Rumah Novi.\nSilakan login untuk melanjutkan.",
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailC,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passC,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : doLogin,
                child: Text(loading ? "Loading..." : "Login"),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                );
              },
              child: const Text("Belum punya akun? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
