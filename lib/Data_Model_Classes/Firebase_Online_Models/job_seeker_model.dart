import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/education_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_experience_model.dart';

class JobSeekerModel {
  final String userID;
  final String phone;
  final String shortDescription;
  final String experienceLevel;
  final int skillCount;
  final List<EducationModel> education;
  final List<JobExperienceModel> jobExperience;
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

  const JobSeekerModel({
    required this.userID,
    this.phone = '',
    this.shortDescription = '',
    this.experienceLevel = 'Junior',
    this.skillCount = 0,
    this.education = const [],
    this.jobExperience = const [],
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

  Map<String, dynamic> toMap() => {
    'userID': userID,
    'phone': phone,
    'shortDescription': shortDescription,
    'experienceLevel': experienceLevel,
    'skillCount': skillCount,
    'education': education.map((e) => e.toMap()).toList(),
    'jobExperience': jobExperience.map((e) => e.toMap()).toList(),
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

  factory JobSeekerModel.fromMap(Map<String, dynamic> map) => JobSeekerModel(
    userID: map['userID'] ?? '',
    phone: map['phone'] ?? '',
    shortDescription: map['shortDescription'] ?? '',
    experienceLevel: map['experienceLevel'] ?? 'Junior',
    skillCount: map['skillCount'] ?? 0,
    education: (map['education'] as List<dynamic>? ?? [])
        .map((e) => EducationModel.fromMap(Map<String, dynamic>.from(e)))
        .toList(),
    jobExperience: (map['jobExperience'] as List<dynamic>? ?? [])
        .map((e) => JobExperienceModel.fromMap(Map<String, dynamic>.from(e)))
        .toList(),
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
    appliedJobRequestIDs: List<String>.from(map['appliedJobRequestIDs'] ?? []),
    becomeEmployeeRequestIDs: List<String>.from(
      map['becomeEmployeeRequestIDs'] ?? [],
    ),
    followRequestIDs: List<String>.from(map['followRequestIDs'] ?? []),
  );

  JobSeekerModel copyWith({
    String? phone,
    String? shortDescription,
    String? experienceLevel,
    int? skillCount,
    List<EducationModel>? education,
    List<JobExperienceModel>? jobExperience,
    List<String>? following,
    List<String>? followers,
    List<String>? followedCompanies,
    int? totalTestsTaken,
    int? totalBadgesEarned,
    List<String>? reviewedCompanies,
    List<String>? portfolioIDs,
    List<String>? postIDs,
    List<String>? mySkillTestIDs,
    List<String>? earnedBadgeIDs,
    List<String>? careerGuidanceTaskIDs,
    List<String>? appliedJobRequestIDs,
    List<String>? becomeEmployeeRequestIDs,
    List<String>? followRequestIDs,
  }) => JobSeekerModel(
    userID: userID,
    phone: phone ?? this.phone,
    shortDescription: shortDescription ?? this.shortDescription,
    experienceLevel: experienceLevel ?? this.experienceLevel,
    skillCount: skillCount ?? this.skillCount,
    education: education ?? this.education,
    jobExperience: jobExperience ?? this.jobExperience,
    following: following ?? this.following,
    followers: followers ?? this.followers,
    followedCompanies: followedCompanies ?? this.followedCompanies,
    totalTestsTaken: totalTestsTaken ?? this.totalTestsTaken,
    totalBadgesEarned: totalBadgesEarned ?? this.totalBadgesEarned,
    reviewedCompanies: reviewedCompanies ?? this.reviewedCompanies,
    portfolioIDs: portfolioIDs ?? this.portfolioIDs,
    postIDs: postIDs ?? this.postIDs,
    mySkillTestIDs: mySkillTestIDs ?? this.mySkillTestIDs,
    earnedBadgeIDs: earnedBadgeIDs ?? this.earnedBadgeIDs,
    careerGuidanceTaskIDs: careerGuidanceTaskIDs ?? this.careerGuidanceTaskIDs,
    appliedJobRequestIDs: appliedJobRequestIDs ?? this.appliedJobRequestIDs,
    becomeEmployeeRequestIDs:
        becomeEmployeeRequestIDs ?? this.becomeEmployeeRequestIDs,
    followRequestIDs: followRequestIDs ?? this.followRequestIDs,
  );
}
