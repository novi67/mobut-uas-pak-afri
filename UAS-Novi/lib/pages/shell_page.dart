import 'package:flutter/material.dart';

import 'home_houses_page.dart';
import 'articles_page.dart';
import 'favorites_page.dart';
import 'about_page.dart';
import 'profile_page.dart';

import '../widgets/user_badge.dart';

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int index = 0;

  final pages = const [
    HomeHousesPage(),
    ArticlesPage(),
    FavoritesPage(),
    AboutPage(),
    ProfilePage(),
  ];

  final titles = const [
    "Katalog Rumah",
    "Artikel",
    "Favorit",
    "About",
    "Profil",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ APPBAR GLOBAL (SEMUA PAGE)
      appBar: AppBar(
        title: Text(titles[index]),
        actions: const [
          UserBadge(), // 👈 USER LOGIN DARI SHARED PREFERENCES
        ],
      ),

      body: pages[index],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Rumah"),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: "Artikel"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorit"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "About"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}
