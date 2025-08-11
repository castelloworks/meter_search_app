import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'admin_dashboard.dart';
import 'rider_dashboard.dart';

// Definisi warna dari tema yang diminta
const Color primaryColor = Color(0xFF33539E);
const Color accentColor1 = Color(0xFF77FAAC);
const Color accentColor2 = Color(0xFFBFB8DA);
const Color accentColor3 = Color(0xFFE8B7D4);
const Color secondaryColor = Color(0xFFA5678E);

// Skrin login, ini adalah StatefulWidget kerana ia perlu menguruskan state (input dari user)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  // Logik untuk mengendalikan proses login
  void _handleLogin() {
    setState(() {
      _errorMessage = '';
    });

    final String username = _usernameController.text;
    final String password = _passwordController.text;

    // Logik simulasi login
    if (username == 'admin' && password == 'admin') {
      // Navigasi ke AdminDashboard
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminDashboard()),
      );
    } else if ((username == 'Firdaus' || username == 'Fitri') &&
        password == 'rider') {
      // Navigasi ke RiderDashboard
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RiderDashboard()),
      );
    } else {
      setState(() {
        _errorMessage = 'Nama pengguna atau kata laluan tidak sah.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Log Masuk',
          style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Paparkan logo
            Image.asset(
              'assets/frontlogo.jpg',
              width: 150, // Saiz logo
            ),
            const SizedBox(height: 16.0), // Ruang di bawah logo
            Text(
              'Dashboard Anda', // Teks telah ditukar
              style: GoogleFonts.ubuntu(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 32.0),
            TextField(
              controller: _usernameController,
              style: GoogleFonts.ubuntu(),
              decoration: _inputDecoration('Nama Pengguna'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: GoogleFonts.ubuntu(),
              decoration: _inputDecoration('Kata Laluan'),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _errorMessage,
                  style: GoogleFonts.ubuntu(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                textStyle: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
              ),
              child: const Text('Log Masuk'),
            ),
          ],
        ),
      ),
    );
  }

  // Widget bantuan untuk membuat input field yang konsisten
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.ubuntu(color: primaryColor),
      filled: true,
      fillColor: accentColor2.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primaryColor, width: 2.0),
      ),
    );
  }
}
