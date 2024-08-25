import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/main.dart';
import 'package:bike_gps/view/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:bike_gps/view/widget/common_image_view_widget.dart';
import 'package:bike_gps/view/widget/my_button_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:bike_gps/view/widget/my_textfield_widget.dart';
import 'package:bike_gps/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Profile',
        titleColor: kSecondaryColor,
        leadingIcon: Assets.imagesMenu,
        leadingIconSize: 12,
        onLeadingTap: () {},
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              children: [
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CommonImageView(
                        url: dummyImg,
                        height: 60,
                        width: 60,
                        radius: 100,
                      ),
                      Positioned(
                        bottom: -3,
                        right: -6,
                        child: Image.asset(
                          Assets.imagesEditBg,
                          height: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                MyText(
                  text: 'John Doe',
                  size: 16,
                  weight: FontWeight.w600,
                  textAlign: TextAlign.center,
                  paddingTop: 16,
                  paddingBottom: 22,
                ),
                MyTextField(
                  labelText: 'Your name',
                  hintText: 'e.g. John Doe',
                  marginBottom: 14,
                ),
                MyTextField(
                  labelText: 'Your email',
                  hintText: 'youremail@gmail.com',
                  marginBottom: 14,
                ),
                MyTextField(
                  labelText: 'YPhone no',
                  hintText: '+123456789',
                  keyboardType: TextInputType.number,
                  marginBottom: 14,
                )
              ],
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: MyButton(
              buttonText: 'Save',
              onTap: () {
                Get.offAll(
                  () => BottomNavBar(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
