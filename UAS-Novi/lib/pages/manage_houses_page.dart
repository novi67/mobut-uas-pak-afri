import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../core/api.dart';
import 'house_form_page.dart';

class ManageHousesPage extends StatefulWidget {
  const ManageHousesPage({super.key});

  @override
  State<ManageHousesPage> createState() => _ManageHousesPageState();
}

class _ManageHousesPageState extends State<ManageHousesPage> {
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
      final res = await Api.dio.get("houses/list.php");
      final data = res.data;

      final json = data is String ? jsonDecode(data) : data;

      setState(() {
        this.data = (json["data"] ?? []) as List;
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

  Future<void> deleteHouse(int id) async {
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
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text("Kelola Rumah (CRUD)")),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (_, i) {
          final h = data[i];
          return ListTile(
            title: Text(h["title"].toString()),
            subtitle: Text(h["location"].toString()),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => HouseFormPage(existing: h)),
                    );
                    fetch();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => deleteHouse(int.parse(h["id"].toString())),
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
            MaterialPageRoute(builder: (_) => const HouseFormPage()),
          );
          fetch();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
