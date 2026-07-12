import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/skill_model.dart';

class JobSeekerModel {
  final String jobSeekerID;
  final String name;
  final String email;
  final String password;
  final String userType; // 'JobSeeker'
  final String profilePic; // URL
  final String location;
  final String about;
  final String shortDescription;
  final String experienceLevel; // Junior/Mid/Senior
  final int skillCount;

  final List<SkillModel>
  passedSkills; // full skill objects (name, image, etc.) for tests this seeker has passed
  final List<String> following;
  final List<String> followers;
  final List<String> followRequests; // requestIDs -> FollowRequestModel
  final List<String> followedCompanies;
  final List<String> postList; // postIDs
  final List<String> portfolio; // projectIDs
  final List<String> mySkillTestsResultList; // resultIDs
  final int totalTestsTaken;
  final List<String> appliedJobRequests; // applicationIDs
  final List<String> becomeEmployee; // becomeEmployeeRequestIDs
  final List<String> careerGuidanceTasks; // taskIDs
  final List<String> earnedBadges; // badgeIDs
  final int totalBadgesEarned;

  JobSeekerModel({
    required this.jobSeekerID,
    this.name = '',
    this.email = '',
    this.password = '',
    this.userType = 'JobSeeker',
    this.profilePic = '',
    this.location = '',
    this.about = '',
    this.shortDescription = '',
    this.experienceLevel = 'Junior',
    this.skillCount = 0,
    this.passedSkills = const [],
    this.following = const [],
    this.followers = const [],
    this.followRequests = const [],
    this.followedCompanies = const [],
    this.postList = const [],
    this.portfolio = const [],
    this.mySkillTestsResultList = const [],
    this.totalTestsTaken = 0,
    this.appliedJobRequests = const [],
    this.becomeEmployee = const [],
    this.careerGuidanceTasks = const [],
    this.earnedBadges = const [],
    this.totalBadgesEarned = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'jobSeekerID': jobSeekerID,
      'name': name,
      'email': email,
      'password': password, // Added
      'userType': userType,
      'profilePic': profilePic,
      'location': location,
      'about': about,
      'shortDescription': shortDescription,
      'experienceLevel': experienceLevel,
      'skillCount': skillCount,
      'passedSkills': passedSkills.map((s) => s.toMap()).toList(),
      'following': following,
      'followers': followers,
      'followRequests': followRequests,
      'followedCompanies': followedCompanies,
      'postList': postList,
      'portfolio': portfolio,
      'mySkillTestsResultList': mySkillTestsResultList,
      'totalTestsTaken': totalTestsTaken,
      'appliedJobRequests': appliedJobRequests,
      'becomeEmployee': becomeEmployee,
      'careerGuidanceTasks': careerGuidanceTasks,
      'earnedBadges': earnedBadges,
      'totalBadgesEarned': totalBadgesEarned,
    };
  }

  factory JobSeekerModel.fromMap(Map<String, dynamic> map) {
    return JobSeekerModel(
      jobSeekerID: map['jobSeekerID'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '', // Added
      userType: map['userType'] ?? 'JobSeeker',
      profilePic: map['profilePic'] ?? '',
      location: map['location'] ?? '',
      about: map['about'] ?? '',
      shortDescription: map['shortDescription'] ?? '',
      experienceLevel: map['experienceLevel'] ?? 'Junior',
      skillCount: map['skillCount'] ?? 0,
      passedSkills: (map['passedSkills'] as List<dynamic>? ?? [])
          .map((m) => SkillModel.fromMap(Map<String, dynamic>.from(m)))
          .toList(),
      following: List<String>.from(map['following'] ?? []),
      followers: List<String>.from(map['followers'] ?? []),
      followRequests: List<String>.from(map['followRequests'] ?? []),
      followedCompanies: List<String>.from(map['followedCompanies'] ?? []),
      postList: List<String>.from(map['postList'] ?? []),
      portfolio: List<String>.from(map['portfolio'] ?? []),
      mySkillTestsResultList: List<String>.from(
        map['mySkillTestsResultList'] ?? [],
      ),
      totalTestsTaken: map['totalTestsTaken'] ?? 0,
      appliedJobRequests: List<String>.from(map['appliedJobRequests'] ?? []),
      becomeEmployee: List<String>.from(map['becomeEmployee'] ?? []),
      careerGuidanceTasks: List<String>.from(map['careerGuidanceTasks'] ?? []),
      earnedBadges: List<String>.from(map['earnedBadges'] ?? []),
      totalBadgesEarned: map['totalBadgesEarned'] ?? 0,
    );
  }
}
