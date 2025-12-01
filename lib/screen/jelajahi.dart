import 'package:flutter/material.dart';

class JelajahiScreen extends StatelessWidget {
  const JelajahiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Text(
          "Ini Halaman Jelajahi",
          style: TextStyle(
              color: Colors.white,
              fontSize: 25
          ),
        ),
      ),
    );
  }
}