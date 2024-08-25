import 'package:bike_gps/controllers/bike/find_bike_controller.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/utils/google_maps/flutter_google_maps_utils.dart';
import 'package:bike_gps/view/widget/common_image_view_widget.dart';
import 'package:bike_gps/view/widget/simple_app_bar_widget.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class FindMyBike extends StatelessWidget {
  FindMyBike({super.key});

  //finding FindBikeController
  FindBikeController controller = Get.find<FindBikeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          GetBuilder<FindBikeController>(builder: (controller) {
            return CustomGoogleMapMarkerBuilder(
                customMarkers: controller.markers,
                builder: (BuildContext context, Set<Marker>? markers) {
                  return GoogleMap(
                    mapType: MapType.normal,
                    zoomControlsEnabled: true,
                    initialCameraPosition:
                        FlutterGoogleMapsUtils.instance.kGooglePlex,
                    markers: markers ?? {},
                    // polylines: Set<Polyline>.of(controller.polylines.values),
                    onMapCreated: (GoogleMapController googleMapController) {
                      if (!controller.mapController.isCompleted) {
                        controller.mapController.complete(googleMapController);
                      }

                      controller.animateCamera();
                    },
                  );
                });
          }),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: simpleAppBar(
                title: "Locate Your Bike",
                bgColor: Colors.transparent,
              ))
        ],
      ),
    );
  }
}

class _BuildMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CommonImageView(
      height: Get.height,
      width: Get.width,
      imagePath: Assets.imagesDummyMap,
    );
  }
}
