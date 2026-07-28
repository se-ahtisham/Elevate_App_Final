import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/chat_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/message_model.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Get or create a chat between two users. Returns the chatID.
  Future<String> getOrCreateChat({
    required String myID,
    required String myName,
    required String myAvatar,
    required String otherID,
    required String otherName,
    required String otherAvatar,
  }) async {
    // Check if chat already exists between these two users
    final existing = await _db
        .collection('chats')
        .where('participants', arrayContains: myID)
        .get();

    for (final doc in existing.docs) {
      final parts = List<String>.from(doc.data()['participants'] ?? []);
      if (parts.contains(otherID)) {
        return doc.id;
      }
    }

    // Create new chat
    final chatRef = _db.collection('chats').doc();
    final chat = ChatModel(
      chatID: chatRef.id,
      participants: [myID, otherID],
      participantNames: {myID: myName, otherID: otherName},
      participantAvatars: {myID: myAvatar, otherID: otherAvatar},
    );
    await chatRef.set(chat.toMap());
    return chatRef.id;
  }

  /// Stream of all chats involving this user
  Stream<List<ChatModel>> chatsStream(String userID) {
    return _db
        .collection('chats')
        .where('participants', arrayContains: userID)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => ChatModel.fromMap(d.data()))
            .toList());
  }

  /// Stream of messages in a chat (real-time)
  Stream<List<MessageModel>> messagesStream(String chatID) {
    return _db
        .collection('chats')
        .doc(chatID)
        .collection('messages')
        .orderBy('sentAt', descending: false)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => MessageModel.fromMap(d.data()))
            .toList());
  }

  /// Send a message
  Future<void> sendMessage({
    required String chatID,
    required String senderID,
    required String senderName,
    required String text,
  }) async {
    final msgRef = _db
        .collection('chats')
        .doc(chatID)
        .collection('messages')
        .doc();

    final message = MessageModel(
      messageID: msgRef.id,
      chatID: chatID,
      senderID: senderID,
      senderName: senderName,
      text: text,
    );

    await msgRef.set(message.toMap());

    // Update last message on the chat doc
    await _db.collection('chats').doc(chatID).update({
      'lastMessage': text,
      'lastMessageTime': DateTime.now().toIso8601String(),
      'lastSenderID': senderID,
    });
  }
}
