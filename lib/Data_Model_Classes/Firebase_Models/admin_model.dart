// admin_model.dart
// Admin entity — was completely missing from original project.
// Collection: 'admins' — doc ID matches userID.

class AdminModel {
  final String userID;
  final String adminLevel; // 'SuperAdmin' | 'Moderator'
  final List<String> permissions; // e.g. ['manageUsers','manageBadges','manageTests','manageSkills']
  final DateTime lastActiveAt;
  final int totalActionsPerformed;

  AdminModel({
    required this.userID,
    this.adminLevel = 'Moderator',
    this.permissions = const [],
    DateTime? lastActiveAt,
    this.totalActionsPerformed = 0,
  }) : lastActiveAt = lastActiveAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'adminLevel': adminLevel,
      'permissions': permissions,
      'lastActiveAt': lastActiveAt.toIso8601String(),
      'totalActionsPerformed': totalActionsPerformed,
    };
  }

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      userID: map['userID'] ?? '',
      adminLevel: map['adminLevel'] ?? 'Moderator',
      permissions: List<String>.from(map['permissions'] ?? []),
      lastActiveAt: map['lastActiveAt'] != null
          ? DateTime.parse(map['lastActiveAt'])
          : DateTime.now(),
      totalActionsPerformed: map['totalActionsPerformed'] ?? 0,
    );
  }
}
