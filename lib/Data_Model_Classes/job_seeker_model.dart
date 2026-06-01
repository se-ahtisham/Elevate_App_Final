import 'user_model.dart';

class JobSeekerModel extends UserModel {

  final String phone;
  final String shortDescription;
  final String experienceLevel;   // 'Junior' | 'Mid' | 'Senior'
  final int skillCount;
  final int totalTestsTaken;
  final int totalBadgesEarned;

  final List<String> following;           // userIDs this seeker follows
  final List<String> followers;           // userIDs that follow this seeker
  final List<String> followedCompanies;   // companyIDs followed
  final List<String> followRequests;      // requestIDs of pending follow requests
  final List<String> portfolioList;       // portfolioIDs  → collection: portfolios/
  final List<String> postList;            // postIDs       → collection: posts/
  final List<String> mySkillTestsList;    // resultIDs     → collection: skillTestResults/
  final List<String> earnedBadges;        // badgeIDs      → collection: badges/
  final List<String> careerGuidanceTasks; // taskIDs       → collection: careerTasks/
  final List<String> appliedJobRequests;  // applicationIDs → collection: applications/
  final List<String> becomeEmployee;      // employeeRequest IDs → collection: employees/
  final List<String> reviewedCompanies;   // companyIDs already reviewed (to prevent double review)

  JobSeekerModel({
    required super.userID,
    required super.name,
    required super.email,
    required super.password,
    super.profilePic,
    super.location,
    super.about,
    super.securityQuestion,
    super.securityAnswer,
    this.phone = '',
    this.shortDescription = '',
    this.experienceLevel = 'Junior',
    this.skillCount = 0,
    this.totalTestsTaken = 0,
    this.totalBadgesEarned = 0,
    this.following = const [],
    this.followers = const [],
    this.followedCompanies = const [],
    this.followRequests = const [],
    this.portfolioList = const [],
    this.postList = const [],
    this.mySkillTestsList = const [],
    this.earnedBadges = const [],
    this.careerGuidanceTasks = const [],
    this.appliedJobRequests = const [],
    this.becomeEmployee = const [],
    this.reviewedCompanies = const [],
  }) : super(userType: 'JobSeeker');

  @override
  Map<String, dynamic> toMap() {
    // Start with parent (UserModel) fields
    final map = super.toMap();
    // Then add JobSeeker-specific fields
    map.addAll({
      'phone': phone,
      'shortDescription': shortDescription,
      'experienceLevel': experienceLevel,
      'skillCount': skillCount,
      'totalTestsTaken': totalTestsTaken,
      'totalBadgesEarned': totalBadgesEarned,
      'following': following,
      'followers': followers,
      'followedCompanies': followedCompanies,
      'followRequests': followRequests,
      'portfolioList': portfolioList,
      'postList': postList,
      'mySkillTestsList': mySkillTestsList,
      'earnedBadges': earnedBadges,
      'careerGuidanceTasks': careerGuidanceTasks,
      'appliedJobRequests': appliedJobRequests,
      'becomeEmployee': becomeEmployee,
      'reviewedCompanies': reviewedCompanies,
    });
    return map;
  }

  factory JobSeekerModel.fromMap(Map<String, dynamic> map) {
    return JobSeekerModel(
      userID: map['userID'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      profilePic: map['profilePic'] ?? '',
      location: map['location'] ?? '',
      about: map['about'] ?? '',
      securityQuestion: map['securityQuestion'] ?? '',
      securityAnswer: map['securityAnswer'] ?? '',
      phone: map['phone'] ?? '',
      shortDescription: map['shortDescription'] ?? '',
      experienceLevel: map['experienceLevel'] ?? 'Junior',
      skillCount: map['skillCount'] ?? 0,
      totalTestsTaken: map['totalTestsTaken'] ?? 0,
      totalBadgesEarned: map['totalBadgesEarned'] ?? 0,
      following: List<String>.from(map['following'] ?? []),
      followers: List<String>.from(map['followers'] ?? []),
      followedCompanies: List<String>.from(map['followedCompanies'] ?? []),
      followRequests: List<String>.from(map['followRequests'] ?? []),
      portfolioList: List<String>.from(map['portfolioList'] ?? []),
      postList: List<String>.from(map['postList'] ?? []),
      mySkillTestsList: List<String>.from(map['mySkillTestsList'] ?? []),
      earnedBadges: List<String>.from(map['earnedBadges'] ?? []),
      careerGuidanceTasks: List<String>.from(map['careerGuidanceTasks'] ?? []),
      appliedJobRequests: List<String>.from(map['appliedJobRequests'] ?? []),
      becomeEmployee: List<String>.from(map['becomeEmployee'] ?? []),
      reviewedCompanies: List<String>.from(map['reviewedCompanies'] ?? []),
    );
  }
}
