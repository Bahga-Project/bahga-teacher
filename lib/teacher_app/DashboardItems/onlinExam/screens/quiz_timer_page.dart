import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../Refactoration/common_widgets.dart';
import '../models/quiz.dart';


class QuizTimerPage extends StatefulWidget {
  final Quiz quiz;

  const QuizTimerPage({Key? key, required this.quiz}) : super(key: key);

  @override
  _QuizTimerPageState createState() => _QuizTimerPageState();
}

class _QuizTimerPageState extends State<QuizTimerPage> {
  late int _remainingSeconds;
  late Timer _timer;
  bool _isTimeUp = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.quiz.duration * 60; // Convert minutes to seconds
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        setState(() {
          _isTimeUp = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Quiz Timer',
        showBackButton: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.quiz.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              _isTimeUp ? 'Quiz Time Ended!' : 'Time Remaining',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              _isTimeUp ? '00:00' : _formatTime(_remainingSeconds),
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CustomButton(
              buttonText: 'End Quiz',
              onPressed: () {
                _timer.cancel();
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushNamed(context, '/quizList');
              },
            ),
          ],
        ),
      ),
    );
  }
}