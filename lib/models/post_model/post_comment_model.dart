import 'package:cloud_firestore/cloud_firestore.dart';

class PostCommentModel {
  String? commentId;
  String? commentatorId;
  String? comment;
  String? commentedOnPost;
  DateTime? commentedOn;

  PostCommentModel({
    required this.commentId,
    required this.commentatorId,
    required this.comment,
    required this.commentedOnPost,
    required this.commentedOn,
  });

  Map<String, dynamic> toJson() {
    return {
      'commentId': this.commentId,
      'commentatorId': this.commentatorId,
      'comment': this.comment,
      'commentedOnPost': this.commentedOnPost,
      'commentedOn': this.commentedOn,
    };
  }

  factory PostCommentModel.fromJson(DocumentSnapshot map) {
    return PostCommentModel(
      commentId: map['commentId'],
      commentatorId: map['commentatorId'],
      comment: map['comment'],
      commentedOnPost: map['commentedOnPost'],
      commentedOn: map['commentedOn'].toDate(),
    );
  }
}
