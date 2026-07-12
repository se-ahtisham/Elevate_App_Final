// UserIndexModel is a small model that tells your app what type of user has logged in, so it knows which Firestore collection to use.
/*
Without UserIndexModel
Login
   ↓
Check JobSeekers
   ↓
Not found
   ↓
Check Companies
   ↓
Not found
   ↓
Check Admins


With UserIndexModel
Login
   ↓
Check userIndex
   ↓
userType = Company
   ↓
Open Companies collection */

class UserIndexModel {
  final String userID; // == Firebase Auth uid
  final String email;
  final String userType; // JobSeeker/Company/Admin

  UserIndexModel({
    required this.userID,
    required this.email,
    required this.userType,
  });

  Map<String, dynamic> toMap() {
    return {'userID': userID, 'email': email, 'userType': userType};
  }

  factory UserIndexModel.fromMap(Map<String, dynamic> map) {
    return UserIndexModel(
      userID: map['userID'] ?? '',
      email: map['email'] ?? '',
      userType: map['userType'] ?? '',
    );
  }
}
