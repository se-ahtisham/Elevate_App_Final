// comment_model.dart
// Comment entity — shown as a separate model in the diagram.
// Comments are stored as a list inside each POST document in Firestore.

class CommentModel {
  final String commentText;
  final String authorID;
  final String authorName;
  final DateTime timeDate;

  CommentModel({
    this.commentText = '',
    this.authorID = '',
    this.authorName = '',
    DateTime? timeDate,
  }) : timeDate = timeDate ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'commentText': commentText,
      'authorID': authorID,
      'authorName': authorName,
      'timeDate': timeDate.toIso8601String(),
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentText: map['commentText'] ?? '',
      authorID: map['authorID'] ?? '',
      authorName: map['authorName'] ?? '',
      timeDate: map['timeDate'] != null
          ? DateTime.parse(map['timeDate'])
          : DateTime.now(),
    );
  }
}
