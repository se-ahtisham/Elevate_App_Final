// review_model.dart
// NLP-analyzed review of a Company written by a JobSeeker.
// Collection: 'reviews' — doc ID = reviewID.

class ReviewModel {
  final String reviewID;
  final String companyID;
  final String reviewerID;
  final double rating; // 1.0 to 5.0
  final String rawReview;
  final List<String> analyzedStrengths;
  final List<String> analyzedWeaknesses;
  final String sentiment; // 'Positive' | 'Neutral' | 'Negative'
  final bool isFirstTime;
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
