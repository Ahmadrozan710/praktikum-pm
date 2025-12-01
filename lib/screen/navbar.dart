import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/screen/beranda.dart';
import 'package:my_first_flutter_app/screen/jelajahi.dart';
import 'package:my_first_flutter_app/screen/profile.dart';
import 'package:my_first_flutter_app/screen/tugas.dart';
import 'package:permission_handler/permission_handler.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    BerandaScreen(),
    JelajahiScreen(),
    TugasScreen(),
    ProfileScreen()
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: () async {
            var status = await Permission.camera.request();

            if (status.isGranted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Kamera berhasil diberikan akses!"))
              );
            } else if (status.isDenied) {
              await Permission.camera.request();
            } else if (status.isPermanentlyDenied) {
              openAppSettings();
            }
          },
          shape: CircleBorder(),
          backgroundColor: Colors.yellow,
          tooltip: "E-Scan",
          child: Icon(Icons.qr_code_scanner, size: 45,),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 7,
        color: Colors.white,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Navbar Kiri
              Row(
                children: [
                  _buildNavItem("Beranda", Icons.home_outlined, 0),
                  _buildNavItem("Jelajahi", Icons.travel_explore_outlined, 1),
                ],
              ),

              // Navbar Kanan
              Row(
                children: [
                  _buildNavItem("Tugas", Icons.assignment, 2),
                  _buildNavItem("Profile", Icons.person, 3),
                ],
              ),
            ]
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
    );
  }

  Widget _buildNavItem(String title, IconData icon, int index) {
    final isActive = _selectedIndex == index;
    final color = isActive ? Colors.green : Colors.black;

    return MaterialButton(
      minWidth: 40,
      onPressed: () => _onTabTapped(index),
      child: Column(
          children: [
            Icon(icon, size: 30, color: color,),
            Text(title,
              style: TextStyle(
                fontSize: 15,
                color: color
              ),
            )
          ]
      ),
    );
  }
}