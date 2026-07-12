class ProjectModel {
  final String projectID;
  final String jobSeekerID;
  final String projectTitle;
  final String projectDescription;
  final String projectURL;
  final List<String> techStack;
  final List<String> mediaFiles; // URLs
  final DateTime createdAt;

  ProjectModel({
    required this.projectID,
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
      'projectID': projectID,
      'jobSeekerID': jobSeekerID,
      'projectTitle': projectTitle,
      'projectDescription': projectDescription,
      'projectURL': projectURL,
      'techStack': techStack,
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
      mediaFiles: List<String>.from(map['mediaFiles'] ?? []),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'])
          : DateTime.now(),
    );
  }

  ProjectModel copyWith({
    String? projectTitle,
    String? projectDescription,
    String? projectURL,
    List<String>? techStack,
    List<String>? mediaFiles,
  }) {
    return ProjectModel(
      projectID: projectID,
      jobSeekerID: jobSeekerID,
      projectTitle: projectTitle ?? this.projectTitle,
      projectDescription: projectDescription ?? this.projectDescription,
      projectURL: projectURL ?? this.projectURL,
      techStack: techStack ?? this.techStack,
      mediaFiles: mediaFiles ?? this.mediaFiles,
      createdAt: createdAt,
    );
  }
}
