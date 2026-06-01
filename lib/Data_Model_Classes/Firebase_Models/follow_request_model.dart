// follow_request_model.dart
// Sent when a user wants to follow another user.
// Collection: 'followRequests' — doc ID = requestID.

class FollowRequestModel {
  final String requestID;
  final String fromID;
  final String toID;
  final bool status; // false = pending, true = accepted
  final DateTime timeDate;

  FollowRequestModel({
    required this.requestID,
    required this.fromID,
    required this.toID,
    this.status = false,
    DateTime? timeDate,
  }) : timeDate = timeDate ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'requestID': requestID,
      'fromID': fromID,
      'toID': toID,
      'status': status,
      'timeDate': timeDate.toIso8601String(),
    };
  }

  factory FollowRequestModel.fromMap(Map<String, dynamic> map) {
    return FollowRequestModel(
      requestID: map['requestID'] ?? '',
      fromID: map['fromID'] ?? '',
      toID: map['toID'] ?? '',
      status: map['status'] ?? false,
      timeDate: map['timeDate'] != null
          ? DateTime.parse(map['timeDate'])
          : DateTime.now(),
    );
  }
}
