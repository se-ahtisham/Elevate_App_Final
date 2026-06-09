class EducationModel {
  final String year;
  final String title;
  final String school;

  const EducationModel({
    required this.year,
    required this.title,
    required this.school,
  });

  Map<String, dynamic> toMap() => {
        'year': year,
        'title': title,
        'school': school,
      };

  factory EducationModel.fromMap(Map<String, dynamic> map) => EducationModel(
        year: map['year'] ?? '',
        title: map['title'] ?? '',
        school: map['school'] ?? '',
      );
}