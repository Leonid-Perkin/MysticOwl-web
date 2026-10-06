import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const AstralTarotApp());
}

class AstralTarotApp extends StatelessWidget {
  const AstralTarotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Astral Tarot — Расклады Таро',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0E0918),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4AF37),
          secondary: Color(0xFF9575CD),
          surface: Color(0xFF160F29),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
