import 'package:flutter/material.dart';
import 'package:gp_sprint1/teacher_app/settings/SettingsScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../Refactoration/Colors.dart';
import '../../Refactoration/common_widgets.dart';

class ProfileScreen extends StatelessWidget {
  final String teacherName = "Ms:Aya Mohamed";
  final String teacherEmail = "aya@gmail.com";
  final String teacherId = "45000";
  final String profilePictureUrl = "assets/images/profile.jpg";
  final String dateOfBirth = "04/05/2003";
  final String gender = "Female";
  final String address = "123 Cairo St, Egypt";





  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title:  "Profile",
        leadingIcon: Icons.person,
        showBackButton: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 60,
              backgroundImage: CachedNetworkImageProvider(profilePictureUrl),
              onBackgroundImageError: (exception, stackTrace) {
                print('Error loading image: $exception');
              },
              child: const Icon(
                Icons.person,
                color: Colors.grey,
                size: 60,
              ),
            ),
            const SizedBox(height: 16),
            // Teacher Name
            Text(
              teacherName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 8),
            // Teacher Email
            Text(
              teacherEmail,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textColor_2,
              ),
            ),
            const SizedBox(height: 24),
            // Profile Details Card

            Card(
              color: AppColors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Personal INFO',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildDetailField('Teacher ID', teacherId),
                    const SizedBox(height: 16),
                    buildDetailField('Email', teacherEmail),
                    const SizedBox(height: 16),
                    buildDetailField('Date of Birth', dateOfBirth),
                    const SizedBox(height: 16),
                    buildDetailField('Gender', gender),
                    const SizedBox(height: 16),
                    buildDetailField('Address', address),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              color: AppColors.white, // Match card style
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Personal Settings',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.hintTextColor, width: 1),
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.dialogBackground,
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.settings, color: AppColors.primaryColor),
                        title: const Text(
                          "Settings",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.textColor_2, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingsScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}