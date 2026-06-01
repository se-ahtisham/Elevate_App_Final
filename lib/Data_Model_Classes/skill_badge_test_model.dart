class SkillModel {
  final String skillID; // PK
  final String skillName;
  final String skillDescription;
  final String skillImage; // URL
  final String category;
  final DateTime createdAt;

  SkillModel({
    required this.skillID,
    required this.skillName,
    this.skillDescription = '',
    this.skillImage = '',
    this.category = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'skillID': skillID,
      'skillName': skillName,
      'skillDescription': skillDescription,
      'skillImage': skillImage,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SkillModel.fromMap(Map<String, dynamic> map) {
    return SkillModel(
      skillID: map['skillID'] ?? '',
      skillName: map['skillName'] ?? '',
      skillDescription: map['skillDescription'] ?? '',
      skillImage: map['skillImage'] ?? '',
      category: map['category'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
//  BADGE  (all fields from draw.io diagram)
//
//  Firebase collection: badges/
//  Admin creates badges. Earned badges go into JobSeeker's earnedBadges list.
// ─────────────────────────────────────────────────────────────────

class BadgeModel {
  final String badgeID; // PK
  final String badgeName;
  final String badgeLevel; // 'Bronze' | 'Silver' | 'Gold'
  final double requiredScore; // 0.0 – 100.0
  final String badgeImage; // URL

  BadgeModel({
    required this.badgeID,
    required this.badgeName,
    this.badgeLevel = 'Bronze',
    this.requiredScore = 0.0,
    this.badgeImage = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'badgeID': badgeID,
      'badgeName': badgeName,
      'badgeLevel': badgeLevel,
      'requiredScore': requiredScore,
      'badgeImage': badgeImage,
    };
  }

  factory BadgeModel.fromMap(Map<String, dynamic> map) {
    return BadgeModel(
      badgeID: map['badgeID'] ?? '',
      badgeName: map['badgeName'] ?? '',
      badgeLevel: map['badgeLevel'] ?? 'Bronze',
      requiredScore: (map['requiredScore'] ?? 0.0).toDouble(),
      badgeImage: map['badgeImage'] ?? '',
    );
  }
}

// ─────────────────────────────────────────────────────────────────
//  TEST  (all fields from draw.io diagram)
//
//  Firebase collection: tests/
//  Admin creates tests. Each test is linked to a Skill.
// ─────────────────────────────────────────────────────────────────

class TestModel {
  final String testID; // PK
  final String testName;
  final String testType; // 'Vibe' | 'Pure' | 'Experience'
  final int totalQuestions;
  final int durationMinutes;
  final double passingScore;
  final List<Map<String, dynamic>> questions; // list of question objects
  final String skillID; // FK → skills/

  TestModel({
    required this.testID,
    required this.testName,
    this.testType = 'Pure',
    this.totalQuestions = 0,
    this.durationMinutes = 30,
    this.passingScore = 60.0,
    this.questions = const [],
    this.skillID = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'testID': testID,
      'testName': testName,
      'testType': testType,
      'totalQuestions': totalQuestions,
      'durationMinutes': durationMinutes,
      'passingScore': passingScore,
      'questions': questions,
      'skillID': skillID,
    };
  }

  factory TestModel.fromMap(Map<String, dynamic> map) {
    return TestModel(
      testID: map['testID'] ?? '',
      testName: map['testName'] ?? '',
      testType: map['testType'] ?? 'Pure',
      totalQuestions: map['totalQuestions'] ?? 0,
      durationMinutes: map['durationMinutes'] ?? 30,
      passingScore: (map['passingScore'] ?? 60.0).toDouble(),
      questions: List<Map<String, dynamic>>.from(map['questions'] ?? []),
      skillID: map['skillID'] ?? '',
    );
  }
}

// ─────────────────────────────────────────────────────────────────
//  JOB SEEKER SKILL TEST RESULT  (all fields from draw.io diagram)
//
//  Firebase collection: skillTestResults/
//  JobSeeker stores resultID in mySkillTestsList.
//
//  🧠 Business Rules (from diagram):
//  - A seeker can attempt a test MAX 2 times
//  - If both attempts fail → cooldownUntil is set (locked period)
//  - canRetake() tells us if they're allowed to try again
// ─────────────────────────────────────────────────────────────────

class JobSeekerSkillTestModel {
  final String resultID; // PK
  final String jobSeekerID; // FK → users/
  final String testID; // FK → tests/
  final double score;
  final bool isPassed;
  final String? badgeEarned; // FK → badges/ (null if not passed)
  final DateTime startedAt;
  final DateTime completedAt;
  final int timeTakenSeconds;
  final int attemptNumber;
  final DateTime lastAttemptAt;
  final DateTime? cooldownUntil; // null = no cooldown active

  JobSeekerSkillTestModel({
    required this.resultID,
    required this.jobSeekerID,
    required this.testID,
    this.score = 0.0,
    this.isPassed = false,
    this.badgeEarned,
    DateTime? startedAt,
    DateTime? completedAt,
    this.timeTakenSeconds = 0,
    this.attemptNumber = 1,
    DateTime? lastAttemptAt,
    this.cooldownUntil,
  }) : startedAt = startedAt ?? DateTime.now(),
       completedAt = completedAt ?? DateTime.now(),
       lastAttemptAt = lastAttemptAt ?? DateTime.now();

  // 🧠 Business rule: can seeker retake this test?
  bool canRetake() {
    if (cooldownUntil != null && DateTime.now().isBefore(cooldownUntil!)) {
      return false; // Still in cooldown — locked!
    }
    return true;
  }

  Map<String, dynamic> toMap() {
    return {
      'resultID': resultID,
      'jobSeekerID': jobSeekerID,
      'testID': testID,
      'score': score,
      'isPassed': isPassed,
      'badgeEarned': badgeEarned,
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt.toIso8601String(),
      'timeTakenSeconds': timeTakenSeconds,
      'attemptNumber': attemptNumber,
      'lastAttemptAt': lastAttemptAt.toIso8601String(),
      'cooldownUntil': cooldownUntil?.toIso8601String(),
    };
  }

  factory JobSeekerSkillTestModel.fromMap(Map<String, dynamic> map) {
    return JobSeekerSkillTestModel(
      resultID: map['resultID'] ?? '',
      jobSeekerID: map['jobSeekerID'] ?? '',
      testID: map['testID'] ?? '',
      score: (map['score'] ?? 0.0).toDouble(),
      isPassed: map['isPassed'] ?? false,
      badgeEarned: map['badgeEarned'],
      startedAt: map['startedAt'] != null
          ? DateTime.parse(map['startedAt'])
          : DateTime.now(),
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'])
          : DateTime.now(),
      timeTakenSeconds: map['timeTakenSeconds'] ?? 0,
      attemptNumber: map['attemptNumber'] ?? 1,
      lastAttemptAt: map['lastAttemptAt'] != null
          ? DateTime.parse(map['lastAttemptAt'])
          : DateTime.now(),
      cooldownUntil: map['cooldownUntil'] != null
          ? DateTime.parse(map['cooldownUntil'])
          : null,
    );
  }
}
