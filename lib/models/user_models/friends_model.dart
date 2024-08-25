import 'package:cloud_firestore/cloud_firestore.dart';

class FriendsModel {
  String? userId;
  List? friendsIds;

  FriendsModel({
    required this.userId,
    required this.friendsIds,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'friendsIds': friendsIds,
    };
  }

  factory FriendsModel.fromJson(DocumentSnapshot map) {
    return FriendsModel(
      userId: map['userId'] != null ? map['userId'] : "",
      friendsIds: map['friendsIds'] != null ? map['friendsIds'] : [],
    );
  }
}
