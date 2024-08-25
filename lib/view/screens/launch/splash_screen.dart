import 'package:bike_gps/controllers/launch/splash_screen_controller.dart';
import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //finding SplashScreenController
  SplashScreenController controller = Get.find<SplashScreenController>();

  @override
  void initState() {
    super.initState();
    controller.splashScreenHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Image.asset(
              Assets.imagesLogo,
              height: 33,
            ),
          ),
          SizedBox(
            height: 29,
          ),
          Center(
            child: SizedBox(
              width: 138,
              child: LinearPercentIndicator(
                lineHeight: 5.18,
                barRadius: Radius.circular(50),
                percent: 1.0,
                animationDuration: 2000,
                animation: true,
                padding: EdgeInsets.zero,
                backgroundColor: kLightGreyColor.withOpacity(0.19),
                progressColor: kBlueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
