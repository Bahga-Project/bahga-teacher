class Question {
  final String id;
  final String text;
  final String type;
  final List<String>? options;
  final String correctAnswer;

  Question({
    required this.id,
    required this.text,
    required this.type,
    this.options,
    required this.correctAnswer,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'type': type,
    'options': options,
    'correctAnswer': correctAnswer,
  };

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json['id'],
    text: json['text'],
    type: json['type'],
    options: json['options'] != null ? List<String>.from(json['options']) : null,
    correctAnswer: json['correctAnswer'],
  );
}