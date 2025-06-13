import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final CollectionReference students =
  FirebaseFirestore.instance.collection('students');

  Future<bool> login(String email, String password) async {
    try {
      // البحث عن الطالب باستخدام البريد الإلكتروني
      QuerySnapshot query = await students.where('Email', isEqualTo: email).get();

      if (query.docs.isEmpty) {
        return false; // البريد غير موجود
      }

      // أخذ أول نتيجة (البريد الإلكتروني فريد)
      DocumentSnapshot doc = query.docs.first;
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      // التحقق من كلمة المرور
      if (data['Password'] == password) {
        return true;
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
    }

    return false; // كلمة المرور غير صحيحة
  }
}
