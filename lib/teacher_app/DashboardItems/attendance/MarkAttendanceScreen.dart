import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Refactoration/Colors.dart';
import '../../../Refactoration/common_widgets.dart';
import 'ViewAttendanceScreen.dart';
import 'attendance_data.dart';

class MarkAttendanceScreen extends StatefulWidget {
  final String? initialLevel;
  final String? initialClass;
  final DateTime? initialDate;
  const MarkAttendanceScreen({
    Key? key,
    this.initialLevel,
    this.initialClass,
    this.initialDate,
  }) : super(key: key);

  @override
  _MarkAttendanceScreenState createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  String? selectedLevel;
  String? selectedClass;
  DateTime? selectedDate;
  bool isHoliday = false;
  List<String> students = [];
  List<bool> attendanceStatus = [];
  bool areAllSelected = false;



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
    students = [];
    attendanceStatus = [];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void updateStudentsList(String? className) {
    setState(() {
      selectedClass = className;
      if (className != null) {
        students = AttendanceData().classStudents[className] ?? [];
        attendanceStatus = List<bool>.filled(students.length, false);
      } else {
        students = [];
        attendanceStatus = [];
      }
    });
  }

  void selectAll() {
    setState(() {
      if (areAllSelected) {
        attendanceStatus =
            List<bool>.filled(students.length, false);
      } else {
        attendanceStatus =
            List<bool>.filled(students.length, true);
      }
      areAllSelected = !areAllSelected;
    });
  }

  void toggleAttendance(int index) {
    setState(() {
      attendanceStatus[index] = !attendanceStatus[index];
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void submitAttendance() {
    if (selectedLevel == null || selectedClass == null || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select level, class, and date')),
      );
      return;
    }

    if (isHoliday) {
      AttendanceData.saveHoliday(selectedDate!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submitted successfully')),
      );
    }
    else {
      AttendanceData.saveAttendance(selectedClass!, selectedDate!, students, attendanceStatus);
      print('Saved attendance for $selectedClass on ${DateFormat('yyyy-MM-dd').format(selectedDate!)}: ${AttendanceData.getAttendance(selectedClass!, selectedDate!)}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance submitted successfully')),
      );
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ViewAttendanceScreen(
          initialLevel: selectedLevel,
          initialClass: selectedClass,
          initialDate: selectedDate,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Mark Attendance',
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
                      items: selectedLevel != null
                          ? AttendanceData().levelClasses[selectedLevel]!
                          : [],
                      onChanged: (value) {
                        updateStudentsList(value);
                      },
                      hint: 'Select Class',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
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
                                  : DateFormat('yyyy-MM-dd')
                                      .format(selectedDate!),
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
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: isHoliday,
                  onChanged: (value) {
                    setState(() {
                      isHoliday = value ?? false;
                    });
                  },
                ),
                const Text('Holiday'),
              ],
            ),
            Expanded(
              child: isHoliday
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
                  : Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 30),
                              const Expanded(child: SizedBox()),
                              SizedBox(
                                width: 100,
                                child: TextButton(
                                  onPressed:
                                      students.isNotEmpty ? selectAll : null,
                                  style: TextButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: const Text(
                                    'Select ALL',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 30,
                                child: Text(
                                  'No',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Name',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: Column(
                                  children: [
                                    Text(
                                      'Status',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: students.length,
                              itemBuilder: (context, index) {
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
                                            students[index],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textColor,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: Checkbox(
                                            value: attendanceStatus[index],
                                            onChanged: (value) {
                                              toggleAttendance(index);
                                            },
                                            activeColor: AppColors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (index < students.length - 1)
                                      const Divider(),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 10),
            CustomButton(
              buttonText: 'Submit',
              onPressed: submitAttendance,
            ),
          ],
        ),
      ),
    );
  }
}
