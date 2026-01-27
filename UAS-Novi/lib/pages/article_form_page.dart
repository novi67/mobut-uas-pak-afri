import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../core/api.dart';

class ArticleFormPage extends StatefulWidget {
  final Map<String, dynamic>? existing;
  const ArticleFormPage({super.key, this.existing});

  @override
  State<ArticleFormPage> createState() => _ArticleFormPageState();
}

class _ArticleFormPageState extends State<ArticleFormPage> {
  final titleC = TextEditingController();
  final bodyC = TextEditingController();
  final imgC = TextEditingController();
  bool saving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      titleC.text = e["title"]?.toString() ?? "";
      bodyC.text = e["body"]?.toString() ?? "";
      imgC.text = e["image_url"]?.toString() ?? "";
    }
  }

  @override
  void dispose() {
    titleC.dispose();
    bodyC.dispose();
    imgC.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (saving) return;
    setState(() => saving = true);

    final isEdit = widget.existing != null;
    final path = isEdit ? "articles/update.php" : "articles/create.php";

    final payload = {
      if (isEdit) "id": widget.existing!["id"].toString(),
      "title": titleC.text.trim(),
      "body": bodyC.text.trim(),
      "image_url": imgC.text.trim(),
    };

    try {
      final res = await Api.dio.post(
        path,
        data: payload,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (!mounted) return;

      final data = res.data;
      final msg = (data is Map && data["message"] != null)
          ? data["message"].toString()
          : (isEdit ? "Berhasil update artikel" : "Berhasil tambah artikel");

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: $e")),
      );
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Artikel" : "Tambah Artikel")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: titleC,
            decoration: const InputDecoration(labelText: "Judul", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: imgC,
            decoration: const InputDecoration(labelText: "Image URL", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: bodyC,
            maxLines: 6,
            decoration: const InputDecoration(labelText: "Isi Artikel", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: saving ? null : submit,
              icon: const Icon(Icons.save),
              label: Text(saving ? "Menyimpan..." : "Simpan"),
            ),
          ),
        ],
      ),
    );
  }
}
