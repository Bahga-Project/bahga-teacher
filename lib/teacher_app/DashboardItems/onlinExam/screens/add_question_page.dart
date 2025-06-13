import 'package:flutter/material.dart';
import '../../../../Refactoration/common_widgets.dart';
import '../models/question.dart';

class AddQuestionPage extends StatefulWidget {
  final Function(Question) onAdd;
  final Question? question;

  const AddQuestionPage({Key? key, required this.onAdd, this.question}) : super(key: key);

  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _type = 'multiple_choice';
  final _option1Controller = TextEditingController();
  final _option2Controller = TextEditingController();
  final _option3Controller = TextEditingController();
  final _option4Controller = TextEditingController();
  String _correctAnswer = '';
  String? _questionId;

  @override
  void initState() {
    super.initState();
    if (widget.question != null) {
      _questionId = widget.question!.id;
      _questionController.text = widget.question!.text;
      _type = widget.question!.type;
      _correctAnswer = widget.question!.correctAnswer;
      if (_type == 'multiple_choice' && widget.question!.options != null && widget.question!.options!.length >= 4) {
        _option1Controller.text = widget.question!.options![0];
        _option2Controller.text = widget.question!.options![1];
        _option3Controller.text = widget.question!.options![2];
        _option4Controller.text = widget.question!.options![3];
      }
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _descriptionController.dispose();
    _option1Controller.dispose();
    _option2Controller.dispose();
    _option3Controller.dispose();
    _option4Controller.dispose();
    super.dispose();
  }

  void _submitQuestion() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus(); // Hide keyboard
      widget.onAdd(Question(
        id: _questionId ?? DateTime.now().toString(),
        text: _questionController.text.trim(),
        type: _type,
        options: _type == 'multiple_choice'
            ? [
          _option1Controller.text.trim(),
          _option2Controller.text.trim(),
          _option3Controller.text.trim(),
          _option4Controller.text.trim(),
        ]
            : null,
        correctAnswer: _correctAnswer,
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: widget.question != null ? 'Edit Question' : 'Add Question',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0).copyWith(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.0, // Handle keyboard
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TopicTextFields(
                nameController: _questionController,
                descriptionController: _descriptionController,
                nameLabel: 'Question Text',
                descriptionLabel: 'Description (Optional)',
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButtonFormField<String>(
                  value: _type,
                  items: [
                    DropdownMenuItem(value: 'multiple_choice', child: Text('Multiple Choice')),
                    DropdownMenuItem(value: 'true_false', child: Text('True/False')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _type = value!;
                      _correctAnswer = ''; // Reset correct answer when type changes
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Question Type',
                    border: InputBorder.none,
                  ),
                  validator: (value) => value == null ? 'Please select a type' : null,
                ),
              ),
              if (_type == 'multiple_choice') ...[
                SizedBox(height: 20),
                TopicTextFields(
                  nameController: _option1Controller,
                  descriptionController: _option2Controller,
                  nameLabel: 'Option 1',
                  descriptionLabel: 'Option 2',
                ),
                SizedBox(height: 20),
                TopicTextFields(
                  nameController: _option3Controller,
                  descriptionController: _option4Controller,
                  nameLabel: 'Option 3',
                  descriptionLabel: 'Option 4',
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButtonFormField<String>(
                    value: _correctAnswer.isEmpty ? null : _correctAnswer,
                    items: [
                      _option1Controller.text,
                      _option2Controller.text,
                      _option3Controller.text,
                      _option4Controller.text,
                    ].where((option) => option.isNotEmpty).toList()
                        .map((option) => DropdownMenuItem(value: option, child: Text(option)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _correctAnswer = value ?? '';
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Correct Answer',
                      border: InputBorder.none,
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Please select a correct answer' : null,
                  ),
                ),
              ] else ...[
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButtonFormField<String>(
                    value: _correctAnswer.isEmpty ? null : _correctAnswer,
                    items: ['True', 'False']
                        .map((option) => DropdownMenuItem(value: option, child: Text(option)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _correctAnswer = value ?? '';
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Correct Answer',
                      border: InputBorder.none,
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Please select a correct answer' : null,
                  ),
                ),
              ],
              SizedBox(height: 20),
              CustomButton(
                buttonText: widget.question != null ? 'Update Question' : 'Add Question',
                onPressed: _submitQuestion,
              ),
            ],
          ),
        ),
      ),
    );
  }
}