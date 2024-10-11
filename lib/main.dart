import 'package:flutter/material.dart';
import 'package:skintone_remake/screens/home_page.dart';
import 'package:skintone_remake/screens/image_process.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final appTitle = 'StyleHue';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: const HomePage(),
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF2F2F2),
      ),
    );
  }
}
