// Portfolio model — a project added by a JobSeeker

class PortfolioModel {
  final String portfolioID;
  final String jobSeekerID;
  final String projectTitle;
  final String projectDescription;
  final String projectURL;
  final List<String> techStack;
  final List<String> mediaFiles; // URLs
  final DateTime createdAt;

  PortfolioModel({
    required this.portfolioID,
    required this.jobSeekerID,
    this.projectTitle = '',
    this.projectDescription = '',
    this.projectURL = '',
    this.techStack = const [],
    this.mediaFiles = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'portfolioID': portfolioID,
      'jobSeekerID': jobSeekerID,
      'projectTitle': projectTitle,
      'projectDescription': projectDescription,
      'projectURL': projectURL,
      'techStack': techStack,
      'mediaFiles': mediaFiles,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PortfolioModel.fromMap(Map<String, dynamic> map) {
    return PortfolioModel(
      portfolioID: map['portfolioID'] ?? '',
      jobSeekerID: map['jobSeekerID'] ?? '',
      projectTitle: map['projectTitle'] ?? '',
      projectDescription: map['projectDescription'] ?? '',
      projectURL: map['projectURL'] ?? '',
      techStack: List<String>.from(map['techStack'] ?? []),
      mediaFiles: List<String>.from(map['mediaFiles'] ?? []),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }
}
