import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../core/api.dart';
import '../core/favorites.dart';
import 'article_form_page.dart';
import '../widgets/user_badge.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  bool loading = true;
  List articles = [];
  Set<int> favIds = {};

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    setState(() => loading = true);

    try {
      favIds = await Favorites.getArticleIds();

      final res = await Api.dio.get("articles/list.php");
      final raw = res.data;
      final json = raw is String ? jsonDecode(raw) : raw;

      setState(() {
        articles = (json["data"] ?? []) as List;
      });
    } catch (e) {
      debugPrint("FETCH ARTICLES ERROR: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat artikel: $e")),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _toggleFav(int id) async {
    await Favorites.toggleArticle(id);
    favIds = await Favorites.getArticleIds();
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
        content: const Text("Hapus artikel ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteArticle(id);
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteArticle(int id) async {
    try {
      await Api.dio.post(
        "articles/delete.php",
        data: {"id": id},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Berhasil hapus artikel")),
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
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: fetch,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: articles.length,
          itemBuilder: (_, i) {
            final a = articles[i] as Map<String, dynamic>;
            final id = int.parse(a["id"].toString());
            final isFav = favIds.contains(id);

            final img = (a["image_url"] ?? "").toString().isEmpty
                ? "https://picsum.photos/seed/article$id/800/400"
                : a["image_url"].toString();

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: InkWell(
                onTap: () async {
                  final ok = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ArticleFormPage(existing: a)),
                  );
                  if (ok == true) fetch();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                      child: Image.network(img, height: 160, width: double.infinity, fit: BoxFit.cover),
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
                                  a["title"].toString(),
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  (a["body"] ?? "").toString(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                            onPressed: () => _toggleFav(id),
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
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final ok = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ArticleFormPage()),
          );
          if (ok == true) fetch();
        },
        icon: const Icon(Icons.add),
        label: const Text("Tambah"),
      ),
    );
  }
}
