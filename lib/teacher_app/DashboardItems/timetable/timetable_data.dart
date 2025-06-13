// lib/data/timetable_data.dart
import 'package:flutter/material.dart';

class TimetableEntry {
  final String startTime;
  final String endTime;
  final String subject;
  final String className;

  TimetableEntry({
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.className,
  });
}

final Map<String, List<TimetableEntry>> timetableData = {
  "Sun": [],
  "Mon": [
    TimetableEntry(startTime: "08:00 AM", endTime: "09:00 AM", subject: "Math", className: "3 C"),
    TimetableEntry(startTime: "09:00 AM", endTime: "10:00 AM", subject: "English", className: "1 B"),
    TimetableEntry(startTime: "10:00 AM", endTime: "11:00 PM", subject: "Arabic", className: "2 A"),
    TimetableEntry(startTime: "12:00 PM", endTime: "01:00 PM", subject: "Biology", className: "2 C"),
    TimetableEntry(startTime: "1:00 AM", endTime: "02:00 PM", subject: "Physics", className: "2 A"),
    TimetableEntry(startTime: "12:00 PM", endTime: "01:00 PM", subject: "Arabic", className: "2 C"),
  ],
  "Tue": [
    TimetableEntry(startTime: "08:00 AM", endTime: "09:30 AM", subject: "English", className: "3 A"),
    TimetableEntry(startTime: "10:00 AM", endTime: "11:00 AM", subject: "English", className: "2 B"),
  ],
  "Wed": [
    TimetableEntry(startTime: "09:00 AM", endTime: "10:30 AM", subject: "English", className: "1 C"),
  ],
  "Thu": [
    TimetableEntry(startTime: "07:30 AM", endTime: "09:00 AM", subject: "English", className: "3 B"),
    TimetableEntry(startTime: "10:00 AM", endTime: "11:30 AM", subject: "English", className: "2 A"),
    TimetableEntry(startTime: "12:30 PM", endTime: "01:30 PM", subject: "English", className: "2 C"),
  ],
  "Fri": [],
  "Sat": [

    TimetableEntry(startTime: "09:00 AM", endTime: "10:00 AM", subject: "English", className: "1 B"),
    TimetableEntry(startTime: "08:00 AM", endTime: "09:00 AM", subject: "Math", className: "3 C"),
    TimetableEntry(startTime: "12:00 PM", endTime: "01:00 PM", subject: "Biology", className: "2 C"),
    TimetableEntry(startTime: "10:00 AM", endTime: "11:00 PM", subject: "Arabic", className: "2 A"),
    TimetableEntry(startTime: "1:00 AM", endTime: "02:00 PM", subject: "Physics", className: "2 A"),
    TimetableEntry(startTime: "09:00 AM", endTime: "10:00 AM", subject: "English", className: "1 B"),
    TimetableEntry(startTime: "12:00 PM", endTime: "01:00 PM", subject: "Arabic", className: "2 C"),
  ],
};