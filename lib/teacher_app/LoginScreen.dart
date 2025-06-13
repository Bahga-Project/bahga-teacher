import 'package:flutter/material.dart';
import 'package:gp_sprint1/teacher_app/BottomNavigationBarItem/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Refactoration/Colors.dart';
import 'DashboardItems/Subject_lesson/ManageLessonScreen.dart';
import 'DashboardItems/onlinExam/services/authServices.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final AuthService _authService = AuthService();


  bool _rememberMe = false;

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        _emailController.text = prefs.getString('email') ?? '';
        _passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setBool('rememberMe', _rememberMe);
      await prefs.setString('email', _emailController.text);
      await prefs.setString('password', _passwordController.text);
    } else {
      await prefs.remove('rememberMe');
      await prefs.remove('email');
      await prefs.remove('password');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.42,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              image: DecorationImage(
                image: AssetImage('assets/images/Teacher_login.gif'),
                fit: BoxFit.contain,
                alignment: Alignment.center,
                opacity: 0.9,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 135),
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                margin: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: double.infinity),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Email:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.formTextColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: 'Enter your email',
                              hintStyle: const TextStyle(
                                  fontSize: 15,
                                  color: AppColors.hintTextColor),
                              prefixIcon: const Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(width: 0.0, color: Color(0xFFD7D5D5)),
                              ),
                              filled: true,
                              fillColor:AppColors.formFieldColor,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Password:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.formTextColor,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Enter your password',
                              hintStyle: const TextStyle(
                                  fontSize: 15,
                                  color: AppColors.hintTextColor),
                              prefixIcon: const Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(width: 0, color: Color(0xFFD7D5D5)),
                              ),
                              filled: true,
                              fillColor:AppColors.formFieldColor,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Enter a valid password (at least 6 characters)';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    onChanged: (value) {
                                      setState(() {
                                        _rememberMe = value ?? false;
                                      });
                                    },
                                  ),
                                  const Text('Remember me'),
                                ],
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Forgot Password? Reset',
                                  style: TextStyle(color: AppColors.primaryColor),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Transform.translate(
                                offset: const Offset(0, 20),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      _saveData(); // لحفظ بيانات المستخدم لو مختار "Remember Me"

                                      final success = await _authService.login(
                                        _emailController.text.trim(),
                                        _passwordController.text.trim(),
                                      );

                                      if (success) {
                                        // تسجيل الدخول ناجح
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => HomePage()),
                                        );
                                      } else {
                                        // تسجيل الدخول فشل
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Email or password is incorrect'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  }
                                  ,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 8),
                                  ),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
