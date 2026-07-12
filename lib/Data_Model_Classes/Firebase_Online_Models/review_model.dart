class ReviewModel {
  final String reviewID;
  final String companyID;
  final String jobSeekerID; // author (must be a verified ex/employee)
  final double rating; // 1-5
  final String text;
  final String sentiment; // Positive/Neutral/Negative — AI-derived
  final DateTime createdAt;

  ReviewModel({
    required this.reviewID,
    required this.companyID,
    required this.jobSeekerID,
    this.rating = 0,
    this.text = '',
    this.sentiment = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'reviewID': reviewID,
      'companyID': companyID,
      'jobSeekerID': jobSeekerID,
      'rating': rating,
      'text': text,
      'sentiment': sentiment,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      reviewID: map['reviewID'] ?? '',
      companyID: map['companyID'] ?? '',
      jobSeekerID: map['jobSeekerID'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      text: map['text'] ?? '',
      sentiment: map['sentiment'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'])
          : DateTime.now(),
    );
  }
}
