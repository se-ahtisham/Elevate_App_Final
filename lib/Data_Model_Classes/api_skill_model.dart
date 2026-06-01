class SkillModel {
  final String title;
  final String company;
  final String location;
  final int salaryStart;
  final int salaryEnd;

  SkillModel({
    required this.title,
    required this.company,
    required this.location,
    required this.salaryStart,
    required this.salaryEnd,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      location: json['location'] ?? '',
      salaryStart: json['salary_start'] ?? 0,
      salaryEnd: json['salary_end'] ?? 0,
    );
  }
}
