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
      title: json['title']?.toString() ?? '',
      company: json['company']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      salaryStart: (json['salary_start'] is num)
          ? (json['salary_start'] as num).toInt()
          : (int.tryParse(json['salary_start']?.toString() ?? '') ?? 0),
      salaryEnd: (json['salary_end'] is num)
          ? (json['salary_end'] as num).toInt()
          : (int.tryParse(json['salary_end']?.toString() ?? '') ?? 0),
    );
  }
}
