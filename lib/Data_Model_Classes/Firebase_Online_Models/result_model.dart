class ResultModel {
  final String resultID;
  final String jobSeekerID;
  final String testID;
  final double score;
  final bool isPassed;
  final DateTime startedAt;
  final DateTime completedAt;
  final int timeTakenSeconds;
  final int attemptNumber;
  final DateTime lastAttemptAt;
  final DateTime? cooldownUntil; // locked if both attempts failed
  final String experienceLevel; // Intern/Mid/Advanced
  final String? badgeEarned; // FK Badge, nullable

  ResultModel({
    required this.resultID,
    required this.jobSeekerID,
    required this.testID,
    this.score = 0,
    this.isPassed = false,
    DateTime? startedAt,
    DateTime? completedAt,
    this.timeTakenSeconds = 0,
    this.attemptNumber = 1,
    DateTime? lastAttemptAt,
    this.cooldownUntil,
    this.experienceLevel = 'Intern',
    this.badgeEarned,
  }) : startedAt = startedAt ?? DateTime.now(),
       completedAt = completedAt ?? DateTime.now(),
       lastAttemptAt = lastAttemptAt ?? DateTime.now();

  // "canRetake(skillID)" pure check — true once cooldown has expired.
  bool get isRetakeAllowedNow =>
      cooldownUntil == null || DateTime.now().isAfter(cooldownUntil!);

  Map<String, dynamic> toMap() {
    return {
      'resultID': resultID,
      'jobSeekerID': jobSeekerID,
      'testID': testID,
      'score': score,
      'isPassed': isPassed,
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt.toIso8601String(),
      'timeTakenSeconds': timeTakenSeconds,
      'attemptNumber': attemptNumber,
      'lastAttemptAt': lastAttemptAt.toIso8601String(),
      'cooldownUntil': cooldownUntil?.toIso8601String(),
      'experienceLevel': experienceLevel,
      'badgeEarned': badgeEarned,
    };
  }

  factory ResultModel.fromMap(Map<String, dynamic> map) {
    return ResultModel(
      resultID: map['resultID'] ?? '',
      jobSeekerID: map['jobSeekerID'] ?? '',
      testID: map['testID'] ?? '',
      score: (map['score'] ?? 0).toDouble(),
      isPassed: map['isPassed'] ?? false,
      startedAt: map['startedAt'] != null
          ? DateTime.tryParse(map['startedAt'])
          : DateTime.now(),
      completedAt: map['completedAt'] != null
          ? DateTime.tryParse(map['completedAt'])
          : DateTime.now(),
      timeTakenSeconds: map['timeTakenSeconds'] ?? 0,
      attemptNumber: map['attemptNumber'] ?? 1,
      lastAttemptAt: map['lastAttemptAt'] != null
          ? DateTime.tryParse(map['lastAttemptAt'])
          : DateTime.now(),
      cooldownUntil: map['cooldownUntil'] != null
          ? DateTime.tryParse(map['cooldownUntil'])
          : null,
      experienceLevel: map['experienceLevel'] ?? 'Intern',
      badgeEarned: map['badgeEarned'],
    );
  }
}
