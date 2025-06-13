import 'package:flutter/material.dart';

import '../../../Refactoration/Colors.dart';
import '../../../Refactoration/utils.dart';
import '/../Refactoration/common_widgets.dart';
import 'timetable_data.dart';


class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  _TimetableScreenState createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  late String selectedDay;

  @override
  void initState() {
    super.initState();
    selectedDay = getCurrentDay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Timetable",
        showBackButton: true,
      ),
      body: Column(
        children: [
          Container(
            height: 55,
            color: AppColors.backgroundColor,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildDayTab("Sun"),
                  _buildDayTab("Mon"),
                  _buildDayTab("Tue"),
                  _buildDayTab("Wed"),
                  _buildDayTab("Thu"),
                  _buildDayTab("Fri"),
                  _buildDayTab("Sat"),
                ],
              ),
            ),
          ),
          Expanded(
            child: timetableData[selectedDay]!.isEmpty
                ? Center(
              child: Text(
                (selectedDay == "Fri" || selectedDay == "Sat")
                    ? "Holiday"
                    : "No classes for this day",
                style: const TextStyle(fontSize: 16, color: AppColors.textColor_2),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: timetableData[selectedDay]!.length,
              itemBuilder: (context, index) {
                final entry = timetableData[selectedDay]![index];
                return Column(
                  children: [
                    TimetableCard(
                      startTime: entry.startTime,
                      endTime: entry.endTime,
                      subject: entry.subject,
                      className: entry.className,
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayTab(String day) {
    bool isSelected = selectedDay == day;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDay = day;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            day,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight:isSelected ?  FontWeight.bold:FontWeight.w500,
              fontSize: isSelected ?16:14 ,
            ),
          ),
        ),
      ),
    );
  }
}