class UserModel {
  final String userID; // PK — same as Firebase Auth uid
  final String name;
  final String email;
  final String password; // user sets this; Firebase Auth is the real source
  final String userType; // 'JobSeeker' | 'Company' | 'Admin'
  final String profilePic; // URL to image
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

  // toMap() → converts this object to a Map so Firebase can store it
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

  // fromMap() → reads data from Firebase and creates a UserModel object
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
