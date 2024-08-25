import 'dart:ui';

import 'package:bike_gps/controllers/launch/splash_screen_controller.dart';
import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/view/screens/auth/login/login.dart';
import 'package:bike_gps/view/screens/launch/splash_screen.dart';
import 'package:bike_gps/view/widget/my_button_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetStarted extends StatelessWidget {
  GetStarted({super.key});

  //finding SplashScreenController
  SplashScreenController controller = Get.find<SplashScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image.asset(
            Assets.imagesGetStarted,
            height: Get.height,
            width: Get.width,
            fit: BoxFit.cover,
          ),
          ClipRRect(
            borderRadius: BorderRadius.zero,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 4,
                sigmaY: 4,
              ),
              child: Container(
                height: 291,
                padding: AppSizes.DEFAULT,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      kTransparent,
                      kDarkGreyColor2.withOpacity(0.98),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MyText(
                      text: 'Get your smart life\nwith bike tracker',
                      size: 22,
                      color: kPrimaryColor,
                      weight: FontWeight.w500,
                      paddingBottom: 24,
                    ),
                    MyButton(
                      buttonText: 'Get Started',
                      bgColor: kBlueColor,
                      textSize: 16,
                      weight: FontWeight.w600,
                      onTap: () async {
                        await controller.userOnboarded();

                        Get.offAll(
                          () => Login(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
