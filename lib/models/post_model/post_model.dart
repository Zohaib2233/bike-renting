import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String docId;
  String caption;
  String postedByUser;
  DateTime createAt;
  List postImages;
  String communityId;
  List likes;
  int comments;

  PostModel({
    required this.docId,
    required this.caption,
    required this.postedByUser,
    required this.createAt,
    required this.postImages,
    required this.communityId,
    required this.likes,
    required this.comments,
  });

  Map<String, dynamic> toMap() {
    return {
      'docId': this.docId,
      'caption': this.caption,
      'postedByUser': this.postedByUser,
      'createAt': this.createAt,
      'postImages': this.postImages,
      'communityId': this.communityId,
      'likes': this.likes,
      'comments': this.comments,
    };
  }

  factory PostModel.fromMap(DocumentSnapshot map) {
    return PostModel(
      docId: map['docId'] as String,
      caption: map['caption'] as String,
      postedByUser: map['postedByUser'] as String,
      createAt: map['createAt'].toDate(),
      postImages: map['postImages'] as List,
      communityId: map['communityId'] as String,
      likes: map['likes'] as List,
      comments: map['comments'] as int,
    );
  }
}
