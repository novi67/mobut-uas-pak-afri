import 'package:flutter/material.dart';
import '../core/session.dart';
import 'login_page.dart';
import 'manage_houses_page.dart';
import 'manage_articles_page.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "-";
  String email = "-";

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final u = await Session.user();
    setState(() {
      name = u["name"] ?? "-";
      email = u["email"] ?? "-";
    });
  }

  Future<void> logout() async {
    await Session.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(email),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ✅ TOMBOL KELOLA RUMAH
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.home_work),
              label: const Text("Kelola Rumah (CRUD)"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ManageHousesPage(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // ✅ TOMBOL KELOLA ARTIKEL
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.article),
              label: const Text("Kelola Artikel (CRUD)"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ManageArticlesPage(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // ✅ TOMBOL LOGOUT (tetap di bawah)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: logout,
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
