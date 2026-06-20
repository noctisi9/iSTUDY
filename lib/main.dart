import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const IStudyApp());
}

class IStudyApp extends StatelessWidget {
  const IStudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iStudy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2E7D32),
        scaffoldBackgroundColor: const Color(0xFFF6F6F3),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black87,
          centerTitle: false,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
