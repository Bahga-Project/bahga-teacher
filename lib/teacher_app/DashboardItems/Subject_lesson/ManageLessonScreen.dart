import 'package:flutter/material.dart';
import '/../Refactoration/Colors.dart';
import 'CreateLessonScreen.dart';
import 'LessonCard.dart';
import 'ManageTopicScreen.dart';
import '/../Refactoration/common_widgets.dart';

class ManageLessonScreen extends StatefulWidget {
  const ManageLessonScreen({super.key});

  @override
  State<ManageLessonScreen> createState() => _ManageLessonScreenState();
}

class _ManageLessonScreenState extends State<ManageLessonScreen> {
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
  Map<String, List<Map<String, String?>>> lessonsMap = {};
  Map<String, List<Map<String, String?>>> topicsMap = {};
  String? selectedClass;
  String? selectedSubject;
  String? selectedLevel;

  @override
  void initState() {
    super.initState();
    selectedLevel = levelsList.isNotEmpty ? levelsList.first : null;

    selectedClass = (selectedLevel != null &&
        classesMap[selectedLevel]?.isNotEmpty == true)
        ? classesMap[selectedLevel]!.first
        : null;

    selectedSubject = (selectedClass != null &&
        subjectsMap[selectedClass]?.isNotEmpty == true)
        ? subjectsMap[selectedClass]!.first
        : null;
  }

  void modifyLesson({
    required String subject,
    required Map<String, String?> lessonData,
    int? index,
    bool isDelete = false,
  }) {
    setState(() {
      if (isDelete && index != null) {
        lessonsMap[subject]?.removeAt(index);
      } else if (index != null) {
        lessonsMap[subject]![index] = lessonData;
      } else {
        lessonsMap[subject] ??= [];
        lessonsMap[subject]!.add(lessonData);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Manage Lesson',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Container(
        color: AppColors.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ManageDropdown<String>(
                      value: selectedLevel,
                      items: levelsList,
                      itemToString: (item) => item,
                      onChanged: (value) {
                        setState(() {
                          selectedLevel = value;
                          selectedClass = null;
                          selectedSubject = null;
                        });
                      },
                      isExpanded: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ManageDropdown<String>(
                      value: selectedClass,
                      items: (selectedLevel != null && classesMap[selectedLevel] != null)
                          ? classesMap[selectedLevel]!
                          : [],
                      itemToString: (item) => item,
                      onChanged: (value) {
                        setState(() {
                          selectedClass = value;
                          selectedSubject = (value != null &&
                              subjectsMap[value]?.isNotEmpty == true)
                              ? subjectsMap[value]!.first
                              : null;
                        });
                      },
                      isExpanded: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ManageDropdown<String>(
                      value: selectedSubject,
                      items: (selectedClass != null && subjectsMap[selectedClass] != null)
                          ? subjectsMap[selectedClass]!
                          : [],
                      itemToString: (item) => item,
                      onChanged: (value) {
                        setState(() {
                          selectedSubject = value;
                        });
                      },
                      isExpanded: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Lesson List',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedSubject != null &&
                      lessonsMap[selectedSubject] != null
                      ? lessonsMap[selectedSubject]!.length
                      : 0,
                  itemBuilder: (context, index) {
                    if (selectedSubject == null ||
                        lessonsMap[selectedSubject] == null) {
                      return const SizedBox();
                    }

                    var lesson = lessonsMap[selectedSubject!]![index];
                    return LessonCard(
                      levelsList: levelsList,
                      title: lesson["name"] ?? "No Title",
                      description: lesson["description"] ?? "",
                      selectedClass: selectedClass,
                      selectedSubject: selectedSubject,
                      selectedLevel: selectedLevel,
                      onDelete: () {
                        modifyLesson(
                          subject: selectedSubject!,
                          lessonData: {},
                          index: index,
                          isDelete: true,
                        );
                      },
                      onEdit: () async {
                        dynamic result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateLessonScreen(
                              initialLevel: selectedLevel,
                              initialClass: selectedClass,
                              initialSubject: selectedSubject,
                              initialTitle: lesson["name"],
                              initialDescription: lesson["description"],
                              editIndex: index,
                            ),
                          ),
                        );
                        if (result != null && result is Map) {
                          setState(() {
                            selectedLevel = result["level"];
                            selectedClass = result["class"];
                            selectedSubject = result["subject"];
                            modifyLesson(
                              subject: result["subject"],
                              lessonData: result["lessonData"],
                              index: result["editIndex"],
                            );
                          });
                        }
                      },
                      viewTopics: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManageTopicScreen(
                              lessonsMap: lessonsMap,
                              initialLevel: selectedLevel,
                              initialClass: selectedClass,
                              initialSubject: selectedSubject,
                              initialLesson: lesson["name"],
                            ),
                          ),
                        );
                        if (result == true) {
                          setState(() {});
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                buttonText: 'Create Lesson',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateLessonScreen(
                        initialLevel: selectedLevel,
                        initialClass: selectedClass,
                        initialSubject: selectedSubject,
                      ),
                    ),
                  ).then((result) {
                    if (result != null && result is Map) {
                      setState(() {
                        selectedLevel = result["level"];
                        selectedClass = result["class"];
                        selectedSubject = result["subject"];
                        modifyLesson(
                          subject: result["subject"],
                          lessonData: result["lessonData"],
                          index: result["editIndex"],
                        );
                      });
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}