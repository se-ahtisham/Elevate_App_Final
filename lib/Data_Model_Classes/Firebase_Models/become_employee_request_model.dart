// become_employee_request_model.dart
// Sent when a JobSeeker requests to become an employee at a Company.
// Referenced by becomeEmployeeRequestIDs in JobSeekerModel and CompanyModel.
// Collection: 'becomeEmployeeRequests' — doc ID = requestID.

class BecomeEmployeeRequestModel {
  final String requestID;
  final String jobSeekerID;
  final String companyID;
  final String status; // 'Pending' | 'Accepted' | 'Rejected'
  final DateTime requestedAt;
  final DateTime? resolvedAt; // null until company/admin acts on it

  BecomeEmployeeRequestModel({
    required this.requestID,
    required this.jobSeekerID,
    required this.companyID,
    this.status = 'Pending',
    DateTime? requestedAt,
    this.resolvedAt,
  }) : requestedAt = requestedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'requestID': requestID,
      'jobSeekerID': jobSeekerID,
      'companyID': companyID,
      'status': status,
      'requestedAt': requestedAt.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
    };
  }

  factory BecomeEmployeeRequestModel.fromMap(Map<String, dynamic> map) {
    return BecomeEmployeeRequestModel(
      requestID: map['requestID'] ?? '',
      jobSeekerID: map['jobSeekerID'] ?? '',
      companyID: map['companyID'] ?? '',
      status: map['status'] ?? 'Pending',
      requestedAt: map['requestedAt'] != null
          ? DateTime.parse(map['requestedAt'])
          : DateTime.now(),
      resolvedAt: map['resolvedAt'] != null
          ? DateTime.parse(map['resolvedAt'])
          : null,
    );
  }
}
