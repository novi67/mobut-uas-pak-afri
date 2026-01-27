import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../core/api.dart';
import 'article_form_page.dart';

class ManageArticlesPage extends StatefulWidget {
  const ManageArticlesPage({super.key});

  @override
  State<ManageArticlesPage> createState() => _ManageArticlesPageState();
}

class _ManageArticlesPageState extends State<ManageArticlesPage> {
  List data = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    setState(() => loading = true);

    try {
      final res = await Api.dio.get("articles/list.php");
      final data = res.data;

      final json = data is String ? jsonDecode(data) : data;

      setState(() {
        this.data = (json["data"] ?? []) as List;
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

  Future<void> deleteArticle(int id) async {
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
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text("Kelola Artikel (CRUD)")),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (_, i) {
          final a = data[i];
          return ListTile(
            title: Text(a["title"].toString()),
            subtitle: Text((a["body"] ?? "").toString()),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ArticleFormPage(existing: a)),
                    );
                    fetch();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => deleteArticle(int.parse(a["id"].toString())),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ArticleFormPage()),
          );
          fetch();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
