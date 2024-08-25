import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_fonts.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/view/screens/friends/friends.dart';
import 'package:bike_gps/view/widget/common_image_view_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/bindings/bindings.dart';

class SearchFriends extends StatelessWidget {
  const SearchFriends({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _BuildMap(),
          _BuildSettingsTile(),
          Positioned(
            right: 30,
            top: 150,
            child: _FriendMapMarkerRight(),
          ),
          Positioned(
            left: 30,
            top: 350,
            child: _FriendMapMarkerLeft(),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                Assets.imagesMe,
                height: 105.71,
              ),
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
            text: 'Locate friends',
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
                    readOnly: true,
                    onTap: () => Get.to(() => Friends(),binding: FriendsBinding()),
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
      onTap: () {},
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

class _FriendMapMarkerLeft extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
