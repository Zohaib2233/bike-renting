import 'package:bike_gps/core/env/keys.dart';
import 'package:bike_gps/core/utils/google_maps/flutter_google_maps_utils.dart';
import 'package:bike_gps/main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel {
  String? placeId;
  String? businessStatus;
  String? name;
  String? type;
  String? photo;
  LatLng? latLng;

  PlaceModel({
    required this.placeId,
    required this.businessStatus,
    required this.name,
    required this.type,
    required this.photo,
    required this.latLng,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> map) {
    return PlaceModel(
      placeId: map['place_id'] ?? "",
      businessStatus: map['business_status'] ?? "",
      name: map['name'] ?? "",
      type: map['types'].isNotEmpty ? map['types'].first : "",
      photo: map.containsKey('photos') && map['photos'].isNotEmpty
          ? FlutterGoogleMapsUtils.instance.getPhotoUrlFromPhotoRef(
              photoRef: map['photos'].first['photo_reference'],
              mapsApiKey: googleMapsApiKey,
            )
          : dummyPlaceImg,
      latLng: map['geometry']['location'] != null
          ? LatLng(
              map['geometry']['location']['lat'],
              map['geometry']['location']['lng'],
            )
          : LatLng(0.0, 0.0),
    );
  }
}
