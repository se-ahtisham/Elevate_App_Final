class AdminModel {
  final String adminID;
  final String name;
  final String email;
  final String password;
  final String userType;

  AdminModel({
    required this.adminID,
    this.name = '',
    this.email = '',
    this.password = '',
    this.userType = 'Admin',
  });

  Map<String, dynamic> toMap() {
    return {
      'adminID': adminID,
      'name': name,
      'email': email,
      'password': password,
      'userType': userType,
    };
  }

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      adminID: map['adminID'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      userType: map['userType'] ?? 'Admin',
    );
  }
}
