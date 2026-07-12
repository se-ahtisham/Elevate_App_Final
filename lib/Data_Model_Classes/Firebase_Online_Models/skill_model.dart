class SkillModel {
  final String skillID;
  final String skillName;
  final String skillDescription;
  final String skillImage; // URL
  final String category;
  final DateTime createdAt;

  SkillModel({
    required this.skillID,
    this.skillName = '',
    this.skillDescription = '',
    this.skillImage = '',
    this.category = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'skillID': skillID,
      'skillName': skillName,
      'skillDescription': skillDescription,
      'skillImage': skillImage,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SkillModel.fromMap(Map<String, dynamic> map) {
    return SkillModel(
      skillID: map['skillID'] ?? '',
      skillName: map['skillName'] ?? '',
      skillDescription: map['skillDescription'] ?? '',
      skillImage: map['skillImage'] ?? '',
      category: map['category'] ?? '',
      createdAt: map['createdAt'] != null
          ? (DateTime.tryParse(map['createdAt']) ?? DateTime.now())
          : DateTime.now(),
    );
  }
}
