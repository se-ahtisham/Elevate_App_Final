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
      'userType': userType,
      'profilePic': profilePic,
      'location': location,
      'about': about,
      'shortDescription': shortDescription,
      'experienceLevel': experienceLevel,
      'skillCount': skillCount,
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
      userType: map['userType'] ?? 'JobSeeker',
      profilePic: map['profilePic'] ?? '',
      location: map['location'] ?? '',
      about: map['about'] ?? '',
      shortDescription: map['shortDescription'] ?? '',
      experienceLevel: map['experienceLevel'] ?? 'Junior',
      skillCount: map['skillCount'] ?? 0,
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

  JobSeekerModel copyWith({
    String? name,
    String? profilePic,
    String? location,
    String? about,
    String? shortDescription,
    String? experienceLevel,
    int? skillCount,
    List<String>? following,
    List<String>? followers,
    List<String>? followRequests,
    List<String>? followedCompanies,
    List<String>? postList,
    List<String>? portfolio,
    List<String>? mySkillTestsResultList,
    int? totalTestsTaken,
    List<String>? appliedJobRequests,
    List<String>? becomeEmployee,
    List<String>? careerGuidanceTasks,
    List<String>? earnedBadges,
    int? totalBadgesEarned,
  }) {
    return JobSeekerModel(
      jobSeekerID: jobSeekerID,
      name: name ?? this.name,
      email: email,
      userType: userType,
      profilePic: profilePic ?? this.profilePic,
      location: location ?? this.location,
      about: about ?? this.about,
      shortDescription: shortDescription ?? this.shortDescription,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      skillCount: skillCount ?? this.skillCount,
      following: following ?? this.following,
      followers: followers ?? this.followers,
      followRequests: followRequests ?? this.followRequests,
      followedCompanies: followedCompanies ?? this.followedCompanies,
      postList: postList ?? this.postList,
      portfolio: portfolio ?? this.portfolio,
      mySkillTestsResultList:
          mySkillTestsResultList ?? this.mySkillTestsResultList,
      totalTestsTaken: totalTestsTaken ?? this.totalTestsTaken,
      appliedJobRequests: appliedJobRequests ?? this.appliedJobRequests,
      becomeEmployee: becomeEmployee ?? this.becomeEmployee,
      careerGuidanceTasks: careerGuidanceTasks ?? this.careerGuidanceTasks,
      earnedBadges: earnedBadges ?? this.earnedBadges,
      totalBadgesEarned: totalBadgesEarned ?? this.totalBadgesEarned,
    );
  }
}
