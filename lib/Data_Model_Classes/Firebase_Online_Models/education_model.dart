class EducationModel {
  final String year;
  final String title;
  final String school;

  EducationModel({
    this.year = '',
    this.title = '',
    this.school = '',
  });

  Map<String, dynamic> toMap() {
    return {'year': year, 'title': title, 'school': school};
  }

  factory EducationModel.fromMap(Map<String, dynamic> map) {
    return EducationModel(
      year: map['year'] ?? '',
      title: map['title'] ?? '',
      school: map['school'] ?? '',
    );
  }
}