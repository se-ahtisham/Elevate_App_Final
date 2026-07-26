import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_app/topic_model.dart';


class TopicService {
  final CollectionReference topicCollection = FirebaseFirestore.instance
      .collection('topic_pool');

  Future<void> addTopic(
    String skill,
    String level,
    String mode,
    String topic,
  ) async {
    await topicCollection.add({
      'skill': skill,
      'level': level,
      'mode': mode,
      'topic': topic,
    });
  }

  Future<List<TopicModel>> getTopicsForSkill(String skill) async {
    final snapshot = await topicCollection
        .where('skill', isEqualTo: skill)
        .get();

    return snapshot.docs
        .map(
          (doc) =>
              TopicModel.fromMap(doc.id, doc.data() as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> deleteTopic(String topicId) async {
    await topicCollection.doc(topicId).delete();
  }
}