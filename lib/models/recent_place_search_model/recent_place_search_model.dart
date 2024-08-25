class RecentPlaceSearchModel {
  String? name;
  String? photoUrl;

  RecentPlaceSearchModel({
    required this.name,
    required this.photoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'photoUrl': photoUrl,
    };
  }

  factory RecentPlaceSearchModel.fromJson(Map<String, dynamic> map) {
    return RecentPlaceSearchModel(
      name: map['name'],
      photoUrl: map['photoUrl'],
    );
  }
}
