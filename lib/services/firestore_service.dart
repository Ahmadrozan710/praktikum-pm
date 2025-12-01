import 'package:cloud_firestore/cloud_firestore.dart';

// Kita buat Model objek untuk data dari Firestore
class Item {
  final String id;
  final String name;
  final int point;

  // Constructor
  Item({
    required this.id,
    required this.name,
    required this.point
  });

  // Factory constructor untuk mengkonversi DocumentSnapshot menjadi objek Item
  factory Item.fromFirestore(DocumentSnapshot doc) {
    // Ambil data dari dokumen, pastikan tipe datanya benar
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw StateError('Data dokumen kosong!');
    }

    return Item(
        id: doc.id,
        name: data['name'] as String? ?? "No Name",
        point: (data['point'] as num?)?.toInt() ?? 0
    );
  }
}

class FirestoreService {
  // Instance Firestore
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ====================================================================
  // Method READ (Real-time Stream)
  // ====================================================================
  // Ini akan mengembalikan Stream of List<Item>
  // Setiap kali data di Firestore berubah, Stream akan otomatis mengirimkan data baru.
  Stream<List<Item>> getItems() {
    // 1. Akses koleksi 'user_items'
    return _db.collection('user_items')
    // 2. Fungsi ajaib untuk mengambil data secara real-time
        .snapshots()
    // 3. Konversi snapshot menjadi List<Item>
        .map((snapshots) =>
        snapshots.docs.map((doc) => Item.fromFirestore(doc)).toList()
    );
  }

  // ====================================================================
  // Method CREATE (Menambah Data)
  // ====================================================================
  // Menggunakan Future karena operasi ini butuh waktu (Asynchronous).
  // Kita tidak perlu membuat ID manual, Firestore akan membuatnya otomatis.
  Future<DocumentReference<Map<String, dynamic>>> addItem(String name, int point) {
    // 1. Akses koleksi 'user_items'
    return _db.collection('user_items')
    // 2. Panggil fungsi .add() untuk menambahkan dokumen baru
    // Firestore akan otomatis meng-generate Random ID yang unik.
        .add({
      'name': name,
      'point': point
    });
  }
}