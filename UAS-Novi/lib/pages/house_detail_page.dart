import 'dart:convert';
import 'package:flutter/material.dart';
import '../core/api.dart';

class HouseDetailPage extends StatefulWidget {
  final String id;
  const HouseDetailPage({super.key, required this.id});

  @override
  State<HouseDetailPage> createState() => _HouseDetailPageState();
}

class _HouseDetailPageState extends State<HouseDetailPage> {
  Map<String, dynamic>? house;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    setState(() => loading = true);
    try {
      final res = await Api.dio.get("/houses/detail.php", queryParameters: {"id": widget.id});
      final data = res.data is String ? jsonDecode(res.data) : res.data;
      setState(() => house = data["data"] as Map<String, dynamic>?);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memuat detail rumah")),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (house == null) return const Scaffold(body: Center(child: Text("Data tidak ditemukan")));

    final img = (house!["image_url"] ?? "").toString();
    final title = (house!["title"] ?? "").toString();
    final loc = (house!["location"] ?? "").toString();
    final desc = (house!["description"] ?? "").toString();

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Rumah")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              img.isEmpty ? "https://picsum.photos/seed/houseDetail/900/600" : img,
              height: 220,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text("Lokasi: $loc"),
          const SizedBox(height: 10),
          Text(desc.isEmpty ? "Tidak ada deskripsi." : desc),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: () {
              // ✅ Message (dialog)
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Kontak Agen"),
                  content: const Text("Silakan hubungi admin untuk info lebih lanjut."),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text("Tutup")),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.phone),
            label: const Text("Hubungi Agen"),
          )
        ],
      ),
    );
  }
}
