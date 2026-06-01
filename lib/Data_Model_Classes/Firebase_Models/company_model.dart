// company_model.dart
// Company model — extends USER with company-specific fields.
// Gap fixed: added becomeEmployeeRequestIDs (was missing from original).

class CompanyModel {
  final String userID;
  final String companyName;
  final String industry;
  final String website;
  final String logo;
  final String description;
  final int companySize;
  final int activeJobs;
  final int followers;
  final List<String> employeeIDs;
  final List<String> companyWeaknesses;
  final List<String> companyStrengths;
  final List<String> achievements;
  final List<String> receivedApplicationIDs;
  final List<String> postedJobIDs;
  final List<String> becomeEmployeeRequestIDs; // ADDED — was missing

  CompanyModel({
    required this.userID,
    this.companyName = '',
    this.industry = '',
    this.website = '',
    this.logo = '',
    this.description = '',
    this.companySize = 0,
    this.activeJobs = 0,
    this.followers = 0,
    this.employeeIDs = const [],
    this.companyWeaknesses = const [],
    this.companyStrengths = const [],
    this.achievements = const [],
    this.receivedApplicationIDs = const [],
    this.postedJobIDs = const [],
    this.becomeEmployeeRequestIDs = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'companyName': companyName,
      'industry': industry,
      'website': website,
      'logo': logo,
      'description': description,
      'companySize': companySize,
      'activeJobs': activeJobs,
      'followers': followers,
      'employeeIDs': employeeIDs,
      'companyWeaknesses': companyWeaknesses,
      'companyStrengths': companyStrengths,
      'achievements': achievements,
      'receivedApplicationIDs': receivedApplicationIDs,
      'postedJobIDs': postedJobIDs,
      'becomeEmployeeRequestIDs': becomeEmployeeRequestIDs,
    };
  }

  factory CompanyModel.fromMap(Map<String, dynamic> map) {
    return CompanyModel(
      userID: map['userID'] ?? '',
      companyName: map['companyName'] ?? '',
      industry: map['industry'] ?? '',
      website: map['website'] ?? '',
      logo: map['logo'] ?? '',
      description: map['description'] ?? '',
      companySize: map['companySize'] ?? 0,
      activeJobs: map['activeJobs'] ?? 0,
      followers: map['followers'] ?? 0,
      employeeIDs: List<String>.from(map['employeeIDs'] ?? []),
      companyWeaknesses: List<String>.from(map['companyWeaknesses'] ?? []),
      companyStrengths: List<String>.from(map['companyStrengths'] ?? []),
      achievements: List<String>.from(map['achievements'] ?? []),
      receivedApplicationIDs:
          List<String>.from(map['receivedApplicationIDs'] ?? []),
      postedJobIDs: List<String>.from(map['postedJobIDs'] ?? []),
      becomeEmployeeRequestIDs:
          List<String>.from(map['becomeEmployeeRequestIDs'] ?? []),
    );
  }
}
