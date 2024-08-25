import 'dart:developer';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/enums/location_permission.dart';
import 'package:bike_gps/core/env/keys.dart';
import 'package:bike_gps/core/utils/permissions/permissions.dart';
import 'package:bike_gps/services/api/api.dart';
import 'package:bike_gps/view/widget/dialogs/permission_dialog.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class GoogleMapsService {
  //private constructor
  GoogleMapsService._privateConstructor();

  //singleton instance variable
  static GoogleMapsService? _instance;

  //This code ensures that the singleton instance is created only when it's accessed for the first time.
  //Subsequent calls to GoogleMapsService.instance will return the same instance that was created before.

  //getter to access the singleton instance
  static GoogleMapsService get instance {
    _instance ??= GoogleMapsService._privateConstructor();
    return _instance!;
  }

  //method to create geohash
  Future<Map> createGeoHash({required LatLng latLng}) async {
    final geo = GeoFlutterFire();

    try {
      //creating geo hash
      GeoFirePoint geohash =
          geo.point(latitude: latLng.latitude, longitude: latLng.longitude);

      return geohash.data;
    } catch (e) {
      log("This exception occurred while creating geohash: $e");

      return {};
    }
  }

  //method to get user's location
  Future<Position> _determinePosition() async {
    bool serviceEnabled;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // return Future.error('Location services are disabled.');

      Get.dialog(PermissionDialog(
          onAllowTap: () {
            openAppSettings();
          },
          description: "Please turn on the device location",
          permission: "",
          icon: Assets.imagesEventIcon));
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  //method to check if the user has allowed location permission and get the user location
  Future<Position?> getUserLocation() async {
    //user location
    Position? userLocation;

    //getting location permission status
    LocationPermissionStatus status =
        await PermissionService.instance.getLocationPermissionStatus();

    if (status == LocationPermissionStatus.granted) {
      userLocation = await _determinePosition();
    } else if (status == LocationPermissionStatus.permanentlyDenied) {
      await Get.dialog(PermissionDialog(
        onAllowTap: () {
          //opening app settings to allow user to give permissions
          openAppSettings();
        },
        permission: "Location",
        icon: Assets.imagesEventIcon,
      ));

      //closing dialog
      Get.back();

      //getting permission status again
      LocationPermissionStatus status =
          await PermissionService.instance.getLocationPermissionStatus();

      if (status == LocationPermissionStatus.granted) {
        userLocation = await _determinePosition();
      }
    } else if (status == LocationPermissionStatus.denied) {
      LocationPermissionStatus status =
          await PermissionService.instance.getLocationPermissionStatus();
      if (status == LocationPermissionStatus.granted) {
        userLocation = await _determinePosition();
      }
    }

    return userLocation;
  }

  //method to get polyline points
  Future<List<LatLng>?> getPolylinePoints(
      {required LatLng startLocation,
      required LatLng endLocation,
      required String googleMapsApiKey}) async {
    PolylinePoints polylinePoints = PolylinePoints();

    List<LatLng> polylineCoordinates = [];

    try {
      // PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      //   request: ,
      //   googleMapsApiKey,
      //   PointLatLng(startLocation.latitude, startLocation.longitude),
      //   PointLatLng(endLocation.latitude, endLocation.longitude),
      //   // travelMode: TravelMode.driving,
      // );

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: googleMapsApiKey,
        request: PolylineRequest(
          origin: PointLatLng(startLocation.latitude, startLocation.longitude),
          destination: PointLatLng(endLocation.latitude, endLocation.longitude),
          mode: TravelMode.driving,
          wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")],
        ),
      );

      if (result.points.isNotEmpty) {
        //adding polyline points in polyLineCoordinates
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });

        //polyline coordinates of two points
        return polylineCoordinates;
      } else {
        log("This was the error while getting polyline points: ${result.errorMessage}");
        return null;
      }
    } catch (e) {
      log("This was the exception while getting polyline points: $e");
      return null;
    }
  }

  //method to get reverse geocoded address
  Future<Map?> getReverseGeocodedAddress({required LatLng latLng}) async {
    //creating apiUrl
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$googleMapsApiKey";

    Map<String, dynamic>? response =
        await APIService.instance.get(apiUrl, true);

    if (response != null) {
      return response;
    }

    return null;
  }

  //method to get country name from a LatLng
  Future<String> getCountryName({required LatLng latLng}) async {
    Map? reverseGeocodedAddress =
        await getReverseGeocodedAddress(latLng: latLng);

    try {
      if (reverseGeocodedAddress != null) {
        if (reverseGeocodedAddress['results'][0].isNotEmpty) {
          //getting result map
          List addressComponents =
              reverseGeocodedAddress['results'][0]['address_components'];

          //finding country name
          for (final component in addressComponents) {
            final types = List<String>.from(component['types']);

            if (types.contains('country')) {
              String country = component['long_name'];

              return country;
            }
          }
        }
      }
    } catch (e) {
      log("This exception occurred while getting country name: $e");
    }

    return "";
  }
}
