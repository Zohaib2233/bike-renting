import 'dart:async';

import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/constants/instances_constants.dart';
import 'package:bike_gps/core/utils/google_maps/flutter_google_maps_utils.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FindBikeController extends GetxController {
  //markers to be added on google map
  List<MarkerData> markers = <MarkerData>[];

  //google map completer
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  //method to add user bike marker on map
  void _addBikeMarkerOnMap({required LatLng bikeLatLng}) {
    //adding user marker on map
    MarkerData markerData = FlutterGoogleMapsUtils.instance.addMarker(
      markerLatLng: bikeLatLng,
      markerId: "bikeMarker",
      placeName: "Your bike",
      icon: Assets.imagesBike,
    );

    //adding marker in markers list
    markers.add(markerData);

    //updating UI
    update();
  }

  //animating camera
  void animateCamera() async {
    final GoogleMapController googleMapController = await mapController.future;

    //getting bike latLng from the geohash
    LatLng bikeLatLng = FlutterGoogleMapsUtils.instance.getLatLngFromGeohash(
        geoHash: userModelGlobal.value.bikeLastKnownLocGeohash!);

    //adding bike marker on the map
    _addBikeMarkerOnMap(bikeLatLng: bikeLatLng);

    //adding user bike location marker on map
    FlutterGoogleMapsUtils.instance.animateCamera(
      googleMapController: googleMapController,
      latLng: bikeLatLng,
    );
  }
}
