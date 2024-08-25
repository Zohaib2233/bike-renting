import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/view/screens/profile/profile.dart';
import 'package:bike_gps/view/screens/tourist_attraction/nearby_places/nearby_places_bottom_sheet.dart';
import 'package:bike_gps/view/widget/common_image_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RiderMap extends StatelessWidget {
  const RiderMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _BuildMap(),
          _BuildSettingsTile(),
          Center(
            child: Image.asset(
              Assets.imagesOnMapMarker,
              height: Get.height * 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _BuildSettingsTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Image.asset(
              Assets.imagesArrowBack,
              height: 24,
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  prefixIcon: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.bottomSheet(
                            NearbyBottomSheet(),
                            isScrollControlled: true,
                          );
                        },
                        child: Image.asset(
                          Assets.imagesSearch,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                  hintText: 'Café',
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
          SizedBox(
            width: 15,
          ),
          GestureDetector(
            onTap: () => Get.to(() => Profile()),
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: kPrimaryColor,
              ),
              // child: Center(
              //   child: Image.asset(
              //     Assets.imagesSettings,
              //     height: 24,
              //   ),
              // ),
            ),
          ),
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
