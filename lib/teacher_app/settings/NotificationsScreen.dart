import 'package:flutter/material.dart';

import '../../Refactoration/common_widgets.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Notifications',
        showBackButton: true,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          "Notifications Page",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}