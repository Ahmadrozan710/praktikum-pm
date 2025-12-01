import 'dart:async'; // **Import untuk class Timer**, digunakan untuk menunda navigasi.

import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/screen/auth/auth_wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Fungsi untuk menavigasi ke layar selanjutnya
  void _navigateToNextScreen() {
    // Mengganti (pushReplacement) layar saat ini (Splash) dengan AuthWrapper
    // agar user tidak bisa kembali ke Splash Screen.
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          // AuthWrapper akan menentukan apakah user ke Login atau Home.
            builder: (context) => AuthWrapper()
        )
    );
  }

  @override
  // Dipanggil sekali saat objek State dibuat.
  void initState() {
    super.initState();

    // Menggunakan Timer untuk menunda navigasi secara otomatis
    Timer(
      // Durasi penundaan: 2500 milidetik (2.5 detik)
        Duration(milliseconds: 2500),
        // Fungsi yang akan dipanggil setelah durasi berakhir.
        _navigateToNextScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/ornament-top.png'),
            Image.asset('assets/images/logo.png'),
            Image.asset('assets/images/ornament-bottom.png',)
          ],
        )
    );
  }
}