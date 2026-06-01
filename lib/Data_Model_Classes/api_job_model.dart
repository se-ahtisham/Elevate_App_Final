class ApiJobModel {
  final String id;
  final String title;
  final String company;
  final String location;
  final String platform;
  final String applyUrl;
  final bool isRemote;
  final String? salary;
  final String? jobType;
  final DateTime? postedAt;
  final String? description;

  ApiJobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.platform,
    required this.applyUrl,
    this.isRemote = false,
    this.salary,
    this.jobType,
    this.postedAt,
    this.description,
  });

  factory ApiJobModel.fromJSearch(Map<String, dynamic> json) {
    return ApiJobModel(
      id: json['job_id'] ?? '',
      title: json['job_title'] ?? '',
      company: json['employer_name'] ?? '',
      location: '${json['job_city'] ?? ''} ${json['job_country'] ?? ''}',
      platform: json['job_publisher'] ?? 'JSearch',
      applyUrl: json['job_apply_link'] ?? '',
      isRemote: json['job_is_remote'] ?? false,
      salary: json['job_salary']?.toString(),
      jobType: json['job_employment_type'],
      postedAt: DateTime.tryParse(json['job_posted_at_datetime_utc'] ?? ''),
      description: json['job_description'],
    );
  }

  factory ApiJobModel.fromArbeitnow(Map<String, dynamic> json) {
    return ApiJobModel(
      id: json['slug'] ?? '',
      title: json['title'] ?? '',
      company: json['company_name'] ?? '',
      location: json['location'] ?? 'Remote',
      platform: 'Arbeitnow',
      applyUrl: json['url'] ?? '',
      isRemote: json['remote'] ?? false,
      description: json['description'],
      postedAt: DateTime.tryParse(json['created_at'] ?? ''),
    );
  }
}
