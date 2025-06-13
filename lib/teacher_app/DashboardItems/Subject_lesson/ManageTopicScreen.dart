import 'package:flutter/material.dart';
import '/../Refactoration/Colors.dart';
import 'CreateTopicScreen.dart';
import 'TopicCard.dart';
import '/../Refactoration/common_widgets.dart';

class ManageTopicScreen extends StatefulWidget {
  final Map<String, List<Map<String, String?>>> lessonsMap;
  final String? initialLevel;
  final String? initialClass;
  final String? initialSubject;
  final String? initialLesson;

  const ManageTopicScreen({
    super.key,
    required this.lessonsMap,
    this.initialLevel,
    this.initialClass,
    this.initialSubject,
    this.initialLesson,
  });

  @override
  State<ManageTopicScreen> createState() => _ManageTopicScreenState();
}

class _ManageTopicScreenState extends State<ManageTopicScreen> {
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
  Map<String, List<Map<String, String?>>> topicsMap = {};
  String? selectedLevel;
  String? selectedClass;
  String? selectedSubject;
  String? selectedLesson;

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
        widget.lessonsMap[selectedSubject] == null ||
        !widget.lessonsMap[selectedSubject]!.any((lesson) => lesson["name"] == selectedLesson)) {
      selectedLesson = (selectedSubject != null && widget.lessonsMap[selectedSubject]?.isNotEmpty == true)
          ? widget.lessonsMap[selectedSubject]!.first["name"]
          : null;
    }
  }

  void modifyTopic({
    required String lesson,
    required Map<String, String?> topicData,
    int? index,
    bool isDelete = false,
  }) {
    setState(() {
      if (isDelete && index != null) {
        topicsMap[lesson]?.removeAt(index);
      } else if (index != null) {
        topicsMap[lesson]![index] = topicData;
      } else {
        topicsMap[lesson] ??= [];
        topicsMap[lesson]!.add(topicData);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Manage Topic',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Container(
        color: AppColors.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              selectedLesson = null;
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
                              selectedLesson = (selectedSubject != null &&
                                  widget.lessonsMap[selectedSubject]?.isNotEmpty == true)
                                  ? widget.lessonsMap[selectedSubject]!.first["name"]
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
                          items: subjectsMap[selectedClass] ?? [],
                          itemToString: (item) => item,
                          onChanged: (value) {
                            setState(() {
                              selectedSubject = value;
                              selectedLesson = (value != null &&
                                  widget.lessonsMap[value]?.isNotEmpty == true)
                                  ? widget.lessonsMap[value]!.first["name"]
                                  : null;
                            });
                          },
                          isExpanded: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.center,
                    child: ManageDropdown<String>(
                      value: selectedLesson,
                      items: (selectedSubject != null && widget.lessonsMap[selectedSubject] != null)
                          ? widget.lessonsMap[selectedSubject]!.map((lesson) => lesson["name"]!).toList()
                          : [],
                      itemToString: (item) => item,
                      onChanged: (value) {
                        setState(() {
                          selectedLesson = value;
                        });
                      },
                      width: 200,
                      isExpanded: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Topic List',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedLesson != null && topicsMap[selectedLesson] != null
                      ? topicsMap[selectedLesson]!.length
                      : 0,
                  itemBuilder: (context, index) {
                    if (selectedLesson == null || topicsMap[selectedLesson] == null) {
                      return const SizedBox();
                    }

                    var topic = topicsMap[selectedLesson!]![index];

                    return TopicCard(
                      title: topic["name"] ?? "No Title",
                      description: topic["description"] ?? "",
                      filePath: topic["filePath"],
                      onDelete: () {
                        modifyTopic(
                          lesson: selectedLesson!,
                          topicData: {},
                          index: index,
                          isDelete: true,
                        );
                      },
                      onEdit: () async {
                        dynamic result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTopicScreen(
                              initialLevel: selectedLevel,
                              initialClass: selectedClass,
                              initialSubject: selectedSubject,
                              initialLesson: selectedLesson,
                              initialTitle: topic["name"],
                              initialDescription: topic["description"],
                              initialFilePath: topic["filePath"],
                              editIndex: index,
                            ),
                          ),
                        );
                        if (result != null && result is Map) {
                          setState(() {
                            selectedLevel = result["level"];
                            selectedClass = result["class"];
                            selectedSubject = result["subject"];
                            selectedLesson = result["lesson"];
                            modifyTopic(
                              lesson: result["lesson"],
                              topicData: result["topicData"],
                              index: result["editIndex"],
                            );
                          });
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                buttonText: 'Create Topic',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateTopicScreen(
                        initialLevel: selectedLevel,
                        initialClass: selectedClass,
                        initialSubject: selectedSubject,
                        initialLesson: selectedLesson,
                        lessonsMap: widget.lessonsMap,
                      ),
                    ),
                  ).then((result) {
                    if (result != null && result is Map) {
                      setState(() {
                        selectedLevel = result["level"];
                        selectedClass = result["class"];
                        selectedSubject = result["subject"];
                        selectedLesson = result["lesson"];
                        modifyTopic(
                          lesson: result["lesson"],
                          topicData: result["topicData"],
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