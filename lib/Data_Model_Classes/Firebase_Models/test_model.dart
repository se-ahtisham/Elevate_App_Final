// Test model — skill test created by Admin, linked to a Skill

class TestModel {
  final String testID;
  final String testName;
  final String skillID; // which skill this test belongs to
  final String testType; // 'Vibe', 'Pure', 'Experience'
  final int totalQuestions;
  final int durationMinutes;
  final double passingScore;
  final List<Map<String, dynamic>> questions; // list of question maps

  TestModel({
    required this.testID,
    this.testName = '',
    this.skillID = '',
    this.testType = 'Pure',
    this.totalQuestions = 0,
    this.durationMinutes = 30,
    this.passingScore = 70,
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
      'questions': questions,
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
      passingScore: (map['passingScore'] ?? 70).toDouble(),
      questions: List<Map<String, dynamic>>.from(map['questions'] ?? []),
    );
  }
}
