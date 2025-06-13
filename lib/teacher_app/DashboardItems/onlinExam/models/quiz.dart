
import 'package:gp_sprint1/teacher_app/DashboardItems/onlinExam/models/question.dart';
import 'package:flutter/foundation.dart';

class Quiz {
  final String id;
  final String title;
  final String subject;
  final String grade;
  final String semesterName;
  final int duration;
  final List<Question> questions;
  DateTime? startTime;

  Quiz({
    required this.id,
    required this.title,
    required this.subject,
    required this.grade,
    required this.semesterName,
    required this.duration,
    required this.questions,
    this.startTime,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subject': subject,
    'grade': grade,
    'semesterName': semesterName,
    'duration': duration,
    'questions': questions.map((q) => q.toJson()).toList(),
    'startTime': startTime?.toIso8601String(),
  };

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
    id: json['id'],
    title: json['title'],
    subject: json['subject'],
    grade: json['grade'],
    semesterName: json['semesterName'],
    duration: json['duration'],
    questions: (json['questions'] as List).map((q) => Question.fromJson(q)).toList(),
    startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
  );
}