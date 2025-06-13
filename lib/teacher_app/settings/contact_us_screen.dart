import 'package:flutter/material.dart';
import '../../../Refactoration/Colors.dart';
import '../../../Refactoration/common_widgets.dart';

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Contact Us",
        backgroundColor: AppColors.appBarColor,
        showBackButton: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("#262-263", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("Time Square Empire,", style: TextStyle(fontSize: 16.0)),
              Text("SH 42 Mirjapar Highway,", style: TextStyle(fontSize: 16.0)),
              Text("Bhuj - Kutch 370001", style: TextStyle(fontSize: 16.0)),
              Text("Gujarat India.", style: TextStyle(fontSize: 16.0)),
            ],
          ),
        ),
      ),
    );
  }
}