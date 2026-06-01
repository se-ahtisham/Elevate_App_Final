// employee_model.dart
// A JobSeeker who got hired by a Company.
// Collection: 'employees' — doc ID = employeeID.

class EmployeeModel {
  final String employeeID;
  final String jobSeekerID;
  final String companyID;
  final String position;
  final String employeeStatus; // 'Active' | 'Terminated'
  final DateTime hiredAt;
  final DateTime? terminatedAt; // null while still active

  EmployeeModel({
    required this.employeeID,
    required this.jobSeekerID,
    required this.companyID,
    this.position = '',
    this.employeeStatus = 'Active',
    DateTime? hiredAt,
    this.terminatedAt,
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
    };
  }

  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      employeeID: map['employeeID'] ?? '',
      jobSeekerID: map['jobSeekerID'] ?? '',
      companyID: map['companyID'] ?? '',
      position: map['position'] ?? '',
      employeeStatus: map['employeeStatus'] ?? 'Active',
      hiredAt: map['hiredAt'] != null
          ? DateTime.parse(map['hiredAt'])
          : DateTime.now(),
      terminatedAt: map['terminatedAt'] != null
          ? DateTime.parse(map['terminatedAt'])
          : null,
    );
  }
}
