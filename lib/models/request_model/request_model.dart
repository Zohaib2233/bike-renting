class RequestModel{
  String requestedTo;
  String requestedFrom;
  DateTime requestedAt;
  String docId;
  String requestStatus;

  RequestModel({
    required this.requestedTo,
    required this.requestedFrom,
    required this.requestedAt,
    required this.docId,
    required this.requestStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'requestedTo': this.requestedTo,
      'requestedFrom': this.requestedFrom,
      'requestedAt': this.requestedAt,
      'docId': this.docId,
      'requestStatus': this.requestStatus,
    };
  }

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      requestedTo: map['requestedTo'] as String,
      requestedFrom: map['requestedFrom'] as String,
      requestedAt: map['requestedAt'].toDate(),
      docId: map['docId'] as String,
      requestStatus: map['requestStatus'] as String,
    );
  }
}