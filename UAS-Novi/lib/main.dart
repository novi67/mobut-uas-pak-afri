import 'package:flutter/material.dart';
import 'core/session.dart';
import 'pages/login_page.dart';
import 'pages/shell_page.dart';

void main() {
  runApp(const RootApp());
}

class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  bool _loading = true;
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  // ===== CEK SESSION LOGIN =====
  Future<void> _init() async {
    final token = await Session.token();
    setState(() {
      _loggedIn = (token != null && token.isNotEmpty);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ===== LOADING AWAL =====
    if (_loading) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    // ===== SUDAH LOGIN / BELUM =====
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.purple,
      ),
      home: _loggedIn ? const ShellPage() : const LoginPage(),
    );
  }
}
