class QuestionModel {
  final String questionID;
  final String questionText;
  final List<String> options; // empty for open-ended/coding questions
  final String correctAnswer; // '' for AI-graded free-response/coding
  final int marks;

  QuestionModel({
    required this.questionID,
    required this.questionText,
    this.options = const [],
    this.correctAnswer = '',
    this.marks = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'questionID': questionID,
      'questionText': questionText,
      'options': options,
      'correctAnswer': correctAnswer,
      'marks': marks,
    };
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      questionID: map['questionID'] ?? '',
      questionText: map['questionText'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctAnswer: map['correctAnswer'] ?? '',
      marks: map['marks'] ?? 1,
    );
  }
}