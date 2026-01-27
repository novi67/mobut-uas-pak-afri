import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../core/api.dart';

class HouseFormPage extends StatefulWidget {
  final Map<String, dynamic>? existing; // null = create, ada = edit
  const HouseFormPage({super.key, this.existing});

  @override
  State<HouseFormPage> createState() => _HouseFormPageState();
}

class _HouseFormPageState extends State<HouseFormPage> {
  final titleC = TextEditingController();
  final priceC = TextEditingController();
  final locC = TextEditingController();
  final descC = TextEditingController();
  final imgC = TextEditingController();

  bool saving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      titleC.text = e["title"]?.toString() ?? "";
      priceC.text = e["price"]?.toString() ?? "0";
      locC.text = e["location"]?.toString() ?? "";
      descC.text = e["description"]?.toString() ?? "";
      imgC.text = e["image_url"]?.toString() ?? "";
    }
  }

  @override
  void dispose() {
    titleC.dispose();
    priceC.dispose();
    locC.dispose();
    descC.dispose();
    imgC.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (saving) return;
    setState(() => saving = true);

    final isEdit = widget.existing != null;
    final path = isEdit ? "houses/update.php" : "houses/create.php";

    final payload = {
      if (isEdit) "id": widget.existing!["id"].toString(),
      "title": titleC.text.trim(),
      "price": priceC.text.trim(),
      "location": locC.text.trim(),
      "description": descC.text.trim(),
      "image_url": imgC.text.trim(),
    };

    try {
      final res = await Api.dio.post(
        path,
        data: payload,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (!mounted) return;

      // Ambil message kalau ada
      final data = res.data;
      final msg = (data is Map && data["message"] != null)
          ? data["message"].toString()
          : (isEdit ? "Berhasil update rumah" : "Berhasil tambah rumah");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
      Navigator.pop(context, true); // return true biar list refresh
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
      appBar: AppBar(title: Text(isEdit ? "Edit Rumah" : "Tambah Rumah")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: titleC,
            decoration: const InputDecoration(
              labelText: "Judul Rumah",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: priceC,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Harga",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: locC,
            decoration: const InputDecoration(
              labelText: "Lokasi",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: imgC,
            decoration: const InputDecoration(
              labelText: "Image URL",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: descC,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: "Deskripsi",
              border: OutlineInputBorder(),
            ),
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
