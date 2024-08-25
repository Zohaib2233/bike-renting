import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/view/screens/auth/login/login.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class onBoarding extends StatefulWidget {
  const onBoarding({super.key});

  @override
  State<onBoarding> createState() => _onBoardingState();
}

class _onBoardingState extends State<onBoarding> {
  int _currentIndex = 0;

  final List<String> images = [
    Assets.imagesBikeFront,
    Assets.imagesBikeBack,
  ];

  final List<Map<String, dynamic>> onBoarding = [
    {
      'title': 'More about app',
      'subTitle': '',
    },
    {
      'title': 'More about app',
      'subTitle': '',
    }
  ];

  void _getCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final PageController controller = PageController(
    initialPage: 0,
    viewportFraction: 0.9,
  );

  @override
  Widget build(BuildContext context) {
    final List<String> bikeImages = [
      Assets.imagesBikeFront,
      Assets.imagesBikeBack,
    ];

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  child: Image.asset(
                    bikeImages[0],
                  ),
                ),
                Positioned(
                  child: Image.asset(
                    bikeImages[1],
                    height: 300,
                    alignment: Alignment(0, -1.0),
                  ),
                ),
                SizedBox(
                  child: ListView(),
                ),
              ],
            ),
          ),
          Center(
            child: SmoothPageIndicator(
              controller: controller,
              count: images.length,
              effect: ExpandingDotsEffect(
                dotWidth: 8,
                dotHeight: 8,
                spacing: 6.0,
                expansionFactor: 4,
                activeDotColor: kBlueColor,
                dotColor: kDarkGreyColor.withOpacity(0.45),
              ),
              onDotClicked: (index) {},
            ),
          ),
          SizedBox(
            height: 6,
          ),
          Container(
            padding: AppSizes.DEFAULT,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyText(
                  text: onBoarding[_currentIndex]['title'],
                  size: 18,
                  weight: FontWeight.w700,
                  paddingBottom: 8,
                ),
                MyText(
                  text: onBoarding[_currentIndex]['subTitle'],
                  size: 12,
                  color: kLightGreyColor,
                ),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 180),
                  opacity: _currentIndex == onBoarding.length - 1 ? 1.0 : 0.0,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Get.offAll(
                        () => Login(),
                      ),
                      child: Image.asset(
                        Assets.imagesArrowNext,
                        height: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
