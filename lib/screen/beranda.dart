import 'package:flutter/material.dart';

class BerandaScreen extends StatelessWidget {
  const BerandaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Text(
          "Ini Halaman Beranda",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25
          ),
        ),
      ),
    );
  }
}