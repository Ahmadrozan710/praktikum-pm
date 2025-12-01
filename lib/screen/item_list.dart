import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/services/firestore_service.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  // 1. Panggil Service yang sudah kita buat untuk akses ke Firestore
  final FirestoreService _firestoreService = FirestoreService();

  // 2. Siapkan Controller untuk menangkap input teks dari user
  // Controller ini ibarat "wadah" penampung ketikan user
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pointController = TextEditingController();


  // ====================================================================
  // LOGIKA CREATE (Menambah Data)
  // ====================================================================
  void _showDialog() {
    // PENTING: Reset/Bersihkan isi form setiap kali dialog dibuka.
    // Jika tidak di-clear, tulisan lama akan tetap muncul saat user membuka dialog lagi.
    _nameController.clear();
    _pointController.clear();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Tambah Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Agar dialog tidak memanjang ke bawah
            children: [
              TextField(
                controller: _nameController, // Hubungkan TextField dengan controller
                decoration: InputDecoration(
                    labelText: 'Nama Item'
                ),
              ),
              TextField(
                controller: _pointController, // Hubungkan TextField dengan controller
                decoration: InputDecoration(
                    labelText: 'Poin Item'
                ),
                keyboardType: TextInputType.number, // Keyboard angka
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Tutup dialog
              child: Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                // 1. Ambil nilai dari controller
                final String name = _nameController.text;

                // 2. Konversi Poin ke Integer dengan aman (gunakan tryParse)
                // Jika user input huruf/kosong, nilai default jadi 0
                final int point = int.tryParse(_pointController.text) ?? 0;

                // 3. Validasi sederhana: Nama tidak boleh kosong
                if (name.isNotEmpty) {
                  // Panggil fungsi CREATE dari Service
                  _firestoreService.addItem(name, point);

                  // Tutup dialog setelah simpan
                  Navigator.pop(context);
                }
              },
              child: Text("Simpan"),
            )
          ],
        )
    );
  }

  // Lifecycle Method: Dipanggil saat halaman dihancurkan/ditutup
  @override
  void dispose() {
    // Wajib: Hapus controller dari memori untuk mencegah Memory Leak
    _nameController.dispose();
    _pointController.dispose();

    super.dispose();
  }

  // ====================================================================
  // LOGIKA READ (Menampilkan Data)
  // ====================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Daftar Item'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),

        // Tombol Tambah (+) memanggil fungsi _showDialog
        floatingActionButton: FloatingActionButton(
          onPressed: _showDialog,
          backgroundColor: Colors.green,
          child: Icon(Icons.add, color: Colors.white,),
        ),

        // StreamBuilder: Jantung dari fitur Real-time
        // Widget ini akan "mendengarkan" perubahan data dari FirestoreService
        body: StreamBuilder<List<Item>>(
          stream: _firestoreService.getItems(), // Sumber datanya (Stream)
          builder: (context, snapshot) {
            // Kondisi 1: Sedang memuat data (Waiting)
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator()
              );
            }

            // Kondisi 2: Terjadi Error saat mengambil data
            if (snapshot.hasError) {
              return Center(
                  child: Text('Terjadi kesalahan: ${snapshot.error}')
              );
            }

            // Ambil data List<Item> dari snapshot
            final List<Item> items = snapshot.data ?? [];

            // Kondisi 3: Data berhasil diambil tapi kosong
            if (items.isEmpty) {
              return Center(
                  child: Text('Tidak ada item yang dapat ditampilkan!')
              );
            }

            // Kondisi 4: Data ada, tampilkan menggunakan ListView
            return  ListView.builder(
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
                        )
                    ),
                    subtitle: Text(
                        item.id
                    ),
                    trailing: Text(
                      '${item.point} Poin',
                      style: TextStyle(
                          color: Colors.green[700],
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                );
              },
            );
          },
        )
    );
  }
}