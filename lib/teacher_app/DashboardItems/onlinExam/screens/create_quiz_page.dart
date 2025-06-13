import 'package:flutter/material.dart';
import 'package:gp_sprint1/teacher_app/DashboardItems/onlinExam/screens/add_question_page.dart';
import 'package:gp_sprint1/teacher_app/DashboardItems/onlinExam/screens/preview_quiz_page.dart';
import '../../../../Refactoration/common_widgets.dart';
import '../models/data.dart';
import '../models/quiz.dart';
import '../models/question.dart';


class CreateQuizPage extends StatefulWidget {
  final Quiz? quiz;

  const CreateQuizPage({Key? key, this.quiz}) : super(key: key);

  @override
  _CreateQuizPageState createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _titleDescriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _durationDescriptionController = TextEditingController();
  String? selectedLevel;
  String? selectedClass;
  String? selectedSubject;
  List<Question> questions = [];
  final QuizDataStructure data = QuizDataStructure();
  String? _quizId;

  @override
  void initState() {
    super.initState();
    if (widget.quiz != null) {
      _quizId = widget.quiz!.id;
      _titleController.text = widget.quiz!.title;
      selectedLevel = widget.quiz!.semesterName;
      selectedClass = widget.quiz!.grade;
      selectedSubject = widget.quiz!.subject;
      _durationController.text = widget.quiz!.duration.toString();
      questions = List.from(widget.quiz!.questions);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.quiz != null ? 'Edit Quiz' : 'Create Quiz',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TopicTextFields(
                nameController: _titleController,
                descriptionController: _titleDescriptionController,
                nameLabel: 'Quiz Title',
                descriptionLabel: 'Optional Description',
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      clipBehavior: Clip.hardEdge,
                      child: CreateDropdown(
                        value: selectedLevel,
                        items: data.levelClasses.keys.toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedLevel = value;
                            selectedClass = null;
                            selectedSubject = null;
                          });
                        },
                        hint: 'Select Level',
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      clipBehavior: Clip.hardEdge,
                      child: CreateDropdown(
                        value: selectedClass,
                        items: selectedLevel != null ? data.levelClasses[selectedLevel]! : [],
                        onChanged: (value) {
                          setState(() {
                            selectedClass = value;
                            selectedSubject = null;
                          });
                        },
                        hint: 'Select Class',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CreateDropdown(
                  value: selectedSubject,
                  items: selectedClass != null ? data.classSubjects[selectedClass]! : [],
                  onChanged: (value) {
                    setState(() {
                      selectedSubject = value;
                    });
                  },
                  hint: 'Select Subject',
                ),
              ),
              SizedBox(height: 20),
              TopicTextFields(
                nameController: _durationController,
                descriptionController: _durationDescriptionController,
                nameLabel: 'Duration (Minutes)',
                descriptionLabel: 'Optional Notes',

              ),
              SizedBox(height: 20),
              CustomButton(
                buttonText: 'Add Question',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddQuestionPage(
                        onAdd: (question) {
                          setState(() {
                            questions.add(question);
                            print('Question added: ${question.text}');
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              ...questions.asMap().entries.map((entry) {
                final index = entry.key;
                final q = entry.value;
                return ListTile(
                  title: Text(q.text),
                  subtitle: Text('Type: ${q.type}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddQuestionPage(
                                question: q,
                                onAdd: (updatedQuestion) {
                                  setState(() {
                                    questions[index] = updatedQuestion;
                                    print('Question updated: ${updatedQuestion.text}');
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            questions.removeAt(index);
                            print('Question removed: ${q.text}');
                          });
                        },
                      ),
                    ],
                  ),
                );
              }),
              SizedBox(height: 20),
              CustomButton(
                buttonText: 'Preview & Submit',
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      selectedLevel != null &&
                      selectedClass != null &&
                      selectedSubject != null) {
                    final quiz = Quiz(
                      id: _quizId ?? DateTime.now().toString(),
                      title: _titleController.text,
                      subject: selectedSubject!,
                      grade: selectedClass!,
                      semesterName: selectedLevel!,
                      duration: int.parse(_durationController.text),
                      questions: questions,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PreviewQuizPage(quiz: quiz, isEditing: widget.quiz != null),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please complete all fields')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}