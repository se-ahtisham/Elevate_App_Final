class JobExperienceModel {
  final String jobTitle;
  final String company;
  final String from;
  final String to;

  const JobExperienceModel({
    required this.jobTitle,
    required this.company,
    required this.from,
    required this.to,
  });

  Map<String, dynamic> toMap() => {
        'jobTitle': jobTitle,
        'company': company,
        'from': from,
        'to': to,
      };

  factory JobExperienceModel.fromMap(Map<String, dynamic> map) =>
      JobExperienceModel(
        jobTitle: map['jobTitle'] ?? '',
        company: map['company'] ?? '',
        from: map['from'] ?? '',
        to: map['to'] ?? '',
      );
}