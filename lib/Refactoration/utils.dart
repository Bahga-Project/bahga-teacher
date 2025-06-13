import 'package:flutter/material.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:file_picker/file_picker.dart';
import '../teacher_app/settings/change_password.dart';
import 'common_widgets.dart';
import 'Colors.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

Future<void> openFile(BuildContext context, String? filePath) async {
  if (filePath == null || filePath.isEmpty) {
    showSnackBar(context, "No file path available! ❌");
    return;
  }

  final file = File(filePath);
  if (!await file.exists()) {
    showSnackBar(context, "File does not exist! ❌");
    return;
  }

  final result = await OpenFile.open(filePath);
  if (result.type != ResultType.done) {
    showSnackBar(context,
        "Cannot open file. Please ensure a compatible app is installed! ❌");
  }
}

void showOptionsDialog({
  required BuildContext context,
  required VoidCallback onDelete,
  VoidCallback? onEdit,
  String title = "Choose an action",
}) {
  showDialog(
    context: context,
    builder: (context) => OptionsDialog(
      title: title,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Center(
                  child: Text(
                    "Confirm Deletion",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                content: const Text("Are you sure you want to delete?"),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onDelete();
                        },
                        child: const Text(
                          "Yes",
                          style: TextStyle(color: AppColors.deleteButtonColor),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "No",
                          style: TextStyle(color: AppColors.textColor_2),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          child: const Text(
            "Delete",
            style: TextStyle(color: AppColors.deleteButtonColor),
          ),
        ),
        if (onEdit != null)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onEdit();
            },
            child: const Text(
              "Edit",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.primaryColor),
            ),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Cancel",
            style: TextStyle(color: AppColors.textColor_2),
          ),
        ),
      ],
    ),
  );
}

Future<void> pickFile({
  required BuildContext context,
  required Function(String) onFilePicked,
}) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result != null) {
    final filePath = result.files.single.path;
    if (filePath != null && await File(filePath).exists()) {
      onFilePicked(filePath);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selected file does not exist! ❌")),
      );
    }
  }
}

String getCurrentDay() {
  final now = DateTime.now();
  switch (now.weekday) {
    case 1:
      return "Mon";
    case 2:
      return "Tue";
    case 3:
      return "Wed";
    case 4:
      return "Thu";
    case 5:
      return "Fri";
    case 6:
      return "Sat";
    case 7:
      return "Sun";
    default:
      return "Mon";
  }
}

Future<bool> showChangePassword(BuildContext context) async {
  return await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ChangePassword(),
  ) ?? false;
}

bool validatePasswordMatch(String newPassword, String confirmPassword) {
  return newPassword == confirmPassword;
}
Future<String?> showLanguageBottomSheet(BuildContext context, String currentLanguage) async {
  String selectedLanguage = currentLanguage;
  return await showModalBottomSheet<String?>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 30.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Application language",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Column(
            children: [
              RadioListTile<String>(
                title: Text("English"),
                value: "English",
                groupValue: selectedLanguage,
                activeColor: AppColors.primaryColor,
                onChanged: (value) {
                  if (value != null) {
                    selectedLanguage = value;
                    Navigator.pop(context, selectedLanguage);
                  }
                },
              ),
              RadioListTile<String>(
                title: Text("Arabic"),
                value: "Arabic",
                groupValue: selectedLanguage,
                activeColor: AppColors.primaryColor,
                onChanged: (value) {
                  if (value != null) {
                    selectedLanguage = value;
                    Navigator.pop(context, selectedLanguage);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}