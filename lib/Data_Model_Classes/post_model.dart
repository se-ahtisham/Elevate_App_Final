class CommentModel {
  final String commentText;
  final String authorID; // FK → users/ (who wrote this comment)
  final String authorName;
  final DateTime timeDate;

  CommentModel({
    required this.commentText,
    required this.authorID,
    required this.authorName,
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

// ─────────────────────────────────────────────────────────────────
//  POST  (Community / Feed — all fields from draw.io diagram)
//
//  Firebase collection: posts/
//  JobSeeker stores postID in their postList.
// ─────────────────────────────────────────────────────────────────

class PostModel {
  final String postID; // PK
  final String authorID; // FK → users/
  final String authorName;
  final String authorProfilePic; // URL
  final String authorType; // 'JobSeeker' | 'Company'
  final String title;
  final String content;
  final int likes;
  final int totalCommentCount;
  final List<CommentModel> comments; // stored inline in the post document
  final DateTime createdAt;

  PostModel({
    required this.postID,
    required this.authorID,
    required this.authorName,
    this.authorProfilePic = '',
    this.authorType = 'JobSeeker',
    this.title = '',
    this.content = '',
    this.likes = 0,
    this.totalCommentCount = 0,
    this.comments = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'postID': postID,
      'authorID': authorID,
      'authorName': authorName,
      'authorProfilePic': authorProfilePic,
      'authorType': authorType,
      'title': title,
      'content': content,
      'likes': likes,
      'totalCommentCount': totalCommentCount,
      'comments': comments.map((c) => c.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postID: map['postID'] ?? '',
      authorID: map['authorID'] ?? '',
      authorName: map['authorName'] ?? '',
      authorProfilePic: map['authorProfilePic'] ?? '',
      authorType: map['authorType'] ?? 'JobSeeker',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      likes: map['likes'] ?? 0,
      totalCommentCount: map['totalCommentCount'] ?? 0,
      comments: (map['comments'] as List<dynamic>? ?? [])
          .map((c) => CommentModel.fromMap(c as Map<String, dynamic>))
          .toList(),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }
}
