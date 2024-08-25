import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? userId;
  String? fullName;
  String? userName;
  String? email;
  String? phoneNo;
  String? phoneCode;
  String? profilePic;
  Map? geoHash;
  String? deviceToken;
  String? userType;
  String? country;
  DateTime? joinedOn;
  double? rating;
  int? totalRides;
  bool? isOnline;
  bool? isShowOnline;
  List? favorites;
  bool? isAdditionalInfoFilled;
  bool? isShowNotification;
  Map? bikeLastKnownLocGeohash;

  DateTime? lastSeenOn;
  DateTime? lastKnownLocFetchedOn;
  String? bikeLastKnownLocation;
  bool? isBikeLocked;
  bool? isBikeStolen;
  bool? isSocialSignIn;

  //bike info
  String? bikeName;
  String? bikeType;
  String? bikeModel;
  String? bikeColor;
  String? bikeFrameNo;
  String? bikeIMEINo;
  bool? isElectricBike;
  List? bikePics;
  List? docsPics;

  UserModel({
    required this.userId,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.phoneNo,
    required this.phoneCode,
    required this.profilePic,
    required this.geoHash,
    required this.deviceToken,
    required this.userType,
    required this.country,
    required this.joinedOn,
    required this.rating,
    required this.totalRides,
    required this.isOnline,
    required this.isShowOnline,
    required this.favorites,
    required this.isAdditionalInfoFilled,
    required this.isShowNotification,
    required this.bikeName,
    required this.bikeType,
    required this.bikeModel,
    required this.bikeColor,
    required this.bikeFrameNo,
    required this.bikeIMEINo,
    required this.isElectricBike,
    required this.bikePics,
    required this.docsPics,
    required this.lastSeenOn,
    required this.lastKnownLocFetchedOn,
    required this.bikeLastKnownLocation,
    required this.bikeLastKnownLocGeohash,
    required this.isBikeLocked,
    required this.isBikeStolen,
    required this.isSocialSignIn,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'fullName': fullName,
      'userName': userName,
      'email': email,
      'phoneNo': phoneNo,
      'phoneCode': phoneCode,
      'profilePic': profilePic,
      'geoHash': geoHash,
      'deviceToken': deviceToken,
      'userType': userType,
      'country': country,
      'joinedOn': joinedOn,
      'rating': rating,
      'totalRides': totalRides,
      'isOnline': isOnline,
      'isShowOnline': isShowOnline,
      'favorites': favorites,
      'isAdditionalInfoFilled': isAdditionalInfoFilled,
      'isShowNotification': isShowNotification,
      'bikeName': bikeName,
      'bikeType': bikeType,
      'bikeModel': bikeModel,
      'bikeColor': bikeColor,
      'bikeFrameNo': bikeFrameNo,
      'bikeIMEINo': bikeIMEINo,
      'isElectricBike': isElectricBike,
      'bikePics': bikePics,
      'docsPics': docsPics,
      'lastSeenOn': lastSeenOn,
      'lastKnownLocFetchedOn': lastKnownLocFetchedOn,
      'bikeLastKnownLocation': bikeLastKnownLocation,
      'bikeLastKnownLocGeohash': bikeLastKnownLocGeohash,
      'isBikeLocked': isBikeLocked,
      'isBikeStolen': isBikeStolen,
      'isSocialSignIn': isSocialSignIn,
    };
  }

  factory UserModel.fromJson(DocumentSnapshot snapshot) {
    //converting DocumentSnapshot into map
    Map map = snapshot.data() as Map;
    return UserModel(
      userId: map['userId'],
      fullName: map['fullName'],
      userName: map['userName'],
      email: map['email'],
      phoneNo: map['phoneNo'],
      phoneCode: map['phoneCode'],
      profilePic: map['profilePic'],
      geoHash: map['geoHash'],
      deviceToken: map['deviceToken'],
      userType: map['userType'],
      country: map['country'],
      joinedOn: map['joinedOn'].toDate(),
      rating: map['rating'],
      totalRides: map['totalRides'],
      isOnline: map['isOnline'],
      isShowOnline: map['isShowOnline'],
      favorites: map['favorites'],
      isAdditionalInfoFilled: map['isAdditionalInfoFilled'],
      isShowNotification: map['isShowNotification'],
      bikeName: map['bikeName'],
      bikeType: map['bikeType'],
      bikeModel: map['bikeModel'],
      bikeColor: map['bikeColor'],
      bikeFrameNo: map['bikeFrameNo'],
      bikeIMEINo: map.containsKey("bikeIMEINo") ? map['bikeIMEINo'] : "",
      isElectricBike: map['isElectricBike'],
      bikePics: map['bikePics'],
      docsPics: map['docsPics'],
      lastSeenOn: map['lastSeenOn'].toDate(),
      lastKnownLocFetchedOn: map['lastKnownLocFetchedOn'].toDate(),
      bikeLastKnownLocation: map['bikeLastKnownLocation'],
      bikeLastKnownLocGeohash: map['bikeLastKnownLocGeohash'],
      isBikeLocked: map['isBikeLocked'],
      isBikeStolen: map['isBikeStolen'],
      isSocialSignIn:
          map.containsKey('isSocialSignIn') ? map['isSocialSignIn'] : false,
    );
  }
}
