import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/core/constants/app_styling.dart';
import 'package:bike_gps/core/enums/location_permission.dart';
import 'package:bike_gps/core/utils/permissions/permissions.dart';
import 'package:bike_gps/services/local_storage/local_storage.dart';
import 'package:bike_gps/view/screens/tourist_attraction/nearby_places/nearby_places.dart';
import 'package:bike_gps/view/widget/my_button_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

class IntroScreens extends StatefulWidget {
  IntroScreens({super.key});

  @override
  State<IntroScreens> createState() => _IntroScreensState();
}

class _IntroScreensState extends State<IntroScreens> {
  String _on1 = '';
  String _on2 = '';
  String _on3 = '';

  List<Map<String, String>> _onBoardingContent = [];

  int _currentIndex = 0;

  late PageController _pageController;

  double _offset = 0.0;

  @override
  void initState() {
    super.initState();
    _on1 = Assets.imagesOn1;
    _on2 = Assets.imagesOn2;
    _on3 = Assets.imagesOn3;
    _onBoardingContent = _onBoardingData();

    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _offset = _pageController.page ?? 0.0;
      });
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<Map<String, String>> _onBoardingData() {
    return [
      {
        'title': 'Get latest nearby\n locations',
        'subTitle': '',
        'image': _on1,
      },
      {
        'title': 'Get latest nearby\n locations 2',
        'subTitle': '',
        'image': _on2,
      },
      {
        'title': 'Get latest nearby\n locations 3',
        'subTitle': '',
        'image': _on3,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          PageView.builder(
            onPageChanged: (index) => _onPageChanged(index),
            controller: _pageController,
            itemCount: _onBoardingContent.length,
            itemBuilder: (context, index) {
              return Image.asset(
                '${_onBoardingContent[index]['image']}',
                height: Get.height,
                width: Get.width,
                fit: BoxFit.cover,
                alignment: Alignment(-_offset.abs(), 0),
              );
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    margin: AppSizes.HORIZONTAL,
                    height: 214,
                    width: Get.width,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                        image: AssetImage(Assets.imagesBlurEffect),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MyText(
                          text: _onBoardingContent[_currentIndex]['title']!,
                          color: kWhiteColor2,
                          size: 18,
                          weight: FontWeight.w600,
                          textAlign: TextAlign.center,
                          lineHeight: 1.6,
                        ),
                        MyText(
                          text: _onBoardingContent[_currentIndex]['subTitle']!,
                          color: kInputBorderColor,
                          size: 12,
                          textAlign: TextAlign.center,
                          lineHeight: 1.6,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: -48,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () async {
                        if (_currentIndex == _onBoardingContent.length - 1) {
                          //setting user about intro screens seen
                          await LocalStorageService.instance
                              .write(key: "hasSeenPlacesIntro", value: true);
                          //checking location permission status
                          LocationPermissionStatus locationPermissionStatus =
                              await PermissionService.instance
                                  .getLocationPermissionStatus();

                          if (locationPermissionStatus !=
                              LocationPermissionStatus.granted) {
                            Get.to(() => _RequestLocationPermission());
                          } else {
                            Get.to(() => NearbyPlaces());
                          }
                        } else {
                          _pageController.nextPage(
                            duration: Duration(
                              milliseconds: 700,
                            ),
                            curve: Curves.easeInOutCubic,
                          );
                        }
                        // (_currentIndex == _onBoardingContent.length - 1)
                        //     ? Get.to(() => _RequestLocationPermission())
                        //     : _pageController.nextPage(
                        //         duration: Duration(
                        //           milliseconds: 700,
                        //         ),
                        //         curve: Curves.easeInOutCubic,
                        //       );
                      },
                      child: Center(
                        child: CircularPercentIndicator(
                          radius: 38.0,
                          lineWidth: 2.0,
                          percent: _currentIndex.toDouble() /
                              (_onBoardingContent.length - 1),
                          animation: true,
                          restartAnimation: false,
                          center: GestureDetector(
                            child: Container(
                              height: 64,
                              width: 64,
                              decoration: BoxDecoration(
                                color: kSecondaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    (_currentIndex ==
                                            _onBoardingContent.length - 1)
                                        ? () {}
                                        : _pageController.nextPage(
                                            duration: Duration(
                                              milliseconds: 700,
                                            ),
                                            curve: Curves.easeInOutCubic,
                                          );
                                  },
                                  child: Image.asset(
                                    Assets.imagesArrowNext,
                                    width: 17.38,
                                    color: kPrimaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          backgroundColor: kLightGreyColor,
                          progressColor: kSecondaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 60,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RequestLocationPermission extends StatefulWidget {
  @override
  State<_RequestLocationPermission> createState() =>
      _RequestLocationPermissionState();
}

class _RequestLocationPermissionState
    extends State<_RequestLocationPermission> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showModalBottomSheet(
        context: context,
        builder: (_) {
          return _LocationBottomSheet();
        },
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        enableDrag: false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              Assets.imagesOn3,
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _LocationBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 217,
      padding: EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 29,
      ),
      decoration: AppStyling.BOTTOM_SHEET_DEC,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyText(
            text: 'Location Services',
            size: 18,
            weight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
          MyText(
            paddingTop: 10,
            text:
                'We need to know were you are in order to find what’s near to you.',
            size: 14,
            color: kQuaternaryColor,
            textAlign: TextAlign.center,
            paddingBottom: 24,
          ),
          MyButton(
            buttonText: 'Enable Location Service',
            onTap: () async {
              await PermissionService.instance.getLocationPermissionStatus();

              Get.to(() => NearbyPlaces());
            },
          ),
        ],
      ),
    );
  }
}
