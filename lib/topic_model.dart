// topic_model.dart
//
// Just a simple class to hold one topic's data.
// Nothing fancy - matches the fields we store in Firestore.

class TopicModel {
  String id;       // the Firestore document id
  String skill;    // example: "Python"
  String level;    // example: "Beginner" or "1-3 yrs"
  String mode;     // "pure" or "vibe" or "experience"
  String topic;    // example: "loops"

  TopicModel({
    required this.id,
    required this.skill,
    required this.level,
    required this.mode,
    required this.topic,
  });

  // turns Firestore data into a TopicModel
  factory TopicModel.fromMap(String id, Map<String, dynamic> data) {
    return TopicModel(
      id: id,
      skill: data['skill'] ?? '',
      level: data['level'] ?? '',
      mode: data['mode'] ?? '',
      topic: data['topic'] ?? '',
    );
  }

  // turns a TopicModel back into data we can save to Firestore
  Map<String, dynamic> toMap() {
    return {
      'skill': skill,
      'level': level,
      'mode': mode,
      'topic': topic,
    };
  }
}