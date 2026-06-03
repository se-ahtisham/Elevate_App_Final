// JobSeekerSkillTest — stores the result after a JobSeeker takes a test

class JobSeekerSkillTestModel {
  final String resultID;
  final String jobSeekerID;
  final String testID;
  final double score;
  final bool isPassed;
  final String badgeEarnedID; // empty if no badge earned
  final DateTime startedAt;
  final DateTime completedAt;
  final int timeTakenSeconds;
  final int attemptNumber;
  final DateTime lastAttemptAt;
  final DateTime? cooldownUntil; // null if not locked
  final String experienceLevel; // 'Intern', 'Mid', 'Advanced'

  JobSeekerSkillTestModel({
    required this.resultID,
    required this.jobSeekerID,
    required this.testID,
    this.score = 0,
    this.isPassed = false,
    this.badgeEarnedID = '',
    DateTime? startedAt,
    DateTime? completedAt,
    this.timeTakenSeconds = 0,
    this.attemptNumber = 1,
    DateTime? lastAttemptAt,
    this.cooldownUntil,
    this.experienceLevel = 'Intern',
  })  : startedAt = startedAt ?? DateTime.now(),
        completedAt = completedAt ?? DateTime.now(),
        lastAttemptAt = lastAttemptAt ?? DateTime.now();

  // Can the user retake this test?
  bool canRetake() {
    if (isPassed) return false; // already passed, no need to retake
    if (attemptNumber < 2) return true; // still has attempts left
    if (cooldownUntil == null) return true;
    return DateTime.now().isAfter(cooldownUntil!); // cooldown expired
  }

  Map<String, dynamic> toMap() {
    return {
      'resultID': resultID,
      'jobSeekerID': jobSeekerID,
      'testID': testID,
      'score': score,
      'isPassed': isPassed,
      'badgeEarnedID': badgeEarnedID,
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt.toIso8601String(),
      'timeTakenSeconds': timeTakenSeconds,
      'attemptNumber': attemptNumber,
      'lastAttemptAt': lastAttemptAt.toIso8601String(),
      'cooldownUntil': cooldownUntil?.toIso8601String(),
      'experienceLevel': experienceLevel,
    };
  }

  factory JobSeekerSkillTestModel.fromMap(Map<String, dynamic> map) {
    return JobSeekerSkillTestModel(
      resultID: map['resultID'] ?? '',
      jobSeekerID: map['jobSeekerID'] ?? '',
      testID: map['testID'] ?? '',
      score: (map['score'] ?? 0).toDouble(),
      isPassed: map['isPassed'] ?? false,
      badgeEarnedID: map['badgeEarnedID'] ?? '',
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
      experienceLevel: map['experienceLevel'] ?? 'Intern',
    );
  }
}
