import 'package:flutter/material.dart';
import '/../../Refactoration/Colors.dart';
import '/../../Refactoration/common_widgets.dart';
import '/../../Refactoration/utils.dart';

class CreateTopicScreen extends StatefulWidget {
  final String? initialLevel;
  final String? initialClass;
  final String? initialSubject;
  final String? initialLesson;
  final String? initialTitle;
  final String? initialDescription;
  final String? initialFilePath;
  final int? editIndex;
  final Map<String, List<Map<String, String?>>>? lessonsMap;

  const CreateTopicScreen({
    super.key,
    this.initialLevel,
    this.initialClass,
    this.initialSubject,
    this.initialLesson,
    this.initialTitle,
    this.initialDescription,
    this.initialFilePath,
    this.editIndex,
    this.lessonsMap,
  });

  @override
  _CreateTopicScreenState createState() => _CreateTopicScreenState();
}

class _CreateTopicScreenState extends State<CreateTopicScreen> {
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
  String? selectedLesson;

  final TextEditingController topicNameController = TextEditingController();
  final TextEditingController topicDescriptionController = TextEditingController();
  String? selectedFilePath;

  @override
  void initState() {
    super.initState();
    selectedLevel = widget.initialLevel != null && levelsList.contains(widget.initialLevel)
        ? widget.initialLevel
        : (levelsList.isNotEmpty ? levelsList.first : null);

    selectedClass = widget.initialClass;
    if (selectedClass == null ||
        selectedLevel == null ||
        classesMap[selectedLevel] == null ||
        !classesMap[selectedLevel]!.contains(selectedClass)) {
      selectedClass = (selectedLevel != null && classesMap[selectedLevel]?.isNotEmpty == true)
          ? classesMap[selectedLevel]!.first
          : null;
    }

    selectedSubject = widget.initialSubject;
    if (selectedSubject == null ||
        selectedClass == null ||
        subjectsMap[selectedClass] == null ||
        !subjectsMap[selectedClass]!.contains(selectedSubject)) {
      selectedSubject = (selectedClass != null && subjectsMap[selectedClass]?.isNotEmpty == true)
          ? subjectsMap[selectedClass]!.first
          : null;
    }

    selectedLesson = widget.initialLesson;
    if (selectedLesson == null ||
        selectedSubject == null ||
        widget.lessonsMap?[selectedSubject] == null ||
        !widget.lessonsMap![selectedSubject]!.any((lesson) => lesson["name"] == selectedLesson)) {
      selectedLesson = (selectedSubject != null && widget.lessonsMap?[selectedSubject]?.isNotEmpty == true)
          ? widget.lessonsMap![selectedSubject]!.first["name"]
          : null;
    }

    topicNameController.text = widget.initialTitle ?? "";
    topicDescriptionController.text = widget.initialDescription ?? "";
    selectedFilePath = widget.initialFilePath;

    print("selectedSubject: $selectedSubject, selectedLesson: $selectedLesson, initialSubject: ${widget.initialSubject}, initialLesson: ${widget.initialLesson}, lessonsMap: ${widget.lessonsMap}");
  }

  void saveTopic() {
    if (topicNameController.text.isNotEmpty) {
      Navigator.pop(context, {
        "lesson": selectedLesson ?? widget.initialLesson,
        "topicData": {
          "name": topicNameController.text,
          "description": topicDescriptionController.text,
          "filePath": selectedFilePath,
        },
        "editIndex": widget.editIndex,
        "level": selectedLevel,
        "class": selectedClass,
        "subject": selectedSubject,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a topic name")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.editIndex != null ? 'Edit Topic' : 'Create Topic',
        showBackButton: true,
        onBackPressed: () {
          if (topicNameController.text.isNotEmpty) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Center(child: Text("Unsaved Changes")),
                content: const Text("Do you want to save the topic before leaving?"),
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
                          saveTopic();
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
                  selectedClass = (value != null && classesMap[value]?.isNotEmpty == true)
                      ? classesMap[value]!.first
                      : null;
                  selectedSubject = (selectedClass != null && subjectsMap[selectedClass]?.isNotEmpty == true)
                      ? subjectsMap[selectedClass]!.first
                      : null;
                  selectedLesson = (selectedSubject != null && widget.lessonsMap?[selectedSubject]?.isNotEmpty == true)
                      ? widget.lessonsMap![selectedSubject]!.first["name"]
                      : null;
                });
              },
            ),
            const SizedBox(height: 16),
            CreateDropdown(
              value: selectedClass,
              items: (selectedLevel != null && classesMap[selectedLevel] != null)
                  ? classesMap[selectedLevel]!
                  : [],
              hint: "Select Class",
              onChanged: (value) {
                setState(() {
                  selectedClass = value;
                  selectedSubject = (value != null && subjectsMap[value]?.isNotEmpty == true)
                      ? subjectsMap[value]!.first
                      : null;
                  selectedLesson = (selectedSubject != null && widget.lessonsMap?[selectedSubject]?.isNotEmpty == true)
                      ? widget.lessonsMap![selectedSubject]!.first["name"]
                      : null;
                });
              },
            ),
            const SizedBox(height: 16),
            CreateDropdown(
              value: selectedSubject,
              items: (selectedClass != null && subjectsMap[selectedClass] != null)
                  ? subjectsMap[selectedClass]!
                  : [],
              hint: "Select Subject",
              onChanged: (value) {
                setState(() {
                  selectedSubject = value;
                  selectedLesson = (value != null && widget.lessonsMap?[value]?.isNotEmpty == true)
                      ? widget.lessonsMap![value]!.first["name"]
                      : null;
                });
              },
            ),
            const SizedBox(height: 16),
            CreateDropdown(
              value: selectedLesson,
              items: (widget.editIndex != null && widget.initialSubject != null && widget.lessonsMap?[widget.initialSubject] != null)
                  ? widget.lessonsMap![widget.initialSubject]!.map((lesson) => lesson["name"]!).toList()
                  : (selectedSubject != null && widget.lessonsMap?[selectedSubject] != null)
                  ? widget.lessonsMap![selectedSubject]!.map((lesson) => lesson["name"]!).toList()
                  : [],
              hint: "Select Lesson",
              onChanged: (value) => setState(() => selectedLesson = value),
            ),
            const SizedBox(height: 16),
            TopicTextFields(
              nameController: topicNameController,
              descriptionController: topicDescriptionController,
              nameLabel: "Topic Name",
              descriptionLabel: "Description",
            ),
            const SizedBox(height: 16),
            FilePickerButton(
              filePath: selectedFilePath,
              onPickFile: () => pickFile(
                context: context,
                onFilePicked: (filePath) {
                  setState(() {
                    selectedFilePath = filePath;
                  });
                },
              ),
              uploadText: "Upload File",
              buttonColor: AppColors.white,
              iconColor: AppColors.primaryColor,
              textColor: AppColors.primaryColor,
            ),
            const SizedBox(height: 16),
            CustomButton(
              onPressed: saveTopic,
              buttonText: widget.editIndex != null ? 'Update Topic' : 'Save Topic',
              backgroundColor: AppColors.primaryColor,
              textColor: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }
}