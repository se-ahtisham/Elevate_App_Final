

class EmployeeModel {
  final String employeeID;        // PK
  final String jobSeekerID;       // FK → users/
  final String companyID;         // FK → users/
  final String position;          // job title / role
  final String employeeStatus;    // 'Active' | 'Terminated'
  final DateTime hiredAt;

  EmployeeModel({
    required this.employeeID,
    required this.jobSeekerID,
    required this.companyID,
    this.position = '',
    this.employeeStatus = 'Active',
    DateTime? hiredAt,
  }) : hiredAt = hiredAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'employeeID': employeeID,
      'jobSeekerID': jobSeekerID,
      'companyID': companyID,
      'position': position,
      'employeeStatus': employeeStatus,
      'hiredAt': hiredAt.toIso8601String(),
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
    );
  }
}
