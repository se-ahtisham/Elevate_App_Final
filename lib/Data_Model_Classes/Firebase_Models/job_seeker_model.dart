// job_seeker_model.dart
// JobSeeker model — extends USER fields with extra profile data.

class JobSeekerModel {
  final String userID;
  final String phone;
  final String shortDescription;
  final String experienceLevel; // 'Junior' | 'Mid' | 'Senior'
  final int skillCount;
  final List<String> following;
  final List<String> followers;
  final List<String> followedCompanies;
  final int totalTestsTaken;
  final int totalBadgesEarned;
  final List<String> reviewedCompanies;
  final List<String> portfolioIDs;
  final List<String> postIDs;
  final List<String> mySkillTestIDs;
  final List<String> earnedBadgeIDs;
  final List<String> careerGuidanceTaskIDs;
  final List<String> appliedJobRequestIDs;
  final List<String> becomeEmployeeRequestIDs;
  final List<String> followRequestIDs;

  JobSeekerModel({
    required this.userID,
    this.phone = '',
    this.shortDescription = '',
    this.experienceLevel = 'Junior',
    this.skillCount = 0,
    this.following = const [],
    this.followers = const [],
    this.followedCompanies = const [],
    this.totalTestsTaken = 0,
    this.totalBadgesEarned = 0,
    this.reviewedCompanies = const [],
    this.portfolioIDs = const [],
    this.postIDs = const [],
    this.mySkillTestIDs = const [],
    this.earnedBadgeIDs = const [],
    this.careerGuidanceTaskIDs = const [],
    this.appliedJobRequestIDs = const [],
    this.becomeEmployeeRequestIDs = const [],
    this.followRequestIDs = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'phone': phone,
      'shortDescription': shortDescription,
      'experienceLevel': experienceLevel,
      'skillCount': skillCount,
      'following': following,
      'followers': followers,
      'followedCompanies': followedCompanies,
      'totalTestsTaken': totalTestsTaken,
      'totalBadgesEarned': totalBadgesEarned,
      'reviewedCompanies': reviewedCompanies,
      'portfolioIDs': portfolioIDs,
      'postIDs': postIDs,
      'mySkillTestIDs': mySkillTestIDs,
      'earnedBadgeIDs': earnedBadgeIDs,
      'careerGuidanceTaskIDs': careerGuidanceTaskIDs,
      'appliedJobRequestIDs': appliedJobRequestIDs,
      'becomeEmployeeRequestIDs': becomeEmployeeRequestIDs,
      'followRequestIDs': followRequestIDs,
    };
  }

  factory JobSeekerModel.fromMap(Map<String, dynamic> map) {
    return JobSeekerModel(
      userID: map['userID'] ?? '',
      phone: map['phone'] ?? '',
      shortDescription: map['shortDescription'] ?? '',
      experienceLevel: map['experienceLevel'] ?? 'Junior',
      skillCount: map['skillCount'] ?? 0,
      following: List<String>.from(map['following'] ?? []),
      followers: List<String>.from(map['followers'] ?? []),
      followedCompanies: List<String>.from(map['followedCompanies'] ?? []),
      totalTestsTaken: map['totalTestsTaken'] ?? 0,
      totalBadgesEarned: map['totalBadgesEarned'] ?? 0,
      reviewedCompanies: List<String>.from(map['reviewedCompanies'] ?? []),
      portfolioIDs: List<String>.from(map['portfolioIDs'] ?? []),
      postIDs: List<String>.from(map['postIDs'] ?? []),
      mySkillTestIDs: List<String>.from(map['mySkillTestIDs'] ?? []),
      earnedBadgeIDs: List<String>.from(map['earnedBadgeIDs'] ?? []),
      careerGuidanceTaskIDs: List<String>.from(
        map['careerGuidanceTaskIDs'] ?? [],
      ),
      appliedJobRequestIDs: List<String>.from(
        map['appliedJobRequestIDs'] ?? [],
      ),
      becomeEmployeeRequestIDs: List<String>.from(
        map['becomeEmployeeRequestIDs'] ?? [],
      ),
      followRequestIDs: List<String>.from(map['followRequestIDs'] ?? []),
    );
  }
}
