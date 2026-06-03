// Badge model — earned by JobSeeker after passing a skill test

class BadgeModel {
  final String badgeID;
  final String badgeName;
  final String badgeLevel; // 'Bronze', 'Silver', 'Gold'
  final double requiredScore; // 0 to 100
  final String badgeImage;

  BadgeModel({
    required this.badgeID,
    this.badgeName = '',
    this.badgeLevel = 'Bronze',
    this.requiredScore = 0,
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
      requiredScore: (map['requiredScore'] ?? 0).toDouble(),
      badgeImage: map['badgeImage'] ?? '',
    );
  }
}
