import 'package:flutter/material.dart';
import 'pages/splash_page.dart';

void main() {
  runApp(const HealthPulseApp());
}

class HealthPulseApp extends StatelessWidget {
  const HealthPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthPulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
        fontFamily: 'Segoe UI', // Bisa diganti font modern lain seperti Poppins
      ),
      home: const SplashPage(),
    );
  }
}