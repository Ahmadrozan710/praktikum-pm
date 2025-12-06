import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/services/firestore_service.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  final _firestoreService = FirestoreService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pointController = TextEditingController();

  // ---- LETAK PERUBAHAN ---- //
  void _showDialog({ Item? item }) {
    if (item != null) {
      _nameController.text = item.name;
      _pointController.text = item.point.toString();
    } else {
      _nameController.clear();
      _pointController.clear();
    }

    // ---- LETAK PERUBAHAN ---- //
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(item == null ? "Tambah Item" : "Edit Item"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nama Item"),
              ),
              TextField(
                controller: _pointController,
                decoration: const InputDecoration(labelText: "Poin Item"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text;
                final point = int.tryParse(_pointController.text) ?? 0;

                // ---- LETAK PERUBAHAN ---- //
                if (name.isNotEmpty) {
                  if (item == null) {
                    _firestoreService.addItem(name, point);
                  } else {
                    _firestoreService.updateItem(item.id, name, point);
                  }

                  Navigator.pop(context);
                }
              },
              child: Text(item == null ? "Simpan" : "Update"),
            ),
          ],
        )
    );
  }

  // ---- PENAMBAHAN FUNGSI BARU UNTUK MENAMPILKAN MODAL KONFIRMASI SEBELUM DELETE  ---- //
  void _showDeleteConfirmation(String id, String name) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Hapus Item?"),
          content: Text("Apakah Anda yakin ingin menghapus item '$name'? Data tidak akan bisa dikembalikan."),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal")
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  _firestoreService.deleteItem(id);

                  Navigator.pop(context);
                },
                child: const Text(
                  "Hapus",
                  style: TextStyle(
                      color: Colors.white
                  ),
                )
            )
          ],
        )
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pointController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Item (READ)"),
        backgroundColor: const Color(0xff009421),
        foregroundColor: Colors.white,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        backgroundColor: const Color(0xff009421),
        child: const Icon(Icons.add, color: Colors.white,),
      ),

      body: StreamBuilder<List<Item>>(
        stream: _firestoreService.getItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          final List<Item> items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(
              child: Text("Tidak ada item yang ditemukan."),
            );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final Item item = items[index];

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(
                    item.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // ---- LETAK PERUBAHAN ---- //
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${item.point} Poin',
                        style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      const SizedBox(width: 8,),
                      // ---- TOMBOL IKON DELETE UNTUK DELETE ---- //
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red,),
                        onPressed: () => _showDeleteConfirmation(item.id, item.name),
                      )
                    ],
                  ),
                  // ---- MENAMBAHKAN PARAMETER onTap AGAR SETIAP CARD DAPAT DIKLIK ---- //
                  onTap: () => _showDialog(item: item),
                ),
              );
            },
          );
        },
      ),
    );
  }
}