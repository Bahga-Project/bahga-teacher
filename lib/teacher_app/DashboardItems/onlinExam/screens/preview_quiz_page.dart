import 'package:flutter/material.dart';
import '../../../../Refactoration/common_widgets.dart';
import '../models/quiz.dart';
import '../services/notification_service.dart';
import '../services/quiz_data.dart';


class PreviewQuizPage extends StatelessWidget {
  final Quiz quiz;
  final bool isEditing;

  const PreviewQuizPage({Key? key, required this.quiz, this.isEditing = false}) : super(key: key);

  void _submitQuiz(BuildContext context) {
    if (isEditing) {
      QuizData.updateQuiz(quiz);
      NotificationService().showNotification(
        'Quiz Updated',
        'Quiz "${quiz.title}" has been updated successfully!',
      );
    } else {
      QuizData.addQuiz(quiz);
      NotificationService().showNotification(
        'New Quiz Created',
        'Quiz "${quiz.title}" is now available for exams!',
      );
    }
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushNamed(context, '/quizList');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Preview Quiz',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              GenericCard(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Title: ${quiz.title}', style: TextStyle(fontSize: 18)),
                      Text('Subject: ${quiz.subject}'),
                      Text('Class: ${quiz.grade}'),
                      Text('Level: ${quiz.semesterName}'),
                      Text('Duration: ${quiz.duration} minutes'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Questions:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ...quiz.questions.map((q) => GenericCard(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(q.text, style: TextStyle(fontSize: 16)),
                      Text('Type: ${q.type}'),
                      if (q.options != null) Text('Options: ${q.options!.join(", ")}'),
                      Text('Correct: ${q.correctAnswer}'),
                    ],
                  ),
                ),
              )),
              SizedBox(height: 20),
              CustomButton(
                buttonText: isEditing ? 'Update Quiz' : 'Submit Quiz',
                onPressed: () => _submitQuiz(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}