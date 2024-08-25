import 'package:cloud_firestore/cloud_firestore.dart';

class UserFavPostModel {
  String? userId;
  List? favPosts;

  UserFavPostModel({
    required this.userId,
    required this.favPosts,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': this.userId,
      'favPosts': this.favPosts,
    };
  }

  factory UserFavPostModel.fromJson(DocumentSnapshot map) {
    return UserFavPostModel(
      userId: map['userId'],
      favPosts: map['favPosts'],
    );
  }
}
