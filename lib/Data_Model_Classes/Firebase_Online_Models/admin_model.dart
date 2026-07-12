// admin_model.dart — matches "Admin Panel" class in the diagram.

class AdminModel {
  final String adminID; // PK
  final String name;
  final String email;
  final String userType; // 'Admin'

  AdminModel({
    required this.adminID,
    this.name = '',
    this.email = '',
    this.userType = 'Admin',
  });

  Map<String, dynamic> toMap() {
    return {
      'adminID': adminID,
      'name': name,
      'email': email,
      'userType': userType,
    };
  }

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      adminID: map['adminID'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      userType: map['userType'] ?? 'Admin',
    );
  }
}
