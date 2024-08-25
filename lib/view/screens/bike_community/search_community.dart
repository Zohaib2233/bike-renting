
import 'dart:developer';

import 'package:bike_gps/constants/app_images.dart';

import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_fonts.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/core/utils/formatters/date_fromatter.dart';
import 'package:bike_gps/main.dart';
import 'package:bike_gps/view/screens/friends/saerch_friends.dart';
import 'package:bike_gps/view/widget/common_image_view_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBikeCommunity extends StatelessWidget {
  const SearchBikeCommunity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _BuildMap(),
          _BuildSettingsTile(),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Get.bottomSheet(
                    FriendDetailBottomSheet(
                      img: dummyImg,
                      name: "name",
                      address: "address",
                      isOnline: true,
                      timeToReach: "1",
                      lastActiveOn: DateTime.now(),
                      onLocateFriendTap: () {},
                    ),
                    isScrollControlled: true,
                  );
                },
                child: Image.asset(
                  Assets.imagesMyCycle,
                  height: 234,
                ),
              ),
            ),
          ),
          Positioned(
            right: 6,
            top: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => SearchFriends());
                  },
                  child: Image.asset(
                    Assets.imagesFriendIcon,
                    height: 80,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    Assets.imagesPlacesIcon,
                    height: 80,
                  ),
                ),
              ],
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
      child: Column(
        children: [
          MyText(
            text: 'Bike Community',
            size: 18,
            weight: FontWeight.bold,
            fontFamily: AppFonts.NUNITO_SANS,
            paddingBottom: 14,
          ),
          Row(
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
                          Image.asset(
                            Assets.imagesSearch,
                            height: 24,
                          ),
                        ],
                      ),
                      hintText: 'In Poland',
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
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: kPrimaryColor,
                ),
                child: Center(
                  child: Image.asset(
                    Assets.imagesSettings,
                    height: 24,
                  ),
                ),
              ),
            ],
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

class _FriendMapMarkerRight extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          FriendDetailBottomSheet(
            img: dummyImg,
            name: "name",
            address: "address",
            isOnline: true,
            timeToReach: "1",
            lastActiveOn: DateTime.now(),
            onLocateFriendTap: () {},
          ),
          isScrollControlled: true,
        );
      },
      child: Column(
        children: [
          Image.asset(
            Assets.imagesCycle,
            height: 78,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: kBlueColor,
            ),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 6,
              children: [
                MyText(
                  text: 'John Doe',
                  size: 10,
                  weight: FontWeight.w600,
                  color: kPrimaryColor,
                ),
                MyText(
                  text: '17m',
                  size: 8,
                  weight: FontWeight.w500,
                  color: kPrimaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class FriendDetailBottomSheet extends StatelessWidget {
  FriendDetailBottomSheet({
    required this.img,
    required this.name,
    required this.address,
    required this.isOnline,
    required this.lastActiveOn,
    required this.onLocateFriendTap,
    required this.timeToReach,
  });

  final String img, name, address, timeToReach;
  bool isOnline;

  DateTime lastActiveOn;

  final VoidCallback onLocateFriendTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
        color: kPrimaryColor,
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              height: 6,
              width: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color(0xffF0F0F0),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: AppSizes.DEFAULT,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          CommonImageView(
                            height: 46,
                            width: 46,
                            radius: 100.0,
                            url: img,
                          ),
                          Positioned(
                            bottom: 3,
                            right: 3,
                            child: Visibility(
                              visible: isOnline,
                              child: Image.asset(
                                Assets.imagesOnline,
                                height: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            MyText(
                              text: name,
                              weight: FontWeight.w500,
                              size: 16,
                            ),
                            MyText(
                              paddingTop: 4,
                              text: address,
                              size: 11,
                              color: kGreyColor8,
                              weight: FontWeight.w500,
                            ),
                            Visibility(
                              visible: isOnline == false,
                              child: MyText(
                                text: DateFormatters.instance
                                    .getTimeAgo(date: lastActiveOn),
                                size: 11,
                                color: kGreyColor8,
                                weight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          height: 28,
                          width: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kInputBorderColor,
                          ),
                          child: Center(
                            child: Image.asset(
                              Assets.imagesClose,
                              height: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: GestureDetector(
                          onTap: onLocateFriendTap,
                          child: Container(
                            height: 38,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: kBlueColor,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  Assets.imagesLoc,
                                  height: 14,
                                ),
                                MyText(
                                  paddingLeft: 4,
                                  paddingRight: 4,
                                  text: 'Locate Friend',
                                  size: 14,
                                  weight: FontWeight.w500,
                                  color: kPrimaryColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 14,
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: 38,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: kBlueColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                Assets.imagesDistance,
                                height: 14,
                              ),
                              MyText(
                                paddingLeft: 4,
                                paddingRight: 4,
                                text: '$timeToReach hr',
                                size: 14,
                                weight: FontWeight.w500,
                                color: kPrimaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FriendMapMarkerLeft extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          FriendDetailBottomSheet(
            img: dummyImg,
            name: "name",
            address: "address",
            isOnline: true,
            timeToReach: "1",
            lastActiveOn: DateTime.now(),
            onLocateFriendTap: () {},
          ),
          isScrollControlled: true,
        );
      },
      child: Column(
        children: [
          Transform.flip(
            flipX: true,
            child: Image.asset(
              Assets.imagesCycle,
              height: 78,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: kBlueColor,
            ),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 6,
              children: [
                MyText(
                  text: 'John Doe',
                  size: 10,
                  weight: FontWeight.w600,
                  color: kPrimaryColor,
                ),
                MyText(
                  text: '17m',
                  size: 8,
                  weight: FontWeight.w500,
                  color: kPrimaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
