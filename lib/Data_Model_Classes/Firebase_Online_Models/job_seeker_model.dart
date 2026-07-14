import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/education_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_experience_model.dart';

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

  final List<String>
  passedResultIDs; // resultIDs of passed tests (see Result.testID -> Test.skillID for the skill link)
  final List<String> following;
  final List<String> followers;
  final List<String> followRequests; // requestIDs -> FollowRequestModel
  final List<String> followedCompanies;
  final List<String> postList; // postIDs
  final List<String> portfolio; // projectIDs
  final List<String>
  mySkillTestsResultList; // resultIDs (all attempts, pass or fail)
  final int totalTestsTaken;
  final List<String> appliedJobRequests; // applicationIDs
  final List<String> becomeEmployee; // becomeEmployeeRequestIDs
  final List<String> careerGuidanceTasks; // taskIDs
  final List<String> earnedBadges; // badgeIDs
  final int totalBadgesEarned;
  final List<EducationModel> education;
  final List<JobExperienceModel> jobExperience;

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
    this.passedResultIDs = const [],
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
    this.education = const [],
    this.jobExperience = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'jobSeekerID': jobSeekerID,
      'name': name,
      'email': email,
      'password': password,
      'userType': userType,
      'profilePic': profilePic,
      'location': location,
      'about': about,
      'shortDescription': shortDescription,
      'experienceLevel': experienceLevel,
      'skillCount': skillCount,
      'passedResultIDs': passedResultIDs,
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
      'education': education.map((e) => e.toMap()).toList(),
      'jobExperience': jobExperience.map((e) => e.toMap()).toList(),
    };
  }

  factory JobSeekerModel.fromMap(Map<String, dynamic> map) {
    return JobSeekerModel(
      jobSeekerID: map['jobSeekerID'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      userType: map['userType'] ?? 'JobSeeker',
      profilePic: map['profilePic'] ?? '',
      location: map['location'] ?? '',
      about: map['about'] ?? '',
      shortDescription: map['shortDescription'] ?? '',
      experienceLevel: map['experienceLevel'] ?? 'Junior',
      skillCount: map['skillCount'] ?? 0,
      passedResultIDs: List<String>.from(map['passedResultIDs'] ?? []),
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
      education: (map['education'] as List<dynamic>? ?? [])
          .map((m) => EducationModel.fromMap(Map<String, dynamic>.from(m)))
          .toList(),
      jobExperience: (map['jobExperience'] as List<dynamic>? ?? [])
          .map((m) => JobExperienceModel.fromMap(Map<String, dynamic>.from(m)))
          .toList(),
    );
  }
}
