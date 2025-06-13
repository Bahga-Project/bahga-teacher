import '../models/quiz.dart';


class QuizData {
  static final List<Quiz> _quizzes = [];

  static List<Quiz> getQuizzes() {
    print('Fetching quizzes: ${_quizzes.length} quizzes found');
    return _quizzes;
  }

  static void addQuiz(Quiz quiz) {
    _quizzes.add(quiz);
    print('Quiz added: ${quiz.title}, ID: ${quiz.id}, Total quizzes: ${_quizzes.length}');
  }

  static void deleteQuiz(String id) {
    _quizzes.removeWhere((quiz) => quiz.id == id);
    print('Quiz deleted, ID: $id, Total quizzes: ${_quizzes.length}');
  }

  static void updateQuiz(Quiz updatedQuiz) {
    final index = _quizzes.indexWhere((quiz) => quiz.id == updatedQuiz.id);
    if (index != -1) {
      _quizzes[index] = updatedQuiz;
      print('Quiz updated: ${updatedQuiz.title}, ID: ${updatedQuiz.id}');
    }
  }

  static void updateQuizStartTime(String id, DateTime startTime) {
    final index = _quizzes.indexWhere((quiz) => quiz.id == id);
    if (index != -1) {
      _quizzes[index].startTime = startTime;
      print('Quiz start time updated, ID: $id, Start Time: $startTime');
    }
  }
}