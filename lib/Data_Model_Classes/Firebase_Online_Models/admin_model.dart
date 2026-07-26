class AdminModel {
  final String adminID;
  final String name;
  final String email;
  final String password;
  final String userType;
  final String about;
  final String location;
  final String profilePic;

  AdminModel({
    required this.adminID,
    this.name = '',
    this.email = '',
    this.password = '',
    this.userType = 'Admin',
    this.about = '',
    this.location = '',
    this.profilePic = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'adminID': adminID,
      'name': name,
      'email': email,
      'password': password,
      'userType': userType,
      'about': about,
      'location': location,
      'profilePic': profilePic,
    };
  }

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      adminID: map['adminID'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      userType: map['userType'] ?? 'Admin',
      about: map['about'] ?? '',
      location: map['location'] ?? '',
      profilePic: map['profilePic'] ?? '',
    );
  }
}
