import 'package:bike_gps/models/post_model/user_fav_post_model.dart';
import 'package:bike_gps/models/user_models/user_model.dart';
import 'package:get/get.dart';

//user model for global access
Rx<UserModel> userModelGlobal = UserModel(
  userId: "",
  fullName: "",
  userName: "",
  email: "",
  phoneNo: "",
  phoneCode: "",
  profilePic: "",
  geoHash: {},
  deviceToken: "",
  userType: "",
  country: "",
  joinedOn: DateTime.now(),
  rating: 0.0,
  totalRides: 0,
  isOnline: false,
  isShowOnline: false,
  favorites: [],
  isAdditionalInfoFilled: false,
  isShowNotification: true,
  bikeName: "",
  bikeType: "",
  bikeModel: "",
  bikeColor: "",
  bikeFrameNo: "",
  bikeIMEINo: "",
  isElectricBike: false,
  bikePics: [],
  docsPics: [],
  lastSeenOn: DateTime.now(),
  lastKnownLocFetchedOn: DateTime.now(),
  bikeLastKnownLocation: "",
  bikeLastKnownLocGeohash: {},
  isBikeLocked: false,
  isBikeStolen: false,
  isSocialSignIn: false,
).obs;

//user fav post model (for global access)
Rx<UserFavPostModel> userFavPostModelGlobal = UserFavPostModel(
  userId: "",
  favPosts: [],
).obs;
