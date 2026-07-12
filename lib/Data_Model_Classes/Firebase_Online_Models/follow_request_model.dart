class FollowRequestModel {
  final String requestID;
  final String fromID;
  final String toID;
  final String status; // Pending/Accepted/Rejected
  final DateTime requestedAt;

  FollowRequestModel({
    required this.requestID,
    required this.fromID,
    required this.toID,
    this.status = 'Pending',
    DateTime? requestedAt,
  }) : requestedAt = requestedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'requestID': requestID,
      'fromID': fromID,
      'toID': toID,
      'status': status,
      'requestedAt': requestedAt.toIso8601String(),
    };
  }

  factory FollowRequestModel.fromMap(Map<String, dynamic> map) {
    return FollowRequestModel(
      requestID: map['requestID'] ?? '',
      fromID: map['fromID'] ?? '',
      toID: map['toID'] ?? '',
      status: map['status'] ?? 'Pending',
      requestedAt: map['requestedAt'] != null
          ? DateTime.tryParse(map['requestedAt'])
          : DateTime.now(),
    );
  }
}
