import 'package:cloud_firestore/cloud_firestore.dart';

class PostReportModel {
  String? id;
  String? postId;
  String? reportReason;
  String? reportedBy;
  DateTime? reportedOn;

  PostReportModel({
    required this.id,
    required this.postId,
    required this.reportReason,
    required this.reportedBy,
    required this.reportedOn,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'postId': postId,
      'reportReason': reportReason,
      'reportedBy': reportedBy,
      'reportedOn': reportedOn,
    };
  }

  factory PostReportModel.fromJson(DocumentSnapshot snapshot) {
    //converting snapshot into map
    Map map = snapshot.data() as Map;

    return PostReportModel(
      id: map.containsKey("id") ? map['id'] ?? "" : "",
      postId: map.containsKey("postId") ? map['postId'] ?? "" : "",
      reportReason:
          map.containsKey("reportReason") ? map['reportReason'] ?? "" : "",
      reportedBy: map.containsKey("reportedBy") ? map['reportedBy'] ?? "" : "",
      reportedOn: map.containsKey("reportedOn") ? map['reportedOn'] ?? "" : "",
    );
  }
}
