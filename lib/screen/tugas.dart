import 'package:flutter/material.dart';

  class TugasScreen extends StatelessWidget {
  const TugasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Text(
          "Ini Halaman Tugas",
          style: TextStyle(
              color: Colors.white,
              fontSize: 25
          ),
        ),
      ),
    );
  }
}