import 'package:flutter/material.dart';
import '/../Refactoration/Colors.dart';
import 'ManageTopicScreen.dart';
import '/../Refactoration/common_widgets.dart';
import '/../Refactoration/utils.dart';

class LessonCard extends StatefulWidget {
  final String title;
  final String description;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? viewTopics;
  final String? selectedClass;
  final String? selectedSubject;
  final String? selectedLevel;
  final List<String> levelsList;

  const LessonCard({
    required this.title,
    required this.description,
    required this.onDelete,
    this.onEdit,
    this.viewTopics,
    this.selectedClass,
    this.selectedSubject,
    this.selectedLevel,
    required this.levelsList,
    super.key,
  });

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> {
  ValueNotifier<bool> isExpanded = ValueNotifier(false);
  String? selectedLevel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => showOptionsDialog(
        context: context,
        onDelete: widget.onDelete,
        onEdit: widget.onEdit,
      ),
      child: GenericCard(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (widget.description.isNotEmpty)
                Text(
                  widget.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.formTextColor,
                  ),
                ),
              const SizedBox(height: 8),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: widget.viewTopics ??
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ManageTopicScreen(lessonsMap: {},
                                ),
                              ),
                            );
                          },
                      child: const Text(
                        'View Topics',
                        style: TextStyle(color: AppColors.white),
                      ),
                    ),
                    const SizedBox(height: 8),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
