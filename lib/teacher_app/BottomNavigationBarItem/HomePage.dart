import 'package:flutter/material.dart';
import '../../Refactoration/Colors.dart';
import 'DashboardScreen.dart';
import 'HomeContent.dart';
import 'ProfileScreen.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const DashboardScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: SafeArea(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: Material(
            elevation: 8,
            child: SizedBox(
              height: 75,
              child: BottomNavigationBar(
                backgroundColor: AppColors.dialogBackground,
                selectedItemColor: AppColors.primaryColor,
                unselectedItemColor: AppColors.textColor_2,
                currentIndex: _selectedIndex,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                selectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.normal),
                selectedIconTheme: const IconThemeData(
                  size: 28,
                  weight: 700,
                ),
                unselectedIconTheme: const IconThemeData(
                  size: 24,
                  weight: 400,
                ),
                showSelectedLabels: true,
                showUnselectedLabels: true,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard),
                    label: "Dashboard",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: "Profile",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
