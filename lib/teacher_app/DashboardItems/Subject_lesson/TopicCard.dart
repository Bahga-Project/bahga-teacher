// topic_card.dart
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import '/../../Refactoration/common_widgets.dart';
import '/../../Refactoration/Colors.dart';
import '/../../Refactoration/utils.dart';

class TopicCard extends StatefulWidget {
  final String title;
  final String description;
  final String? filePath;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;

  const TopicCard({
    required this.title,
    required this.description,
    this.filePath,
    required this.onDelete,
    this.onEdit,
    super.key,
  });

  @override
  State<TopicCard> createState() => _TopicCardState();
}

class _TopicCardState extends State<TopicCard> {
  ValueNotifier<bool> isExpanded = ValueNotifier(false);


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
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              if (widget.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    widget.description,
                    style: const TextStyle(fontSize: 14, color: AppColors.formTextColor),
                  ),
                ),
              const SizedBox(height: 8),
              ValueListenableBuilder<bool>(
                valueListenable: isExpanded,
                builder: (context, expanded, child) {
                  return ExpandableSection(
                    isExpanded: expanded,
                    onToggle: () => isExpanded.value = !isExpanded.value,
                    collapsedContent: const SizedBox.shrink(),
                    expandedContent: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(color: AppColors.primaryColor),
                          const Text(
                            "Study Material:",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          if (widget.filePath != null && widget.filePath!.isNotEmpty)
                            GestureDetector(
                              onTap: () => openFile(context, widget.filePath),
                              child: Text(
                                path.basename(widget.filePath!),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.materialColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            )
                          else
                            const Text(
                              "No study material available.",
                              style: TextStyle(fontSize: 14, color: AppColors.formTextColor),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}