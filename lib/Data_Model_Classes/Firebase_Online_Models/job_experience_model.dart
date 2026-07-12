class JobExperienceModel {
  final String jobTitle;
  final String company;
  final String from;
  final String to;

  JobExperienceModel({
    this.jobTitle = '',
    this.company = '',
    this.from = '',
    this.to = '',
  });

  Map<String, dynamic> toMap() {
    return {'jobTitle': jobTitle, 'company': company, 'from': from, 'to': to};
  }

  factory JobExperienceModel.fromMap(Map<String, dynamic> map) {
    return JobExperienceModel(
      jobTitle: map['jobTitle'] ?? '',
      company: map['company'] ?? '',
      from: map['from'] ?? '',
      to: map['to'] ?? '',
    );
  }
}
