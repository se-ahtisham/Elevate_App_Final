// user_model.dart
// Base User model — shared by JobSeeker, Company, Admin.
// password is stored in Firestore so the user can read/update it themselves.

class UserModel {
  final String userID;
  final String name;
  final String email;
  final String password; // stored in Firestore; user manages this themselves
  final String userType; // 'JobSeeker' | 'Company' | 'Admin'
  final String profilePic;
  final String location;
  final String about;
  final String securityQuestion;
  final String securityAnswer;
  final DateTime createdAt;

  UserModel({
    required this.userID,
    required this.name,
    required this.email,
    required this.password,
    required this.userType,
    this.profilePic = '',
    this.location = '',
    this.about = '',
    this.securityQuestion = '',
    this.securityAnswer = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'name': name,
      'email': email,
      'password': password,
      'userType': userType,
      'profilePic': profilePic,
      'location': location,
      'about': about,
      'securityQuestion': securityQuestion,
      'securityAnswer': securityAnswer,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userID: map['userID'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      userType: map['userType'] ?? '',
      profilePic: map['profilePic'] ?? '',
      location: map['location'] ?? '',
      about: map['about'] ?? '',
      securityQuestion: map['securityQuestion'] ?? '',
      securityAnswer: map['securityAnswer'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }
}
