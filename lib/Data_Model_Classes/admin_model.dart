import 'user_model.dart';

class AdminModel extends UserModel {
  AdminModel({
    required super.userID,
    required super.name,
    required super.email,
    required super.password,
    super.profilePic,
    super.location,
    super.about,
    super.securityQuestion,
    super.securityAnswer,
  }) : super(userType: 'Admin');

  @override
  Map<String, dynamic> toMap() {
    return super.toMap();
  }

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      userID: map['userID'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      profilePic: map['profilePic'] ?? '',
      location: map['location'] ?? '',
      about: map['about'] ?? '',
      securityQuestion: map['securityQuestion'] ?? '',
      securityAnswer: map['securityAnswer'] ?? '',
    );
  }
}
