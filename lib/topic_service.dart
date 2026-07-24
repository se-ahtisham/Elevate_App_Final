// topic_service.dart
//
// Functions for talking to the topic_pool collection in Firestore.
// Used by admin_manage_topics.dart (list + add + delete topics for a skill).

import 'package:cloud_firestore/cloud_firestore.dart';
import 'topic_model.dart';

class TopicService {
  final CollectionReference topicCollection = FirebaseFirestore.instance
      .collection('topic_pool');

  // Add one new topic. Called after admin fills a "new row" and hits Save.
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

  // Get every topic that belongs to one skill, regardless of level/mode.
  // Used to show the "Existing Topics" list on the manage-topics screen.
  Future<List<TopicModel>> getTopicsForSkill(String skill) async {
    QuerySnapshot snapshot = await topicCollection
        .where('skill', isEqualTo: skill)
        .get();

    List<TopicModel> topics = [];

    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      topics.add(TopicModel.fromMap(doc.id, data));
    }

    return topics;
  }

  // Delete a topic (tapped via the delete icon on an existing-topic row).
  Future<void> deleteTopic(String topicId) async {
    await topicCollection.doc(topicId).delete();
  }
}
