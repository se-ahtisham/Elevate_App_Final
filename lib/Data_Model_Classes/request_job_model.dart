class RequestJobModel {
  final String applicationID; // PK
  final String jobID; // FK → jobs/
  final String jobSeekerID; // FK → users/
  final String status; // 'Pending' | 'Accepted' | 'Rejected'
  final DateTime appliedAt;

  RequestJobModel({
    required this.applicationID,
    required this.jobID,
    required this.jobSeekerID,
    this.status = 'Pending',
    DateTime? appliedAt,
  }) : appliedAt = appliedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'applicationID': applicationID,
      'jobID': jobID,
      'jobSeekerID': jobSeekerID,
      'status': status,
      'appliedAt': appliedAt.toIso8601String(),
    };
  }

  factory RequestJobModel.fromMap(Map<String, dynamic> map) {
    return RequestJobModel(
      applicationID: map['applicationID'] ?? '',
      jobID: map['jobID'] ?? '',
      jobSeekerID: map['jobSeekerID'] ?? '',
      status: map['status'] ?? 'Pending',
      appliedAt: map['appliedAt'] != null
          ? DateTime.parse(map['appliedAt'])
          : DateTime.now(),
    );
  }
}
