

class BadgeModel {
  final String badgeID; 
  final String skillID; 
  final String badgeName;
  final String badgeLevel; // Bronze/Silver/Gold
  final double requiredScore; // 0-100
  final String badgeImage; // URL

  BadgeModel({
    required this.badgeID,
    required this.skillID,
    this.badgeName = '',
    this.badgeLevel = 'Bronze',
    this.requiredScore = 0,
    this.badgeImage = '',
  });

  // "checkEligibility(score)" from the diagram — pure function, no DB call.
  bool checkEligibility(double score) => score >= requiredScore;

  Map<String, dynamic> toMap() {
    return {
      'badgeID': badgeID,
      'skillID': skillID,
      'badgeName': badgeName,
      'badgeLevel': badgeLevel,
      'requiredScore': requiredScore,
      'badgeImage': badgeImage,
    };
  }

  factory BadgeModel.fromMap(Map<String, dynamic> map) {
    return BadgeModel(
      badgeID: map['badgeID'] ?? '',
      skillID: map['skillID'] ?? '',
      badgeName: map['badgeName'] ?? '',
      badgeLevel: map['badgeLevel'] ?? 'Bronze',
      requiredScore: (map['requiredScore'] ?? 0).toDouble(),
      badgeImage: map['badgeImage'] ?? '',
    );
  }
}
