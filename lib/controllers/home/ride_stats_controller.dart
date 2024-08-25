import 'dart:async';
import 'package:bike_gps/core/constants/firebase_collection_references.dart';
import 'package:bike_gps/core/constants/instances_constants.dart';
import 'package:bike_gps/core/enums/location_permission.dart';
import 'package:bike_gps/core/utils/formatters/date_fromatter.dart';
import 'package:bike_gps/core/utils/permissions/permissions.dart';
import 'package:bike_gps/models/user_models/user_stats_model.dart';
import 'package:bike_gps/services/firebase/firebase_crud.dart';
import 'package:bike_gps/services/google_maps/google_maps.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class RideStatsController extends GetxController {
  //location change stream
  late StreamSubscription<Position> positionStream;

  //to calculate the total distance travelled
  Position? _previousPosition;

  //total distance covered using app
  double _totalDistanceInMeters = 0.0;

  //time when user opened the app
  DateTime appOpenedOn = DateTime.now();

  //method to get user stats data
  Future<UserStatsModel> getUserStats() async {
    //user stats model
    UserStatsModel userStatsModel = UserStatsModel(
      userId: "",
      timeSpent: 0,
      avgSpeed: 0,
      totalDistance: 0,
      avgPulse: 0,
    );

    //getting user stats data
    var userStatsData = await FirebaseCRUDService.instance.readSingleDocument(
      collectionReference: userStatsCollection,
      docId: userModelGlobal.value.userId!,
    );

    if (userStatsData != null) {
      //initializing UserStatsModel
      userStatsModel = UserStatsModel.fromJson(userStatsData);
    }

    return userStatsModel;
  }

  //method to update user stats
  Future<void> updateUserStats() async {
    await FirebaseCRUDService.instance.updateDocument(
      collection: userStatsCollection,
      docId: userModelGlobal.value.userId!,
      data: {
        "totalDistance": FieldValue.increment(_totalDistanceInMeters),
        "timeSpent": FieldValue.increment(_measureTimeSpent()),
      },
    );
  }

  //method to measure the time spent in app
  double _measureTimeSpent() {
    //time when user closed the app
    DateTime appClosedOn = DateTime.now();

    //getting time spent on app in seconds
    int timeSpentInSec = DateFormatters.instance
        .getTimeDifferenceInSec(start: appOpenedOn, end: appClosedOn);

    return timeSpentInSec.toDouble();
  }

  //method to handle realtime location updates
  Future<void> _handleRealtimeLocationUpdates(
      {required Position position}) async {
    //getting user id
    String userId = FirebaseAuth.instance.currentUser!.uid;

    if (_previousPosition != null) {
      double distanceInMeters = Geolocator.distanceBetween(
        _previousPosition!.latitude,
        _previousPosition!.longitude,
        position.latitude,
        position.longitude,
      );

      _totalDistanceInMeters += distanceInMeters;
    }

    // Update previous position
    _previousPosition = position;

    final geo = GeoFlutterFire();

    //creating geo point
    GeoFirePoint userGeoHash =
        geo.point(latitude: position.latitude, longitude: position.longitude);

    //updating user's realtime location
    await FirebaseCRUDService.instance.updateDocumentSingleKey(
      collection: usersCollection,
      docId: userId,
      key: "geoHash",
      value: userGeoHash.data,
    );
  }

  //method to get location permission status
  void locateUser() async {
    await GoogleMapsService.instance.getUserLocation();

    //getting location permission status
    LocationPermissionStatus status =
        await PermissionService.instance.getLocationPermissionStatus();

    //getting user realtime location updates, if he has granted the permission
    if (status == LocationPermissionStatus.granted) {
      _getRealtimeLocationStream();
    }
  }

  //method to get realtime location of a driver
  void _getRealtimeLocationStream() {
    //initializing location settings
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    //listening to realtime location change updates
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) async {
      if (position != null) {
        //handling realtime location updates of a driver
        await _handleRealtimeLocationUpdates(position: position);
      }
    });
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
