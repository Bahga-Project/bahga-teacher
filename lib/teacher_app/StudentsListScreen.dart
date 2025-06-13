import 'package:flutter/material.dart';

import '../Refactoration/common_widgets.dart';

class StudentsListScreen extends StatefulWidget {
  @override
  State<StudentsListScreen> createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends State<StudentsListScreen> {
  final List<String> students = [
    "Aya Mohamed",
    "Mohamed Mahmoud",
    "Mawada Mahmoud",
    "Judy Mahmoud",
    "Elen Mohamed",
    "Anas Soliman",
    "Basmala Mahmoud",
    "Hassan Abdelrahman",
    "Aya Samir",
    "Mohamed Tarek",
    "Nour Ashraf",
    "Mohamed Anwar",
    "Arwa Ahmed",
    "Abdullah Mohamed",

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Student List',
        showBackButton: true,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: students.length,
        itemBuilder: (context, index) {
          return Card(
            color: const Color(0xFFF5F5F5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                students[index],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}