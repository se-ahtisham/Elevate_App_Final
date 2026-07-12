class CommentModel {
  final String commentID;
  final String postID;
  final String authorID;
  final String authorName;
  final String commentText;
  final DateTime createdAt;

  CommentModel({
    required this.commentID,
    required this.postID,
    required this.authorID,
    this.authorName = '',
    this.commentText = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'commentID': commentID,
      'postID': postID,
      'authorID': authorID,
      'authorName': authorName,
      'commentText': commentText,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentID: map['commentID'] ?? '',
      postID: map['postID'] ?? '',
      authorID: map['authorID'] ?? '',
      authorName: map['authorName'] ?? '',
      commentText: map['commentText'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'])
          : DateTime.now(),
    );
  }
}
