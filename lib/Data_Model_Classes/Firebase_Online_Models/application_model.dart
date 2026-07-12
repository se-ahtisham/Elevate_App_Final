class ApplicationModel {
  final String applicationID;
  final String jobID;
  final String jobSeekerID;
  final String companyID; //
  final String status; // Pending/Accepted/Rejected
  final DateTime appliedAt;
  final String coldEmail; // AI-generated (or manually written) cover/cold email

  ApplicationModel({
    required this.applicationID,
    required this.jobID,
    required this.jobSeekerID,
    required this.companyID,
    this.status = 'Pending',
    DateTime? appliedAt,
    this.coldEmail = '',
  }) : appliedAt = appliedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'applicationID': applicationID,
      'jobID': jobID,
      'jobSeekerID': jobSeekerID,
      'companyID': companyID,
      'status': status,
      'appliedAt': appliedAt.toIso8601String(),
      'coldEmail': coldEmail,
    };
  }

  factory ApplicationModel.fromMap(Map<String, dynamic> map) {
    return ApplicationModel(
      applicationID: map['applicationID'] ?? '',
      jobID: map['jobID'] ?? '',
      jobSeekerID: map['jobSeekerID'] ?? '',
      companyID: map['companyID'] ?? '',
      status: map['status'] ?? 'Pending',
      appliedAt: map['appliedAt'] != null
          ? DateTime.tryParse(map['appliedAt'])
          : DateTime.now(),
      coldEmail: map['coldEmail'] ?? '',
    );
  }
}
