import 'package:intl/intl.dart';

class AttendanceData {
  static final Map<String, Map<String, bool>> _attendanceRecords = {};
  static final Map<String, bool> _holidayRecords = {};

  static void saveAttendance(String className, DateTime date, List students, List statuses) {
    final dateKey = DateFormat('yyyy-MM-dd').format(date);
    final recordKey = '$className-$dateKey';
    final attendance = <String, bool>{};
    for (int i = 0; i < students.length; i++) {
      attendance[students[i]] = statuses[i];
    }
    _attendanceRecords[recordKey] = attendance;
  }

  static Map<String, bool>? getAttendance(String className, DateTime? date) {
    if (date == null) return null;
    final dateKey = DateFormat('yyyy-MM-dd').format(date);
    final recordKey = '$className-$dateKey';
    return _attendanceRecords[recordKey];
  }

  static void saveHoliday(DateTime date) {
    final dateKey = DateFormat('yyyy-MM-dd').format(date);
    _holidayRecords[dateKey] = true;
  }

  static bool isHoliday(DateTime? date) {
    if (date == null) return false;
    final dateKey = DateFormat('yyyy-MM-dd').format(date);
    return _holidayRecords[dateKey] ?? false;
  }

  final Map<String, List<String>> levelClasses = {
    'Level 1': ['1 A', '1 B', '1 C'],
    'Level 2': ['2 A', '2 B'],
    'Level 3': ['3 A', '3 B'],
  };

  final Map<String, List<String>> classStudents = {
    '1 A': [
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
    ],
    '1 B': ['Student 1', 'Student 2', 'Student 3', 'Student 4'],
    '1 C': ['Student 1', 'Student 2', 'Student 3', 'Student 4', 'Student 5', 'Student 6', 'Student 7', 'Student 8'],
    '2 A': ['Student 5', 'Student 6', 'Student 7', 'Student 8', 'Student 9', 'Student 10'],
    '2 B': ['Student 7', 'Student 8', 'Student 9', 'Student 10'],
    '3 A': ['Student 9', 'Student 10', 'Student 11'],
    '3 B': ['Student 1', 'Student 2', 'Student 3', 'Student 4', 'Student 5', 'Student 6'],
  };
}