class JobPostModel {
  final String jobID;
  final String companyID;
  final String title;
  final String description;
  final List<String> requiredSkills;
  final List<String> requiredBadges;
  final String salary; // range
  final String jobType; // Full-time/Part-time/Remote
  final String location;
  final String experienceLevel;
  final DateTime postedAt;
  final List<String> applicants; // applicationIDs
  final bool isExternal;
  final String sourceUrl; // external apply link, '' for internal jobs
  final bool isClosed;

  JobPostModel({
    required this.jobID,
    this.companyID = '',
    this.title = '',
    this.description = '',
    this.requiredSkills = const [],
    this.requiredBadges = const [],
    this.salary = '',
    this.jobType = 'Full-time',
    this.location = '',
    this.experienceLevel = '',
    DateTime? postedAt,
    this.applicants = const [],
    this.isExternal = false,
    this.sourceUrl = '',
    this.isClosed = false,
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
      'isExternal': isExternal,
      'sourceUrl': sourceUrl,
      'isClosed': isClosed,
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
      experienceLevel: map['experienceLevel'] ?? '',
      postedAt: map['postedAt'] != null
          ? DateTime.tryParse(map['postedAt'])
          : DateTime.now(),
      applicants: List<String>.from(map['applicants'] ?? []),
      isExternal: map['isExternal'] ?? false,
      sourceUrl: map['sourceUrl'] ?? '',
      isClosed: map['isClosed'] ?? false,
    );
  }
}
