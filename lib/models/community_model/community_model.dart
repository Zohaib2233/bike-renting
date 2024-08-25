class CommunityModel{
  String name;
  String docId;
  String address;
  String picture;
  String createdByUser;
  DateTime createdAt;
  List members;

  CommunityModel({
    required this.name,
    required this.docId,
    required this.address,
    required this.picture,
    required this.createdByUser,
    required this.createdAt,
    required this.members,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'docId': this.docId,
      'address': this.address,
      'picture': this.picture,
      'createdByUser': this.createdByUser,
      'createdAt': this.createdAt,
      'members': this.members,
    };
  }

  factory CommunityModel.fromMap(Map<String, dynamic> map) {
    return CommunityModel(
      name: map['name'] as String,
      docId: map['docId'] as String,
      address: map['address'] as String,
      createdByUser: map['createdByUser'] as String,
      picture: map['picture'] as String,
      createdAt: map['createdAt'].toDate(),
      members: map['members'] as List,
    );
  }
}