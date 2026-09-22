import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CodeUpApp());
}

class CodeUpApp extends StatelessWidget {
  const CodeUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CodeUp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}