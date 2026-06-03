// post_model.dart
// Community/Feed post by a JobSeeker or Company.
// Collection: 'posts' — doc ID = postID.
// Comments are embedded inside each post document as a list.

import 'comment_model.dart';

class PostModel {
  final String postID;
  final DateTime createdAt;
  final String title;
  final String content;
  final String authorID;
  final String authorName;
  final String authorProfilePic;
  final String authorType; // 'JobSeeker' | 'Company'
  final int likes;
  final int totalCommentCount;
  final List<CommentModel> comments;

  PostModel({
    required this.postID,
    this.title = '',
    this.content = '',
    this.authorID = '',
    this.authorName = '',
    this.authorProfilePic = '',
    this.authorType = 'JobSeeker',
    this.likes = 0,
    this.totalCommentCount = 0,
    this.comments = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'postID': postID,
      'createdAt': createdAt.toIso8601String(),
      'title': title,
      'content': content,
      'authorID': authorID,
      'authorName': authorName,
      'authorProfilePic': authorProfilePic,
      'authorType': authorType,
      'likes': likes,
      'totalCommentCount': totalCommentCount,
      'comments': comments.map((c) => c.toMap()).toList(),
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postID: map['postID'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      authorID: map['authorID'] ?? '',
      authorName: map['authorName'] ?? '',
      authorProfilePic: map['authorProfilePic'] ?? '',
      authorType: map['authorType'] ?? 'JobSeeker',
      likes: map['likes'] ?? 0,
      totalCommentCount: map['totalCommentCount'] ?? 0,
      comments: (map['comments'] as List? ?? [])
          .map((c) => CommentModel.fromMap(c as Map<String, dynamic>))
          .toList(),
    );
  }
}
