class BadgeModel {
  final String badgeID;
  final String badgeName;
  final String badgeLevel; // Bronze/Silver/Gold
  final double minScore; // inclusive lower bound, e.g. 50, 60, 90
  final double maxScore; // exclusive upper bound, except top tier is inclusive
  final String badgeImage; // URL

  BadgeModel({
    required this.badgeID,
    this.badgeName = '',
    this.badgeLevel = 'Bronze',
    this.minScore = 0,
    this.maxScore = 100,
    this.badgeImage = '',
  });

  // Half-open ranges (50-60, 60-90) so a boundary score like 60 only
  // matches one badge; the top tier (90-100) is inclusive on both ends
  // so a perfect 100 still qualifies.
  bool checkEligibility(double score) {
    if (maxScore >= 100) {
      return score >= minScore && score <= maxScore;
    }
    return score >= minScore && score < maxScore;
  }

  Map<String, dynamic> toMap() {
    return {
      'badgeID': badgeID,
      'badgeName': badgeName,
      'badgeLevel': badgeLevel,
      'minScore': minScore,
      'maxScore': maxScore,
      'badgeImage': badgeImage,
    };
  }

  factory BadgeModel.fromMap(Map<String, dynamic> map) {
    return BadgeModel(
      badgeID: map['badgeID'] ?? '',
      badgeName: map['badgeName'] ?? '',
      badgeLevel: map['badgeLevel'] ?? 'Bronze',
      minScore: (map['minScore'] ?? 0).toDouble(),
      maxScore: (map['maxScore'] ?? 100).toDouble(),
      badgeImage: map['badgeImage'] ?? '',
    );
  }
}
