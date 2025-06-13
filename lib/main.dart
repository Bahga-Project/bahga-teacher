import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gp_sprint1/teacher_app/BottomNavigationBarItem/HomePage.dart';
import 'package:gp_sprint1/teacher_app/LoginScreen.dart';
import 'firebase_options.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
