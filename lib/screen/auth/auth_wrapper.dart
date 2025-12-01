import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/screen/auth/login.dart';
import 'package:my_first_flutter_app/screen/navbar.dart';

// AuthWrapper adalah widget stateless yang bertugas menentukan layar selanjutnya
// berdasarkan status autentikasi pengguna (sudah login atau belum).
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan StreamBuilder untuk mendengarkan perubahan status autentikasi dari Firebase.
    return StreamBuilder(
      // Stream: Mengambil stream dari perubahan status autentikasi pengguna (login/logout).
      stream: FirebaseAuth.instance.authStateChanges(),
      // Builder: Dipanggil setiap kali ada data baru di stream.
      builder: (context, snapshot) {
        // 1. Kondisi Loading:
        // Jika koneksi (stream) masih menunggu data awal, tampilkan indikator loading.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // 2. Kondisi Sudah Login:
        // Jika snapshot memiliki data (berarti objek User tidak null), user sudah login.
        if (snapshot.hasData) {
          return Navbar();
        }

        // 3. Kondisi Belum Login:
        // Jika tidak ada data (objek User adalah null), user belum login.
        // Navigasi ke layar Login.
        return LoginScreen();
      },
    );
  }
}