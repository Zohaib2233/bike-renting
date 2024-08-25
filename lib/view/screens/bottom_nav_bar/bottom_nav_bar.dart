import 'dart:async';
import 'dart:io';
import 'package:bike_gps/controllers/auth/login_controller.dart';
import 'package:bike_gps/controllers/auth/signup_controller.dart';
import 'package:bike_gps/controllers/bottom_nav_bar/bottom_nav_bar_controller.dart';
import 'package:bike_gps/controllers/home/ride_stats_controller.dart';
import 'package:bike_gps/controllers/in_app_purchases/inapp_purchases_controller.dart';
import 'package:bike_gps/controllers/launch/splash_screen_controller.dart';
import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/services/firebase/firebase_authentication.dart';
import 'package:bike_gps/view/knaap_store/knaap_store.dart';
import 'package:bike_gps/view/screens/bike_community/bike_community.dart';
import 'package:bike_gps/view/screens/bottom_nav_bar/home/home.dart';
import 'package:bike_gps/view/screens/tourist_attraction/intro_screens/intro_screens.dart';
import 'package:bike_gps/view/screens/tourist_attraction/nearby_places/nearby_places.dart';
import 'package:bike_gps/view/screens/tourist_attraction/nearby_places/nearby_places2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:get/get.dart';

import '../../../core/utils/dialogs.dart';

class BottomNavBar extends StatefulWidget {
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  //finding BottomNavBarController
  BottomNavBarController controller = Get.find<BottomNavBarController>();

  //finding RideStatsController
  RideStatsController rideStatsController = Get.find<RideStatsController>();

  //finding InAppPurchasesController
  InAppPurchasesController inAppPurchasesController =
      Get.find<InAppPurchasesController>();

  List<Map<String, dynamic>> items = [
    {
      'icon': Assets.imagesHome,
      'title': 'Home',
    },
    {
      'icon': Assets.imagesStore,
      'title': 'Store',
    },
    {
      'icon': Assets.imagesStore,
      'title': '',
    },
    {
      'icon': Assets.imagesPlaces,
      'title': 'Places',
    },
    {
      'icon': Assets.imagesFriends,
      'title': 'Friends',
    },
  ];

  List<Map<String, dynamic>> iosItems = [
    {
      'icon': Assets.imagesHome,
      'title': 'Home',
    },
    {
      'icon': Assets.imagesStore,
      'title': 'Store',
    },
  ];

  @override
  void initState() {
    super.initState();

    inAppPurchasesController.init();

    //getting realtime location stream of the user
    rideStatsController.locateUser();

    deleteUnusefulControllers();
  }

  void deleteUnusefulControllers() async {
    await Future.delayed(const Duration(seconds: 3));
    //deleting unuseful controllers
    Get.delete<SignUpController>();
    Get.delete<FirebaseAuthService>();
    Get.delete<SplashScreenController>();
    Get.delete<LoginController>();
  }

  void _getCurrentScreens(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = [
      Home(),
      KnaapStore(),
      NearbyPlaces2(),
      // NearbyPlaces(),
      // Notifications(),
      controller.getPlacesIntroFlag ? NearbyPlaces() : IntroScreens(),
      BikeCommunity(),
    ];
    return WillPopScope(
      onWillPop: () {
        Get.defaultDialog(
            title: 'Confirm',
            backgroundColor: kPrimaryColor,
            contentPadding: EdgeInsets.all(10),
            titleStyle: TextStyle(
                color: kBlackColor, fontSize: 20, fontWeight: FontWeight.w600),
            content: DialogService.instance.quitAppDialogue(onTap: () async {
              if (Platform.isAndroid) {
                //updating user ride stats
                await rideStatsController.updateUserStats();

                FlutterExitApp.exitApp();
              } else {
                //updating user ride stats
                await rideStatsController.updateUserStats();

                FlutterExitApp.exitApp(iosForceExit: true);
              }
            }));
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kSeoulColor,
        body: IndexedStack(
          index: _currentIndex,
          children: _children,
        ),
        bottomNavigationBar: _bottomNavBar(context),
      ),
    );
  }

  Widget _bottomNavBar(BuildContext context) {
    return SizedBox(
      // height: Platform.isIOS ? null : 70,
      height: Platform.isIOS ? 90 : 70,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: Platform.isIOS ? null : 70,
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                _getCurrentScreens(index);
                // if (_currentIndex == 4)
                // Timer(
                //   Duration(milliseconds: 800),
                //   () {
                //     Get.dialog(
                //       DiscoverPopup(),
                //     );
                //   },
                // );
              },
              elevation: 0,
              backgroundColor: kPrimaryColor,
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 10,
              unselectedFontSize: 10,
              selectedLabelStyle: TextStyle(
                fontSize: 10,
                color: kGreyColor6,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 10,
                color: kGreyColor6.withOpacity(0.7),
              ),
              selectedItemColor: kGreyColor6,
              unselectedItemColor: kGreyColor6.withOpacity(0.7),
              items: List.generate(
                // Platform.isIOS ? iosItems.length: items.length,
                items.length,
                (index) {
                  return BottomNavigationBarItem(
                    icon: index == 2
                        ? Container()
                        : Container(
                            height: 32,
                            width: 32,
                            child: Center(
                              child: ImageIcon(
                                AssetImage(
                                  // Platform.isIOS
                                  //     ? iosItems[index]['icon']
                                  items[index]['icon'],
                                ),
                                size: 20,
                              ),
                            ),
                          ),
                    // label: Platform.isIOS
                    //     ? iosItems[index]['title']
                    label: items[index]['title'],
                  );
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                _getCurrentScreens(2);
              },
              child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: kPrimaryColor,
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                  color: _currentIndex == 2 ? kTertiaryColor : kSecondaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: kBlackColor.withOpacity(0.15),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    Assets.imagesLoc,
                    height: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
