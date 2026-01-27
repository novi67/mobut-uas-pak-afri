import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../core/api.dart';
import '../core/favorites.dart';
import 'house_form_page.dart';
import '../widgets/user_badge.dart';


class HomeHousesPage extends StatefulWidget {
  const HomeHousesPage({super.key});

  @override
  State<HomeHousesPage> createState() => _HomeHousesPageState();
}

class _HomeHousesPageState extends State<HomeHousesPage> {
  bool loading = true;
  List houses = [];

  Set<int> favIds = {};

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    setState(() => loading = true);
    try {
      favIds = await Favorites.getHouseIds();

      final res = await Api.dio.get("houses/list.php");
      final raw = res.data;
      final json = raw is String ? jsonDecode(raw) : raw;

      setState(() {
        houses = (json["data"] ?? []) as List;
      });
    } catch (e) {
      debugPrint("FETCH HOUSES ERROR: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat rumah: $e")),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _toggleFav(int id) async {
    await Favorites.toggleHouse(id);
    favIds = await Favorites.getHouseIds();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Favorit diperbarui")),
    );
    setState(() {});
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Hapus rumah ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteHouse(id);
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteHouse(int id) async {
    try {
      await Api.dio.post(
        "houses/delete.php",
        data: {"id": id},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Berhasil hapus rumah")),
      );
      fetch();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal hapus: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Katalog Rumah"),
        actions: const [UserBadge()], // ✅ pojok kanan atas
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: fetch,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: houses.length,
          itemBuilder: (_, i) {
            final h = houses[i] as Map<String, dynamic>;
            final id = int.parse(h["id"].toString());
            final isFav = favIds.contains(id);

            final img = (h["image_url"] ?? "").toString().isEmpty
                ? "https://picsum.photos/seed/house$id/600/400"
                : h["image_url"].toString();

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                    child: Image.network(img, height: 170, width: double.infinity, fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                h["title"].toString(),
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(h["location"].toString()),
                              const SizedBox(height: 6),
                              Text("Rp ${h["price"]}"),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                          onPressed: () => _toggleFav(id),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final ok = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => HouseFormPage(existing: h)),
                            );
                            if (ok == true) fetch();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _confirmDelete(id),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final ok = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HouseFormPage()),
          );
          if (ok == true) fetch();
        },
        icon: const Icon(Icons.add),
        label: const Text("Tambah"),
      ),
    );
  }
}
