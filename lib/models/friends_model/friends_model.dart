class FriendsModel{
  String userId;
  List friendsIds;

  FriendsModel({
    required this.userId,
    required this.friendsIds,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': this.userId,
      'friendsIds': this.friendsIds,
    };
  }

  factory FriendsModel.fromMap(Map<String, dynamic> map) {
    return FriendsModel(
      userId: map['userId'] as String,
      friendsIds: map['friendsIds'] as List,
    );
  }
}