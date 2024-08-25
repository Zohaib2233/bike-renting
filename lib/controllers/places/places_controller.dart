import 'dart:async';
import 'dart:developer';
import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/constants/base_urls.dart';
import 'package:bike_gps/core/constants/firebase_collection_references.dart';
import 'package:bike_gps/core/env/keys.dart';
import 'package:bike_gps/core/utils/google_maps/flutter_google_maps_utils.dart';
import 'package:bike_gps/core/utils/snackbars.dart';
import 'package:bike_gps/models/google_maps/place_model.dart';
import 'package:bike_gps/models/recent_place_search_model/recent_place_search_model.dart';
import 'package:bike_gps/models/user_models/friends_model.dart';
import 'package:bike_gps/models/user_models/user_model.dart';
import 'package:bike_gps/services/api/api.dart';
import 'package:bike_gps/services/firebase/firebase_crud.dart';
import 'package:bike_gps/services/google_maps/google_maps.dart';
import 'package:bike_gps/services/local_storage/local_storage.dart';
import 'package:bike_gps/view/screens/bike_community/search_community.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

class PlacesController extends GetxController {
  //google map completer
  final Completer<GoogleMapController> mapController1 =
      Completer<GoogleMapController>();

  final Completer<GoogleMapController> mapController2 =
      Completer<GoogleMapController>();

  //markers to be added on google map
  List<MarkerData> markers = <MarkerData>[];

  //polyline for user pickup and dropoff
  Map<PolylineId, Polyline> polylines = {};

  //observable list of nearby places
  RxList<PlaceModel> nearbyPlaces = RxList<PlaceModel>([]);

  //observable list of nearby friends
  RxList<UserModel> nearbyFriends = RxList<UserModel>([]);

  //selected nearby place category
  RxString selectedNearbyPlaceCategory = "".obs;

  //nearby place category setter
  void set setNearbyPlaceCategory(String category) {
    selectedNearbyPlaceCategory.value = category;
  }

  //user location
  Position? userLocation;

  //animating camera
  void animateCamera1() async {
    final GoogleMapController googleMapController = await mapController1.future;

    if (userLocation != null) {
      //creating user latLng
      LatLng userLatLng =
          LatLng(userLocation!.latitude, userLocation!.longitude);

      //adding user location marker on map

      FlutterGoogleMapsUtils.instance.animateCamera(
        googleMapController: googleMapController,
        latLng: userLatLng,
      );

      // update();
    }
  }

  //animating camera
  void animateCamera2() async {
    final GoogleMapController googleMapController = await mapController2.future;

    if (userLocation != null) {
      //creating user latLng
      LatLng userLatLng =
          LatLng(userLocation!.latitude, userLocation!.longitude);

      //adding user location marker on map

      FlutterGoogleMapsUtils.instance.animateCamera(
        googleMapController: googleMapController,
        latLng: userLatLng,
      );

      // update();
    }
  }

  //getting user location
  Future<void> getUserLocation() async {
    userLocation = await GoogleMapsService.instance.getUserLocation();

    if (userLocation != null) {
      //creating user latLng
      LatLng _userLatLng =
          LatLng(userLocation!.latitude, userLocation!.longitude);

      //adding user marker on map
      MarkerData markerData = FlutterGoogleMapsUtils.instance.addMarker(
        markerLatLng: _userLatLng,
        markerId: "userMarker",
        placeName: "Your location",
        icon: Assets.imagesCurrentLocation,
      );

      //adding marker in markers list
      markers.add(markerData);

      //updating UI
      update();
    }
  }

  //method to call nearby places API
  void callNearbyPlacesAPI() async {
    await getUserLocation();

    if (userLocation != null) {
      await getNearbyPlaces();
    }
  }

  //method to handle nearby places response
  void _handleNearbyPlacesResp({required Map<String, dynamic> responseMap}) {
    if (responseMap['status'] == "OK") {
      //checking if the response contains nearby places data
      if (responseMap['results'].isNotEmpty) {
        //clearing list
        nearbyPlaces.value = [];

        //getting list of nearby places
        List places = responseMap['results'];

        //iterating places list and initializing places model
        for (var place in places) {
          //initializing PlaceModel
          PlaceModel placeModel = PlaceModel.fromJson(place);

          //adding place model in list
          nearbyPlaces.add(placeModel);
        }
      }
    }
  }

  //method to get nearby places
  Future<void> getNearbyPlaces(
      {String placeName = "", String category = "", int radius = 1500}) async {
    //making url for nearby API
    String nearbyPlacesAPIUrl = gooleMapsBaseUrl +
        "?keyword=$placeName&location=${userLocation!.latitude}%2C${userLocation!.longitude}&radius=$radius&type=$category=&key=$googleMapsApiKey";

    //calling nearby places search API
    Map<String, dynamic>? nearbyPlacesMap = await APIService.instance.get(
      nearbyPlacesAPIUrl,
      true,
    );

    //handling nearby places response
    if (nearbyPlacesMap != null) {
      _handleNearbyPlacesResp(responseMap: nearbyPlacesMap);
    }
  }

  //initialize RecentPlaceSearchModel
  Map<String, dynamic> _initRecentPlaceSearchModel(
      {required String placeName, required String placePhotoUrl}) {
    RecentPlaceSearchModel recentPlaceSearchModel = RecentPlaceSearchModel(
      name: placeName,
      photoUrl: placePhotoUrl,
    );

    return recentPlaceSearchModel.toJson();
  }

  //method to read recent searches from local storage
  Future<List<Map<String, dynamic>>> readRecentSearches() async {
    //getting recent searches list from local storage
    List recentPlaceSearches =
        await LocalStorageService.instance.read(key: "recentSearches") ?? [];

    List<Map<String, dynamic>> recentSearches = [];

    //adding recent searches maps in the list
    for (var recentSearchMap in recentPlaceSearches) {
      recentSearches.add(recentSearchMap);
    }

    return recentSearches;
  }

  //method to get recent place searches
  Future<List<RecentPlaceSearchModel>> getRecentPlaceSearches() async {
    List<RecentPlaceSearchModel> _recentPlaceSearches = [];

    //reading recent searches from local storage
    List<Map<String, dynamic>> recentSearches = await readRecentSearches();

    //adding recent place search models in the list
    for (Map<String, dynamic> recentSearch in recentSearches) {
      _recentPlaceSearches.add(RecentPlaceSearchModel.fromJson(recentSearch));
    }

    return _recentPlaceSearches;
  }

  //method to add recent place search history in local storage
  Future<void> addRecentPlaceSearchHistory(
      {required String placeName, required String placePhotoUrl}) async {
    //reading recent searches from local storage
    List<Map<String, dynamic>> recentPlaceSearches = await readRecentSearches();

    //making place search map
    Map<String, dynamic> placeSearchMap = _initRecentPlaceSearchModel(
      placeName: placeName,
      placePhotoUrl: placePhotoUrl,
    );

    //checking if the list is containing 5 searches, if it is containing 5 searches then we must have to remove the oldest one, and add the newest one (just to avoid over usage of memory)
    if (recentPlaceSearches.length > 4) {
      //removing the first element of the list as it is the oldest one
      recentPlaceSearches.removeAt(0);

      recentPlaceSearches.insert(0, placeSearchMap);
    } else {
      //adding recent place search in already existing list
      recentPlaceSearches.add(placeSearchMap);
    }

    //adding place name and place photo url in local storage (if the list is not containing more than 5 searches)
    await LocalStorageService.instance
        .write(key: "recentSearches", value: recentPlaceSearches);
  }

  //method to get nearby friends
  Future<List> getFriendsIds() async {
    //getting user Id
    String userId = FirebaseAuth.instance.currentUser!.uid;

    FriendsModel friendsModel = FriendsModel(
      userId: "",
      friendsIds: [],
    );

    //getting friends ids
    QueryDocumentSnapshot? friendsDoc =
        await FirebaseCRUDService.instance.readSingleDocByFieldName(
      collectionReference: friendsCollection,
      fieldName: 'userId',
      fieldValue: userId,
    );

    if (friendsDoc != null) {
      //initializing FriendsModel
      friendsModel = FriendsModel.fromJson(friendsDoc);
    }

    return friendsModel.friendsIds!;
  }

  //method to open friend detail bottom sheet
  void _openFriendDetailBottomSheet({required UserModel friendModel}) async {
    //getting LatLng from geohash map
    LatLng friendLatLng = FlutterGoogleMapsUtils.instance
        .getLatLngFromGeohash(geoHash: friendModel.geoHash!);

    String address = await FlutterGoogleMapsUtils.instance
        .getAddressFromLatLng(latLng: friendLatLng);

    String timeToReach = "";

    if (userLocation != null) {
      //creating user latLng
      LatLng userLatLng =
          LatLng(userLocation!.latitude, userLocation!.longitude);

      //getting time to reach to a friend
      Duration travelTime = FlutterGoogleMapsUtils.instance
          .calculateTravelTime(userLatLng, friendLatLng, averageSpeedKmph: 20);

      timeToReach = travelTime.inHours.toString();
    }

    Get.bottomSheet(
      FriendDetailBottomSheet(
        img: friendModel.profilePic!,
        name: friendModel.fullName!,
        address: address,
        isOnline: friendModel.isOnline!,
        lastActiveOn: DateTime.now(),
        timeToReach: timeToReach,
        onLocateFriendTap: () async {
          if (userLocation != null) {
            //creating user latLng
            LatLng userLatLng =
                LatLng(userLocation!.latitude, userLocation!.longitude);

            //getting polyline points
            List<LatLng>? polylineCoordinates =
                await GoogleMapsService.instance.getPolylinePoints(
              startLocation: userLatLng,
              endLocation: friendLatLng,
              googleMapsApiKey: googleMapsApiKey,
            );

            if (polylineCoordinates != null && polylineCoordinates.isNotEmpty) {
              //drawing polyline on map
              drawPolyLine(polylineCoordinates: polylineCoordinates);
            }
          } else {
            CustomSnackBars.instance.showFailureSnackbar(
                title: "Location Disables",
                message: "Your location is not enabled");
          }
        },
      ),
      isScrollControlled: true,
    );
  }

  //method to handle nearby friends list
  void _handleNearbyFriendsList(
      {required List<DocumentSnapshot> documentList,
      required List friendsIds}) {
    log("Nearby friends list: $documentList");
    //adding documents to nearbyFriends list (binding stream)
    for (var doc in documentList) {
      //getting user id
      String friendId = doc.get("userId");

      //adding only those users that are in the user's friend list
      if (friendsIds.contains(friendId)) {
        log("friend doc: $doc");
        //initializing user model for friend
        UserModel friendModel = UserModel.fromJson(doc);

        //adding friend model in list
        nearbyFriends.add(friendModel);

        //getting friend location
        LatLng friendLatLng = FlutterGoogleMapsUtils.instance
            .getLatLngFromGeohash(geoHash: friendModel.geoHash!);

        //getting friend distance from user location
        double friendDistance =
            FlutterGoogleMapsUtils.instance.calculateDistance(
          LatLng(userLocation!.latitude, userLocation!.longitude),
          friendLatLng,
        );

        //adding friend marker on map
        MarkerData friendMarkerData = FlutterGoogleMapsUtils.instance.addMarker(
          markerLatLng: friendLatLng,
          markerId: friendModel.userId!,
          placeName: friendModel.fullName! +
              " " +
              friendDistance.toStringAsFixed(2) +
              " km",
          icon: Assets.imagesFriendMarker,
          onTap: () {
            _openFriendDetailBottomSheet(friendModel: friendModel);
          },
        );

        markers.add(friendMarkerData);

        //updating UI after adding the marker
        update();
      }
    }
  }

  //method to get nearby friends
  Future<void> getNearbyFriends() async {
    try {
      //getting user friends ids
      List _friendsIds = await getFriendsIds();

      //radius for the nearby places query
      final radius = BehaviorSubject<double>.seeded(15); //pass the radius in km

      GeoFlutterFire geo = GeoFlutterFire();

      //center point for fetching the nearby places
      GeoFirePoint centerPoint = geo.point(
        latitude: userLocation!.latitude,
        longitude: userLocation!.longitude,
      );

      //for getting places snapshots
      Stream<List<DocumentSnapshot>> nearbyFriendsStream =
          radius.switchMap((rad) {
        return geo.collection(collectionRef: usersCollection).within(
            center: centerPoint,
            radius: rad,
            field: 'geoHash',
            strictMode: true);
      });

      //adding neaby frinds snapshots to reactive list
      nearbyFriendsStream.listen((List<DocumentSnapshot> documentList) {
        //handling nearby friends list
        _handleNearbyFriendsList(
          documentList: documentList,
          friendsIds: _friendsIds,
        );
      });
    } catch (e) {
      CustomSnackBars.instance.showFailureSnackbar(
          title: "Failure", message: "Error getting nearby friends!");
    }
  }

  //method to draw polyline between user and his friend
  void drawPolyLine({required List<LatLng> polylineCoordinates}) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: kRedColor,
      points: polylineCoordinates,
      width: 4,
    );
    polylines[id] = polyline;

    update();
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();

    await getUserLocation();
  }
}
