import 'package:flutter/material.dart';
import 'package:gp_sprint1/teacher_app/LoginScreen.dart';
import 'package:gp_sprint1/teacher_app/settings/NotificationsScreen.dart';
import 'package:gp_sprint1/teacher_app/settings/about_us_screen.dart';
import 'package:gp_sprint1/teacher_app/settings/contact_us_screen.dart';
import 'package:gp_sprint1/teacher_app/settings/terms_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Refactoration/Colors.dart';
import '../../Refactoration/common_widgets.dart';
import '../../Refactoration/utils.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedLanguage = "English";


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:const CustomAppBar(
        title: 'Settings',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  SettingsTile(
                    icon: Icons.language,
                    title: selectedLanguage,
                    onTap: () async {
                      final newLanguage = await showLanguageBottomSheet(context, selectedLanguage);
                      if (newLanguage != null) {
                        setState(() {
                          selectedLanguage = newLanguage;
                        });
                      }
                    },
                  ),
                  SettingsTile(
                    icon: Icons.lock,
                    title: "Change password",
                    onTap: () async {
                      final success = await showChangePassword(context);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Password changed successfully!")),
                        );
                      }
                    },
                  ),
                  SettingsTile(
                    icon: Icons.notifications,
                    title: "Notifications",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => NotificationsScreen()),
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.description,
                    title: "Terms & Condition",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => TermsScreen()),
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.info,
                    title: "About Us",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AboutUsScreen()),
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.contact_support,
                    title: "Contact Us",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ContactUsScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.remove('teacher_password');
                        await prefs.remove('teacher_email');

                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.logOutButton,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.power_settings_new, color: AppColors.white),
                          SizedBox(width: 10),
                          Text(
                            "Log out",
                            style: TextStyle(color: AppColors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}