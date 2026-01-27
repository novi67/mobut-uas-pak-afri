import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "Tentang Aplikasi",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
          child: const Text(
            "Aplikasi Katalog Rumah Novi dibuat menggunakan Flutter dan terhubung ke API PHP + MySQL.\n"
                "Aplikasi ini menyediakan fitur Login/Register, Katalog Rumah, Artikel, Favorit, dan Pengelolaan Data (CRUD).",
          ),
        ),

        const SizedBox(height: 16),

        // Image network (aman)
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            "https://picsum.photos/seed/about/900/400",
            height: 180,
            fit: BoxFit.cover,
          ),
        ),

        const SizedBox(height: 16),
        const Text("Fitur Utama", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const ListTile(leading: Icon(Icons.home_work), title: Text("Katalog Rumah (List & Detail)")),
        const ListTile(leading: Icon(Icons.article), title: Text("Artikel (List) + CRUD")),
        const ListTile(leading: Icon(Icons.favorite), title: Text("Favorit tersimpan (SharedPreferences)")),
        const ListTile(leading: Icon(Icons.lock), title: Text("Login & Register")),
        const ListTile(leading: Icon(Icons.storage), title: Text("Database MySQL & API PHP")),

        const Divider(height: 28),
        const Text("Versi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        const Text("v1.0.0"),
      ],
    );
  }
}
