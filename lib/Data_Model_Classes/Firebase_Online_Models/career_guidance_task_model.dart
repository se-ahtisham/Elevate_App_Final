class CareerGuidanceTaskModel {
  final String taskID;
  final String jobSeekerID;
  final String title; // learning topic
  final String description;
  final String priority; // High/Medium/Low
  final bool isCompleted;
  final bool
  aiGenerated; // true → Task created by AI system. false → Task created by the user.
  final DateTime createdAt;
  final DateTime? completedAt;

  CareerGuidanceTaskModel({
    required this.taskID,
    required this.jobSeekerID,
    this.title = '',
    this.description = '',
    this.priority = 'Medium',
    this.isCompleted = false,
    this.aiGenerated = false,
    DateTime? createdAt,
    this.completedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'taskID': taskID,
      'jobSeekerID': jobSeekerID,
      'title': title,
      'description': description,
      'priority': priority,
      'isCompleted': isCompleted,
      'aiGenerated': aiGenerated,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory CareerGuidanceTaskModel.fromMap(Map<String, dynamic> map) {
    return CareerGuidanceTaskModel(
      taskID: map['taskID'] ?? '',
      jobSeekerID: map['jobSeekerID'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      priority: map['priority'] ?? 'Medium',
      isCompleted: map['isCompleted'] ?? false,
      aiGenerated: map['aiGenerated'] ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'])
          : DateTime.now(),
      completedAt: map['completedAt'] != null
          ? DateTime.tryParse(map['completedAt'])
          : null,
    );
  }
}
