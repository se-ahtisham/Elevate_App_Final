class CompanyEmployeeModel {
  final String employeeID;
  final String jobSeekerID;
  final String companyID;
  final String position;
  final String employeeStatus; // Active/Terminated
  final DateTime hiredAt;
  final DateTime? terminatedAt;
  final bool hasSubmittedReview;

  CompanyEmployeeModel({
    required this.employeeID,
    required this.jobSeekerID,
    required this.companyID,
    this.position = '',
    this.employeeStatus = 'Active',
    DateTime? hiredAt,
    this.terminatedAt,
    this.hasSubmittedReview = false,
  }) : hiredAt = hiredAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'employeeID': employeeID,
      'jobSeekerID': jobSeekerID,
      'companyID': companyID,
      'position': position,
      'employeeStatus': employeeStatus,
      'hiredAt': hiredAt.toIso8601String(),
      'terminatedAt': terminatedAt?.toIso8601String(),
      'hasSubmittedReview': hasSubmittedReview,
    };
  }

  factory CompanyEmployeeModel.fromMap(Map<String, dynamic> map) {
    return CompanyEmployeeModel(
      employeeID: map['employeeID'] ?? '',
      jobSeekerID: map['jobSeekerID'] ?? '',
      companyID: map['companyID'] ?? '',
      position: map['position'] ?? '',
      employeeStatus: map['employeeStatus'] ?? 'Active',
      hiredAt: map['hiredAt'] != null
          ? DateTime.tryParse(map['hiredAt'])
          : DateTime.now(),
      terminatedAt: map['terminatedAt'] != null
          ? DateTime.tryParse(map['terminatedAt'])
          : null,
      hasSubmittedReview: map['hasSubmittedReview'] ?? false,
    );
  }
}
