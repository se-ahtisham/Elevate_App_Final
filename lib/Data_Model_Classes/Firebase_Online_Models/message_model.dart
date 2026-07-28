class MessageModel {
  final String messageID;
  final String chatID;
  final String senderID;
  final String senderName;
  final String text;
  final DateTime sentAt;
  final bool isRead;

  MessageModel({
    required this.messageID,
    required this.chatID,
    required this.senderID,
    required this.senderName,
    required this.text,
    DateTime? sentAt,
    this.isRead = false,
  }) : sentAt = sentAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'messageID': messageID,
        'chatID': chatID,
        'senderID': senderID,
        'senderName': senderName,
        'text': text,
        'sentAt': sentAt.toIso8601String(),
        'isRead': isRead,
      };

  factory MessageModel.fromMap(Map<String, dynamic> map) => MessageModel(
        messageID: map['messageID'] ?? '',
        chatID: map['chatID'] ?? '',
        senderID: map['senderID'] ?? '',
        senderName: map['senderName'] ?? '',
        text: map['text'] ?? '',
        sentAt: map['sentAt'] != null
            ? DateTime.tryParse(map['sentAt']) ?? DateTime.now()
            : DateTime.now(),
        isRead: map['isRead'] ?? false,
      );
}
