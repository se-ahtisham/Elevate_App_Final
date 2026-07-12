import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/question_model.dart';

class TestModel {
  final String testID;
  final String testName;
  final String skillID;
  final String testType; // Vibe/Pure/Experience
  final int totalQuestions;
  final int durationMinutes;
  final double passingScore;
  final List<QuestionModel> questions;

  TestModel({
    required this.testID,
    required this.skillID,
    this.testName = '',
    this.testType = 'Pure',
    this.totalQuestions = 0,
    this.durationMinutes = 30,
    this.passingScore = 60,
    this.questions = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'testID': testID,
      'testName': testName,
      'skillID': skillID,
      'testType': testType,
      'totalQuestions': totalQuestions,
      'durationMinutes': durationMinutes,
      'passingScore': passingScore,
      'questions': questions.map((q) => q.toMap()).toList(),
    };
  }

  factory TestModel.fromMap(Map<String, dynamic> map) {
    return TestModel(
      testID: map['testID'] ?? '',
      testName: map['testName'] ?? '',
      skillID: map['skillID'] ?? '',
      testType: map['testType'] ?? 'Pure',
      totalQuestions: map['totalQuestions'] ?? 0,
      durationMinutes: map['durationMinutes'] ?? 30,
      passingScore: (map['passingScore'] ?? 60).toDouble(),
      questions: (map['questions'] as List<dynamic>? ?? [])
          .map((q) => QuestionModel.fromMap(Map<String, dynamic>.from(q)))
          .toList(),
    );
  }
}
