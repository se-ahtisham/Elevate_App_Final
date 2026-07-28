class CompanyModel {
  final String companyID;
  final String email;
  final String password;
  final String userType; // 'Company'
  final String companyName;
  final String industry;
  final String website;
  final String logo;
  final String description;
  final String location;
  final int companySize;
  final int activeJobs;
  final int followersCount;
  final List<String> followers; // jobSeekerIDs who follow this company
  final List<String> followRequests; // requestIDs -> FollowRequestModel
  final List<String> employeeList; // employeeIDs
  final List<String> companyWeaknessList; // AI-derived,
  final List<String> companyStrengthList; // AI-derived
  final List<String> achievementList;
  final List<String> receivedApplications; // applicationIDs
  final List<String> postedJobs; // jobIDs

  CompanyModel({
    required this.companyID,
    this.email = '',
    this.password = '',
    this.userType = 'Company',
    this.companyName = '',
    this.industry = '',
    this.website = '',
    this.logo = '',
    this.description = '',
    this.location = '',
    this.companySize = 0,
    this.activeJobs = 0,
    this.followersCount = 0,
    this.followers = const [],
    this.followRequests = const [],
    this.employeeList = const [],
    this.companyWeaknessList = const [],
    this.companyStrengthList = const [],
    this.achievementList = const [],
    this.receivedApplications = const [],
    this.postedJobs = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'companyID': companyID,
      'email': email,
      'password': password,
      'userType': userType,
      'companyName': companyName,
      'industry': industry,
      'website': website,
      'logo': logo,
      'description': description,
      'location': location,
      'companySize': companySize,
      'activeJobs': activeJobs,
      'followersCount': followersCount,
      'followers': followers,
      'followRequests': followRequests,
      'employeeList': employeeList,
      'companyWeaknessList': companyWeaknessList,
      'companyStrengthList': companyStrengthList,
      'achievementList': achievementList,
      'receivedApplications': receivedApplications,
      'postedJobs': postedJobs,
    };
  }

  factory CompanyModel.fromMap(Map<String, dynamic> map) {
    return CompanyModel(
      companyID: map['companyID'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      userType: map['userType'] ?? 'Company',
      companyName: map['companyName'] ?? '',
      industry: map['industry'] ?? '',
      website: map['website'] ?? '',
      logo: map['logo'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      companySize: map['companySize'] ?? 0,
      activeJobs: map['activeJobs'] ?? 0,
      followersCount: map['followersCount'] ?? 0,
      followers: List<String>.from(map['followers'] ?? []),
      followRequests: List<String>.from(map['followRequests'] ?? []),
      employeeList: List<String>.from(map['employeeList'] ?? []),
      companyWeaknessList: List<String>.from(map['companyWeaknessList'] ?? []),
      companyStrengthList: List<String>.from(map['companyStrengthList'] ?? []),
      achievementList: List<String>.from(map['achievementList'] ?? []),
      receivedApplications: List<String>.from(
        map['receivedApplications'] ?? [],
      ),
      postedJobs: List<String>.from(map['postedJobs'] ?? []),
    );
  }

  CompanyModel copyWith({
    String? companyName,
    String? industry,
    String? website,
    String? logo,
    String? description,
    String? location,
    int? companySize,
    int? activeJobs,
    int? followersCount,
    List<String>? followers,
    List<String>? followRequests,
    List<String>? employeeList,
    List<String>? companyWeaknessList,
    List<String>? companyStrengthList,
    List<String>? achievementList,
    List<String>? receivedApplications,
    List<String>? postedJobs,
  }) {
    return CompanyModel(
      companyID: companyID,
      email: email,
      userType: userType,
      companyName: companyName ?? this.companyName,
      industry: industry ?? this.industry,
      website: website ?? this.website,
      logo: logo ?? this.logo,
      description: description ?? this.description,
      location: location ?? this.location,
      companySize: companySize ?? this.companySize,
      activeJobs: activeJobs ?? this.activeJobs,
      followersCount: followersCount ?? this.followersCount,
      followers: followers ?? this.followers,
      followRequests: followRequests ?? this.followRequests,
      employeeList: employeeList ?? this.employeeList,
      companyWeaknessList: companyWeaknessList ?? this.companyWeaknessList,
      companyStrengthList: companyStrengthList ?? this.companyStrengthList,
      achievementList: achievementList ?? this.achievementList,
      receivedApplications: receivedApplications ?? this.receivedApplications,
      postedJobs: postedJobs ?? this.postedJobs,
    );
  }
}
