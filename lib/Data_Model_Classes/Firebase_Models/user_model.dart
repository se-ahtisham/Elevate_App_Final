class UserModel {
  final String userID;
  final String name;
  final String email;
  final String password;
  final String userType; // JobSeeker, Company, Admin
  final String profilePic;
  final String location;
  final String about;
  final String securityQuestion;
  final String securityAnswer;

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
  });

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
    );
  }
}
