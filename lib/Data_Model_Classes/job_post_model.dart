class JobPostModel {
  final String jobID; // PK
  final String companyID; // FK → users/
  final String title;
  final String description;
  final List<String> requiredSkills; // skillIDs → collection: skills/
  final List<String> requiredBadges; // badgeIDs → collection: badges/
  final String salary; // e.g. "50k–80k"
  final String jobType; // 'Full-time' | 'Part-time' | 'Remote'
  final String location;
  final String experienceLevel; // 'Junior' | 'Mid' | 'Senior'
  final DateTime postedAt;
  final List<String> applicants; // applicationIDs → collection: applications/

  JobPostModel({
    required this.jobID,
    required this.companyID,
    required this.title,
    this.description = '',
    this.requiredSkills = const [],
    this.requiredBadges = const [],
    this.salary = '',
    this.jobType = 'Full-time',
    this.location = '',
    this.experienceLevel = 'Junior',
    this.applicants = const [],
    DateTime? postedAt,
  }) : postedAt = postedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'jobID': jobID,
      'companyID': companyID,
      'title': title,
      'description': description,
      'requiredSkills': requiredSkills,
      'requiredBadges': requiredBadges,
      'salary': salary,
      'jobType': jobType,
      'location': location,
      'experienceLevel': experienceLevel,
      'postedAt': postedAt.toIso8601String(),
      'applicants': applicants,
    };
  }

  factory JobPostModel.fromMap(Map<String, dynamic> map) {
    return JobPostModel(
      jobID: map['jobID'] ?? '',
      companyID: map['companyID'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      requiredSkills: List<String>.from(map['requiredSkills'] ?? []),
      requiredBadges: List<String>.from(map['requiredBadges'] ?? []),
      salary: map['salary'] ?? '',
      jobType: map['jobType'] ?? 'Full-time',
      location: map['location'] ?? '',
      experienceLevel: map['experienceLevel'] ?? 'Junior',
      postedAt: map['postedAt'] != null
          ? DateTime.parse(map['postedAt'])
          : DateTime.now(),
      applicants: List<String>.from(map['applicants'] ?? []),
    );
  }
}
