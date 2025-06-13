import 'package:flutter/material.dart';
import '/../Refactoration/common_widgets.dart';
import '/../Refactoration/Colors.dart';

class CreateLessonScreen extends StatefulWidget {
  final String? initialLevel;
  final String? initialClass;
  final String? initialSubject;
  final String? initialTitle;
  final String? initialDescription;
  final int? editIndex;

  const CreateLessonScreen({
    super.key,
    this.initialLevel,
    this.initialClass,
    this.initialSubject,
    this.initialTitle,
    this.initialDescription,
    this.editIndex,
  });

  @override
  _CreateLessonScreenState createState() => _CreateLessonScreenState();
}

class _CreateLessonScreenState extends State<CreateLessonScreen> {
  List<String> levelsList = ["Level 1", "Level 2", "Level 3"];
  Map<String, List<String>> classesMap = {
    "Level 1": ["2 A", "1 B"],
    "Level 2": ["2 C"],
    "Level 3": [],
  };
  Map<String, List<String>> subjectsMap = {
    "2 A": ["Math", "Science"],
    "1 B": ["History", "Physics"],
    "2 C": ["Biology", "Chemistry"],
  };
  String? selectedLevel;
  String? selectedClass;
  String? selectedSubject;
  final TextEditingController lessonNameController = TextEditingController();
  final TextEditingController lessonDescriptionController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedLevel =
        widget.initialLevel != null && levelsList.contains(widget.initialLevel)
            ? widget.initialLevel
            : (levelsList.isNotEmpty ? levelsList.first : null);

    selectedClass = widget.initialClass;
    if (selectedClass == null ||
        selectedLevel == null ||
        classesMap[selectedLevel] == null ||
        !classesMap[selectedLevel]!.contains(selectedClass)) {
      selectedClass = (selectedLevel != null &&
              classesMap[selectedLevel]?.isNotEmpty == true)
          ? classesMap[selectedLevel]!.first
          : null;
    }

    selectedSubject = widget.initialSubject;
    if (selectedSubject == null ||
        selectedClass == null ||
        subjectsMap[selectedClass] == null ||
        !subjectsMap[selectedClass]!.contains(selectedSubject)) {
      selectedSubject = (selectedClass != null &&
              subjectsMap[selectedClass]?.isNotEmpty == true)
          ? subjectsMap[selectedClass]!.first
          : null;
    }

    lessonNameController.text = widget.initialTitle ?? "";
    lessonDescriptionController.text = widget.initialDescription ?? "";
  }

  void saveLesson() {
    if (lessonNameController.text.isNotEmpty &&
        selectedClass != null &&
        selectedSubject != null) {
      final lessonData = {
        "name": lessonNameController.text,
        "description": lessonDescriptionController.text,
      };
      Navigator.pop(context, {
        "subject": selectedSubject,
        "lessonData": lessonData,
        "editIndex": widget.editIndex,
        "level": selectedLevel,
        "class": selectedClass,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Please enter a lesson name and select all required fields'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.editIndex != null ? 'Edit Lesson' : 'Create Lesson',
        showBackButton: true,
        onBackPressed: () {
          if (lessonNameController.text.isNotEmpty) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Center(child: Text("Unsaved Changes")),
                content: const Text(
                    "Do you want to save the lesson before leaving?"),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text("No"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          saveLesson();
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            Navigator.pop(context);
          }
        },
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CreateDropdown(
              value: selectedLevel,
              items: levelsList,
              hint: "Select Level",
              onChanged: (value) {
                setState(() {
                  selectedLevel = value;
                  selectedClass = null;
                  selectedSubject = null;
                });
              },
            ),
            const SizedBox(height: 16),
            CreateDropdown(
              value: selectedClass,
              items:
                  (selectedLevel != null && classesMap[selectedLevel] != null)
                      ? classesMap[selectedLevel]!
                      : [],
              hint: "Select Class",
              onChanged: (value) {
                setState(() {
                  selectedClass = value;
                  selectedSubject =
                      (value != null && subjectsMap[value]?.isNotEmpty == true)
                          ? subjectsMap[value]!.first
                          : null;
                });
              },
            ),
            const SizedBox(height: 16),
            CreateDropdown(
              value: selectedSubject,
              items:
                  (selectedClass != null && subjectsMap[selectedClass] != null)
                      ? subjectsMap[selectedClass]!
                      : [],
              hint: "Select Subject",
              onChanged: (value) {
                setState(() {
                  selectedSubject = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TopicTextFields(
              nameController: lessonNameController,
              descriptionController: lessonDescriptionController,
              nameLabel: 'Lesson Name',
              descriptionLabel: 'Description',
            ),
            const SizedBox(height: 16),
            CustomButton(
              onPressed: saveLesson,
              buttonText:
                  widget.editIndex != null ? 'Update Lesson' : 'Save Lesson',
              backgroundColor: AppColors.primaryColor,
              textColor: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }
}
