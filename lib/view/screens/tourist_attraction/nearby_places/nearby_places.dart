import 'package:bike_gps/controllers/places/places_controller.dart';
import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/utils/google_maps/flutter_google_maps_utils.dart';
import 'package:bike_gps/view/screens/friends/friends.dart';
import 'package:bike_gps/view/screens/tourist_attraction/nearby_places/nearby_places_bottom_sheet.dart';
import 'package:bike_gps/view/widget/common_image_view_widget.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/bindings/bindings.dart';

// ignore: must_be_immutable
class NearbyPlaces extends StatefulWidget {
  NearbyPlaces({super.key});

  @override
  State<NearbyPlaces> createState() => _NearbyPlacesState();
}

class _NearbyPlacesState extends State<NearbyPlaces> {
  //finding PlacesController
  PlacesController placesController = Get.find<PlacesController>();

  @override
  void initState() {
    super.initState();

    //getting nearby friends of user
    if (placesController.userLocation != null) {
      placesController.getNearbyFriends();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // _BuildMap(),
          GetBuilder<PlacesController>(builder: (ctrlr) {
            return CustomGoogleMapMarkerBuilder(
                customMarkers: ctrlr.markers,
                builder: (BuildContext context, Set<Marker>? markers) {
                  return GoogleMap(
                    mapType: MapType.normal,
                    zoomControlsEnabled: true,
                    initialCameraPosition:
                        FlutterGoogleMapsUtils.instance.kGooglePlex,
                    markers: markers ?? {},
                    // polylines: Set<Polyline>.of(userRideController.polylines.values),
                    onMapCreated: (GoogleMapController googleMapController) {
                      if (!ctrlr.mapController1.isCompleted) {
                        ctrlr.mapController1.complete(googleMapController);
                      }

                      ctrlr.animateCamera1();
                    },
                  );
                });
          }),

          _BuildSettingsTile(
            onTap: () {
              Get.bottomSheet(
                NearbyBottomSheet(),
                isScrollControlled: true,
              );
            },
          ),
          // Positioned(
          //     top: 120,
          //     right: 10,
          //     child: CommonImageView(
          //       imagePath: Assets.imagesPlacesIcon,
          //       height: 90,
          //     )),

          Positioned(
              top: 120,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  Get.to(() => Friends(), binding: FriendsBinding());
                },
                child: CommonImageView(
                  imagePath: Assets.imagesFriendIcon,
                  height: 90,
                ),
              )),
          // Positioned(
          //   right: 30,
          //   top: 150,
          //   child: GestureDetector(
          //     onTap: () {
          //       placesController.animateCamera();
          //     },
          //     child: Image.asset(
          //       Assets.imagesYellowCycle,
          //       height: 66,
          //     ),
          //   ),
          // ),
          // Positioned(
          //   left: 30,
          //   top: 350,
          //   child: ElevatedButton(
          //       onPressed: () {
          //         placesController.getFriendsIds();
          //       },
          //       child: null),
          // ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: DraggableScrollableSheet(
          //     expand: true,
          //     initialChildSize: 0.2,
          //     maxChildSize: 0.9,
          //     minChildSize: 0.12,
          //     builder: (context, scrollController) {
          //       return NearbyBottomSheet(
          //           controller: scrollController,
          //           );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}

class _BuildSettingsTile extends StatelessWidget {
  _BuildSettingsTile({required this.onTap});

  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: Row(
        children: [
          // GestureDetector(
          //   onTap: () => Get.back(),
          //   child: Image.asset(
          //     Assets.imagesArrowBack,
          //     height: 24,
          //   ),
          // ),
          // SizedBox(
          //   width: 12,
          // ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: TextFormField(
                onTap: onTap,
                textAlignVertical: TextAlignVertical.center,
                readOnly: true,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  prefixIcon: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Assets.imagesSearch,
                        height: 24,
                      ),
                    ],
                  ),
                  hintText: 'Search nearby places',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  filled: true,
                  fillColor: kPrimaryColor,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          // SizedBox(
          //   width: 15,
          // ),
          // GestureDetector(
          //   onTap: () {},
          //   child: Container(
          //     height: 48,
          //     width: 48,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(8),
          //       color: kPrimaryColor,
          //     ),
          //     child: Center(
          //       child: Image.asset(
          //         Assets.imagesSettings,
          //         height: 24,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
