class PostModel {
  final String postID;
  final String authorID; //  JobSeeker or Company ID
  final String authorName;
  final String authorProfilePic;
  final String authorType; // JobSeeker/Company
  final String title;
  final String content;
  final int likes;
  final List<String> likedByUserIDs; // needed so likePost() can be toggled
  final int totalCommentCount;
  final DateTime createdAt;

  PostModel({
    required this.postID,
    required this.authorID,
    this.authorName = '',
    this.authorProfilePic = '',
    this.authorType = 'JobSeeker',
    this.title = '',
    this.content = '',
    this.likes = 0,
    this.likedByUserIDs = const [],
    this.totalCommentCount = 0,
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
      'likedByUserIDs': likedByUserIDs,
      'totalCommentCount': totalCommentCount,
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
      likedByUserIDs: List<String>.from(map['likedByUserIDs'] ?? []),
      totalCommentCount: map['totalCommentCount'] ?? 0,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'])
          : DateTime.now(),
    );
  }
}
