class ProjectModel {
  final String projectID;
  final String jobSeekerID;
  final String projectTitle;
  final String projectDescription;
  final String projectURL;
  final List<String> techStack; // file names
  final List<String>
  techFileUrls; // matching download URLs (same order as techStack)
  final List<String> mediaFiles; // image URLs
  final DateTime createdAt;

  ProjectModel({
    required this.projectID,
    required this.jobSeekerID,
    this.projectTitle = '',
    this.projectDescription = '',
    this.projectURL = '',
    this.techStack = const [],
    this.techFileUrls = const [],
    this.mediaFiles = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'projectID': projectID,
      'jobSeekerID': jobSeekerID,
      'projectTitle': projectTitle,
      'projectDescription': projectDescription,
      'projectURL': projectURL,
      'techStack': techStack,
      'techFileUrls': techFileUrls,
      'mediaFiles': mediaFiles,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      projectID: map['projectID'] ?? '',
      jobSeekerID: map['jobSeekerID'] ?? '',
      projectTitle: map['projectTitle'] ?? '',
      projectDescription: map['projectDescription'] ?? '',
      projectURL: map['projectURL'] ?? '',
      techStack: List<String>.from(map['techStack'] ?? []),
      techFileUrls: List<String>.from(map['techFileUrls'] ?? []),
      mediaFiles: List<String>.from(map['mediaFiles'] ?? []),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  ProjectModel copyWith({
    String? projectTitle,
    String? projectDescription,
    String? projectURL,
    List<String>? techStack,
    List<String>? techFileUrls,
    List<String>? mediaFiles,
  }) {
    return ProjectModel(
      projectID: projectID,
      jobSeekerID: jobSeekerID,
      projectTitle: projectTitle ?? this.projectTitle,
      projectDescription: projectDescription ?? this.projectDescription,
      projectURL: projectURL ?? this.projectURL,
      techStack: techStack ?? this.techStack,
      techFileUrls: techFileUrls ?? this.techFileUrls,
      mediaFiles: mediaFiles ?? this.mediaFiles,
      createdAt: createdAt,
    );
  }
}
