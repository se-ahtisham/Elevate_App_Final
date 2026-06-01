import 'user_model.dart';


class CompanyModel extends UserModel {
  final String companyName;
  final String industry;
  final String website;           // URL
  final String logo;              // URL
  final String description;
  final int companySize;
  final int activeJobs;
  final int followers;

  final List<String> employeeList;          // employeeIDs → collection: employees/
  final List<String> companyWeaknessList;   // weakness strings (from NLP review analysis)
  final List<String> companyStrengthList;   // strength strings (from NLP review analysis)
  final List<String> achievementList;       // achievement strings
  final List<String> receivedApplications;  // applicationIDs → collection: applications/
  final List<String> postedJobs;            // jobIDs → collection: jobs/

  CompanyModel({
    required super.userID,
    required super.name,
    required super.email,
    required super.password,
    super.profilePic,
    super.location,
    super.about,
    super.securityQuestion,
    super.securityAnswer,
    this.companyName = '',
    this.industry = '',
    this.website = '',
    this.logo = '',
    this.description = '',
    this.companySize = 0,
    this.activeJobs = 0,
    this.followers = 0,
    this.employeeList = const [],
    this.companyWeaknessList = const [],
    this.companyStrengthList = const [],
    this.achievementList = const [],
    this.receivedApplications = const [],
    this.postedJobs = const [],
  }) : super(userType: 'Company');

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'companyName': companyName,
      'industry': industry,
      'website': website,
      'logo': logo,
      'description': description,
      'companySize': companySize,
      'activeJobs': activeJobs,
      'followers': followers,
      'employeeList': employeeList,
      'companyWeaknessList': companyWeaknessList,
      'companyStrengthList': companyStrengthList,
      'achievementList': achievementList,
      'receivedApplications': receivedApplications,
      'postedJobs': postedJobs,
    });
    return map;
  }

  factory CompanyModel.fromMap(Map<String, dynamic> map) {
    return CompanyModel(
      userID: map['userID'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      profilePic: map['profilePic'] ?? '',
      location: map['location'] ?? '',
      about: map['about'] ?? '',
      securityQuestion: map['securityQuestion'] ?? '',
      securityAnswer: map['securityAnswer'] ?? '',
      companyName: map['companyName'] ?? '',
      industry: map['industry'] ?? '',
      website: map['website'] ?? '',
      logo: map['logo'] ?? '',
      description: map['description'] ?? '',
      companySize: map['companySize'] ?? 0,
      activeJobs: map['activeJobs'] ?? 0,
      followers: map['followers'] ?? 0,
      employeeList: List<String>.from(map['employeeList'] ?? []),
      companyWeaknessList: List<String>.from(map['companyWeaknessList'] ?? []),
      companyStrengthList: List<String>.from(map['companyStrengthList'] ?? []),
      achievementList: List<String>.from(map['achievementList'] ?? []),
      receivedApplications: List<String>.from(map['receivedApplications'] ?? []),
      postedJobs: List<String>.from(map['postedJobs'] ?? []),
    );
  }
}
