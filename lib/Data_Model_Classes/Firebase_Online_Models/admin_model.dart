// admin_model.dart
// Admin entity — was completely missing from original project.
// Collection: 'admins' — doc ID matches userID.

class AdminModel {
  final String userID;
  final List<String> permissions; // e.g. ['manageUsers','manageBadges','manageTests','manageSkills']

  AdminModel({required this.userID, this.permissions = const []});

  Map<String, dynamic> toMap() {
    return {'userID': userID, 'permissions': permissions};
  }

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      userID: map['userID'] ?? '',
      permissions: List<String>.from(map['permissions'] ?? []),
    );
  }
}
