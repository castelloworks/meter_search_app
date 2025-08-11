import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

// Widget utama aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Dashboard',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Skrin permulaan aplikasi
      home: const LoginScreen(),
    );
  }
}
