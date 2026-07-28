class ChatModel {
  final String chatID;
  final List<String> participants; // list of user UIDs
  final String lastMessage;
  final DateTime lastMessageTime;
  final String lastSenderID;
  final Map<String, String> participantNames; // uid -> name
  final Map<String, String> participantAvatars; // uid -> avatar url

  ChatModel({
    required this.chatID,
    required this.participants,
    this.lastMessage = '',
    DateTime? lastMessageTime,
    this.lastSenderID = '',
    this.participantNames = const {},
    this.participantAvatars = const {},
  }) : lastMessageTime = lastMessageTime ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'chatID': chatID,
        'participants': participants,
        'lastMessage': lastMessage,
        'lastMessageTime': lastMessageTime.toIso8601String(),
        'lastSenderID': lastSenderID,
        'participantNames': participantNames,
        'participantAvatars': participantAvatars,
      };

  factory ChatModel.fromMap(Map<String, dynamic> map) => ChatModel(
        chatID: map['chatID'] ?? '',
        participants: List<String>.from(map['participants'] ?? []),
        lastMessage: map['lastMessage'] ?? '',
        lastMessageTime: map['lastMessageTime'] != null
            ? DateTime.tryParse(map['lastMessageTime']) ?? DateTime.now()
            : DateTime.now(),
        lastSenderID: map['lastSenderID'] ?? '',
        participantNames: Map<String, String>.from(map['participantNames'] ?? {}),
        participantAvatars: Map<String, String>.from(map['participantAvatars'] ?? {}),
      );
}
