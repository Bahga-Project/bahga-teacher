import 'package:flutter/material.dart';
import '../../Refactoration/Colors.dart';
import '../../Refactoration/common_widgets.dart';
import '../DashboardItems/GradesScreen.dart';
import '../DashboardItems/attendance/MarkAttendanceScreen.dart';
import '../DashboardItems/Subject_lesson/ManageLessonScreen.dart';
import '../DashboardItems/Subject_lesson/ManageTopicScreen.dart';
import '../DashboardItems/onlinExam/screens/create_quiz_page.dart';
import '../DashboardItems/onlinExam/screens/quiz_list_page.dart';
import '../DashboardItems/timetable/TimetableScreen.dart';
import '../DashboardItems/attendance/ViewAttendanceScreen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<DashboardButton> filteredItems = [];
  final List<DashboardButton> dashboardButtons = [
    DashboardButton(
      icon: Icons.view_list_outlined,
      label: 'Timetable',
      color: const Color(0xFF4CAF50), // Green
      destination: TimetableScreen(),
    ),
    // DashboardButton(
    //   icon: Icons.bookmark_added_outlined,
    //   label: 'Assigned Classes',
    //   color: const Color(0xFFFFCA28), // Yellow
    //   destination: AssignedClassesScreen(),
    // ),
    DashboardButton(
      icon: Icons.fact_check_outlined,
      label: 'Mark Attendance',
      color: const Color(0xFFFF9800), // Orange
      destination: MarkAttendanceScreen(),
    ),
    DashboardButton(
      icon: Icons.list_alt,
      label: 'View Attendance',
      color: const Color(0xFF00BCD4), // Cyan
      destination: ViewAttendanceScreen(),
    ),
    const DashboardButton(
      icon: Icons.featured_play_list_outlined,
      label: 'Manage Lesson',
      color: AppColors.primaryColor, // Light Blue
      destination: ManageLessonScreen(
      ),
    ),
    const DashboardButton(
      icon: Icons.topic_outlined,
      label: 'Manage Topic',
      color: Color(0xFF26C6DA), // Teal
      destination: ManageTopicScreen(lessonsMap: {},
      ),
    ),
    DashboardButton(
      icon: Icons.note_alt_outlined,
      label: 'Create Quiz',
      color: const Color(0xFF044A57), // Red
      destination:CreateQuizPage(),
    ),
    DashboardButton(
      icon: Icons.list,
      label: 'View Quizzes',
      color: const Color(0xFF8985E9), // Red
      destination:QuizListPage(),
    ),
    DashboardButton(
      icon: Icons.grade_outlined,
      label: 'Grades',
      color: const Color(0xFF388E3C), // Dark Green
      destination: GradesScreen(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    filteredItems = dashboardButtons;
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      filteredItems = dashboardButtons
          .where((button) => button.label.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: 'Dashboard',
        leadingIcon: Icons.dashboard,
        showBackButton: false,
        showSearchIcon: true,
        onSearchPressed: () {
          setState(() {
            isSearching = !isSearching;
            if (!isSearching) {
              _searchController.clear();
              filteredItems = dashboardButtons;
            }
          });
        },
        searchField: isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: AppColors.white),
                decoration: const InputDecoration(
                  hintText: 'Search ...',
                  hintStyle: TextStyle(color: AppColors.white),
                  border: InputBorder.none,
                ),
              )
            : null,
      ),
      body: filteredItems.isEmpty
          ? const Center(child: Text('No items found'))
          : GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.9,
              children: filteredItems,
            ),
    );
  }
}
