import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/../../Refactoration/Colors.dart';
import '/../../Refactoration/common_widgets.dart';
import 'attendance_data.dart';

class ViewAttendanceScreen extends StatefulWidget {
  final String? initialLevel;
  final String? initialClass;
  final DateTime? initialDate;

  const ViewAttendanceScreen({
    Key? key,
    this.initialLevel,
    this.initialClass,
    this.initialDate,
  }) : super(key: key);

  @override
  _ViewAttendanceScreenState createState() => _ViewAttendanceScreenState();
}

class _ViewAttendanceScreenState extends State<ViewAttendanceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  String? selectedLevel;
  String? selectedClass;
  String? selectedStatus;
  DateTime? selectedDate;



  List<String> students = [];
  List<bool> attendanceStatus = [];
  final List<String> statusOptions = ['All', 'Present', 'Absent'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    selectedLevel = widget.initialLevel;
    selectedClass = widget.initialClass;
    selectedDate = widget.initialDate;
    selectedStatus = 'All';

    if (selectedClass != null && selectedDate != null) {
      updateStudentsList(selectedClass);
    } else {
      students = [];
      attendanceStatus = [];
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void updateStudentsList(String? className) {
    setState(() {
      selectedClass = className;
      if (className != null && selectedDate != null) {
        students = AttendanceData().classStudents[className] ?? [];
        updateAttendanceStatus();
      } else {
        students = [];
        attendanceStatus = [];
      }
    });
  }

  void updateAttendanceStatus() {
    if (selectedClass == null || selectedDate == null) {
      attendanceStatus = List<bool>.filled(students.length, false);
      return;
    }
    final attendance = AttendanceData.getAttendance(selectedClass!, selectedDate!);
    if (attendance == null) {
      attendanceStatus = List<bool>.filled(students.length, false);
    } else {
      attendanceStatus = students.map((student) => attendance[student] == true).toList();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        updateAttendanceStatus();
      });
    }
  }

  List<String> getFilteredStudents() {
    if (selectedStatus == 'All') {
      return students;
    }
    final List<String> filtered = [];
    for (int i = 0; i < students.length; i++) {
      final isPresent = attendanceStatus[i];
      if ((selectedStatus == 'Present' && isPresent) || (selectedStatus == 'Absent' && !isPresent)) {
        filtered.add(students[i]);
      }
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final filteredStudents = getFilteredStudents();
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'View Attendance',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.textColor_2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CreateDropdown(
                      value: selectedLevel,
                      items: AttendanceData().levelClasses.keys.toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedLevel = value;
                          selectedClass = null;
                          updateStudentsList(null);
                        });
                      },
                      hint: 'Select Level',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.textColor_2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CreateDropdown(
                      value: selectedClass,
                      items: selectedLevel != null ? AttendanceData().levelClasses[selectedLevel]! : [],
                      onChanged: (value) {
                        updateStudentsList(value);
                      },
                      hint: 'Select Class',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.textColor_2),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CreateDropdown(
                value: selectedStatus,
                items: statusOptions,
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value;
                  });
                },
                hint: 'Select Status',
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: InkWell(
                    onTap: () {
                      _animationController.forward().then((_) {
                        _animationController.reverse();
                        _selectDate(context);
                      });
                    },
                    borderRadius: BorderRadius.circular(25),
                    child: AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: child,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.calendar_month_outlined,
                              color: AppColors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              selectedDate == null
                                  ? 'Select Date'
                                  : DateFormat('yyyy-MM-dd').format(selectedDate!),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 30,
                  child: Text(
                    'No',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    'Status',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: selectedDate == null
                  ? const Center(
                child: Text(
                  'Please select a date',
                  style: TextStyle(fontSize: 16, color: AppColors.textColor_2),
                ),
              )
                  : AttendanceData.isHoliday(selectedDate)
                  ? const Center(
                child: Text(
                  'Holiday',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor_2,
                  ),
                ),
              )
                  : filteredStudents.isEmpty
                  ? const Center(
                child: Text(
                  'No students found',
                  style: TextStyle(fontSize: 16, color: AppColors.textColor_2),
                ),
              )
                  : ListView.builder(
                itemCount: filteredStudents.length,
                itemBuilder: (context, index) {
                  final student = filteredStudents[index];
                  final studentIndex = students.indexOf(student);
                  final isPresent = studentIndex != -1 && attendanceStatus[studentIndex];
                  return Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 30,
                            child: Text('${index + 1}'),
                          ),
                          Expanded(
                            child: Text(
                              student,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                              isPresent ? 'Present' : 'Absent',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isPresent ? AppColors.green : AppColors.deleteButtonColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (index < filteredStudents.length - 1) const Divider(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}