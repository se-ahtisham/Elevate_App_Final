

class FollowRequestModel {
  final String requestID;   // PK
  final String fromID;      // userID of the person SENDING the request
  final String toID;        // userID of the person RECEIVING the request
  final bool status;        // false = Pending, true = Accepted
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
