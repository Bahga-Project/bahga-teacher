import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Refactoration/Colors.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() =>
      _ChangePasswordState();
}

class _ChangePasswordState
    extends State<ChangePassword> {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? errorMessage;
  bool _currentPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;
  bool isLoading = false;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  String? validatePasswordChange(
      String current,
      String newPass,
      String confirm,
      String? storedPassword,
      ) {
    // التأكد من أن جميع الحقول تم ملؤها
    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      return "All fields are required.";
    }

    // التأكد من أن كلمة المرور الجديدة تحتوي على 6 أحرف على الأقل
    if (newPass.length < 6) {
      return "New password must be at least 6 characters.";
    }

    // التأكد من أن كلمة المرور الجديدة ليست هي نفسها القديمة
    if (current.trim() == newPass.trim()) {
      return "New password must be different from current password.";
    }

    // التأكد من أن كلمة المرور الجديدة تطابق تأكيد كلمة المرور
    if (newPass.trim() != confirm.trim()) {
      return "New password and confirm password must match.";
    }

    // التأكد من أن كلمة المرور القديمة المدخلة صحيحة
    if (storedPassword != null && current.trim() != storedPassword.trim()) {
      return "Current password is incorrect.";
    }

    return null; // إذا كانت جميع الشروط سليمة، لا توجد أخطاء
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Change password",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: currentPasswordController,
                obscureText: !_currentPasswordVisible,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "Current password",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _currentPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _currentPasswordVisible = !_currentPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: newPasswordController,
                obscureText: !_newPasswordVisible,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "New password",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _newPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _newPasswordVisible = !_newPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: confirmPasswordController,
                obscureText: !_confirmPasswordVisible,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: "Confirm new password",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _confirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _confirmPasswordVisible = !_confirmPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              if (errorMessage != null) ...[
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.redAccent, fontSize: 14),
                  ),
                ),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                  setState(() => isLoading = true);

                  SharedPreferences prefs =
                  await SharedPreferences.getInstance();
                  String? storedPassword =
                  prefs.getString('userPassword');

                  String current = currentPasswordController.text.trim();
                  String newPass = newPasswordController.text.trim();
                  String confirm = confirmPasswordController.text.trim();

                  String? validationResult = validatePasswordChange(
                    current,
                    newPass,
                    confirm,
                    storedPassword,
                  );

                  setState(() {
                    errorMessage = validationResult;
                    isLoading = false;
                  });

                  if (validationResult == null) {
                    // حفظ كلمة المرور الجديدة (مؤقتًا، للأغراض التجريبية فقط)
                    await prefs.setString('userPassword', newPass);
                    Navigator.pop(context, true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.black)
                    : Text("Submit"),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
