import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/firebase_options.dart';
import 'package:my_first_flutter_app/screen/splash.dart';

// Ubah main menjadi Future karna prosesnya membutuhkan waktu (Asynchronous)
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xff009421),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(),
    );
  }
}