import 'dart:convert';
import 'package:flutter/material.dart';
import '../core/api.dart';
import '../core/favorites.dart';
import '../widgets/user_badge.dart';


class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  bool loading = true;
  List favHouses = [];
  List favArticles = [];

  Future<void> load() async {
    setState(() => loading = true);

    try {
      final houseIds = await Favorites.getHouseIds();
      final articleIds = await Favorites.getArticleIds();

      final resH = await Api.dio.get("houses/list.php");
      final jsonH = resH.data is String ? jsonDecode(resH.data) : resH.data;
      final houses = (jsonH["data"] ?? []) as List;

      final resA = await Api.dio.get("articles/list.php");
      final jsonA = resA.data is String ? jsonDecode(resA.data) : resA.data;
      final articles = (jsonA["data"] ?? []) as List;

      setState(() {
        favHouses = houses.where((h) => houseIds.contains(int.parse(h["id"].toString()))).toList();
      });
    } catch (e) {
      debugPrint("LOAD FAVORITES ERROR: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat favorit: $e")),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    return RefreshIndicator(
      onRefresh: load,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Text("Favorit Rumah", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...favHouses.map((h) => Card(
            child: ListTile(
              title: Text(h["title"].toString()),
              subtitle: Text(h["location"].toString()),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  (h["image_url"] ?? "").toString().isEmpty
                      ? "https://picsum.photos/seed/favhouse/120/120"
                      : h["image_url"].toString(),
                  width: 56, height: 56, fit: BoxFit.cover,
                ),
              ),
            ),
          )),
          if (favHouses.isEmpty) const Text("Belum ada favorit rumah."),
        ],
      ),
    );
  }
}
