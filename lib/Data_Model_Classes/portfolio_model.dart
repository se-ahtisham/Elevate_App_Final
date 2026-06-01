

class PortfolioModel {
  final String portfolioID;          // PK — unique ID for this portfolio
  final String jobSeekerID;          // FK → users/ (who owns this portfolio)
  final String projectTitle;
  final String projectDescription;
  final String projectURL;
  final List<String> techStack;      // e.g. ['Flutter', 'Firebase', 'Dart']
  final List<String> mediaFiles;     // URLs to images/videos of the project
  final DateTime createdAt;

  PortfolioModel({
    required this.portfolioID,
    required this.jobSeekerID,
    required this.projectTitle,
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
