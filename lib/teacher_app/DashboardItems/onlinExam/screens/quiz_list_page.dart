import 'package:flutter/material.dart';
import 'package:gp_sprint1/Refactoration/Colors.dart';
import 'package:gp_sprint1/teacher_app/DashboardItems/onlinExam/screens/quiz_timer_page.dart';
import '../../../../Refactoration/common_widgets.dart';
import '../services/quiz_data.dart';
import 'create_quiz_page.dart';
import 'preview_quiz_page.dart';

class QuizListPage extends StatefulWidget {
  @override
  _QuizListPageState createState() => _QuizListPageState();
}

class _QuizListPageState extends State<QuizListPage> {
  void _deleteQuiz(BuildContext context, String id) {
    QuizData.deleteQuiz(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final quizzes = QuizData.getQuizzes();
    print('Building QuizListPage, quizzes count: ${quizzes.length}');
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Quizzes',
        showBackButton: true,
      ),
      body: quizzes.isEmpty
          ? Center(child: Text('No quizzes available'))
          : ListView.builder(
        itemCount: quizzes.length,
        itemBuilder: (context, index) {
          final quiz = quizzes[index];
          return GenericCard(
            child: ListTile(
              title: Text(quiz.title),
              subtitle: Text('${quiz.subject} - ${quiz.grade} - ${quiz.semesterName}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateQuizPage(quiz: quiz),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => OptionsDialog(
                          title: 'Confirm Delete',
                          actions: [
                            CustomButton(
                              buttonText: 'Cancel',
                              onPressed: () => Navigator.pop(context),
                            ),
                            CustomButton(
                              buttonText: 'Delete',
                              onPressed: () {
                                _deleteQuiz(context, quiz.id);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: () {
                      QuizData.updateQuizStartTime(quiz.id, DateTime.now());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizTimerPage(quiz: quiz),
                        ),
                      );
                    },
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreviewQuizPage(quiz: quiz),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}