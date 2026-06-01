class ReviewModel {
  final String reviewID; // PK
  final String companyID; // FK → users/
  final String reviewerID; // FK → users/ (the JobSeeker)
  final double rating; // 1.0 – 5.0
  final String rawReview; // the actual text the user wrote
  final List<String> analyzedStrengths; // extracted by NLP
  final List<String> analyzedWeaknesses; // extracted by NLP
  final String sentiment; // 'Positive' | 'Neutral' | 'Negative'
  final bool isFirstTime; // true if first review of this company
  final DateTime reviewDate;

  ReviewModel({
    required this.reviewID,
    required this.companyID,
    required this.reviewerID,
    this.rating = 3.0,
    this.rawReview = '',
    this.analyzedStrengths = const [],
    this.analyzedWeaknesses = const [],
    this.sentiment = 'Neutral',
    this.isFirstTime = true,
    DateTime? reviewDate,
  }) : reviewDate = reviewDate ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'reviewID': reviewID,
      'companyID': companyID,
      'reviewerID': reviewerID,
      'rating': rating,
      'rawReview': rawReview,
      'analyzedStrengths': analyzedStrengths,
      'analyzedWeaknesses': analyzedWeaknesses,
      'sentiment': sentiment,
      'isFirstTime': isFirstTime,
      'reviewDate': reviewDate.toIso8601String(),
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      reviewID: map['reviewID'] ?? '',
      companyID: map['companyID'] ?? '',
      reviewerID: map['reviewerID'] ?? '',
      rating: (map['rating'] ?? 3.0).toDouble(),
      rawReview: map['rawReview'] ?? '',
      analyzedStrengths: List<String>.from(map['analyzedStrengths'] ?? []),
      analyzedWeaknesses: List<String>.from(map['analyzedWeaknesses'] ?? []),
      sentiment: map['sentiment'] ?? 'Neutral',
      isFirstTime: map['isFirstTime'] ?? true,
      reviewDate: map['reviewDate'] != null
          ? DateTime.parse(map['reviewDate'])
          : DateTime.now(),
    );
  }
}
