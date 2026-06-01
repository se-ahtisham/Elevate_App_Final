// JobApplication model (called "Request Job" in diagram)
// Created when a JobSeeker applies to a job

class JobApplicationModel {
  final String applicationID;
  final String jobID;
  final String jobSeekerID;
  final String status; // 'Pending', 'Accepted', 'Rejected'
  final DateTime appliedAt;

  JobApplicationModel({
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

  factory JobApplicationModel.fromMap(Map<String, dynamic> map) {
    return JobApplicationModel(
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
