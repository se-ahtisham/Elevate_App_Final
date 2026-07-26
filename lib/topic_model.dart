class TopicModel {
  String id;
  String skill;
  String level;
  String mode;
  String topic;

  TopicModel({
    required this.id,
    required this.skill,
    required this.level,
    required this.mode,
    required this.topic,
  });

  factory TopicModel.fromMap(String id, Map<String, dynamic> data) {
    return TopicModel(
      id: id,
      skill: data['skill'] ?? '',
      level: data['level'] ?? '',
      mode: data['mode'] ?? '',
      topic: data['topic'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'skill': skill, 'level': level, 'mode': mode, 'topic': topic};
  }
}
