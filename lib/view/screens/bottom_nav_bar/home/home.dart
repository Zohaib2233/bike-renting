import 'package:bike_gps/controllers/home/home_controller.dart';
import 'package:bike_gps/controllers/in_app_purchases/inapp_purchases_controller.dart';
import 'package:bike_gps/core/bindings/bindings.dart';
import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_fonts.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/core/constants/instances_constants.dart';
import 'package:bike_gps/core/utils/dialogs.dart';
import 'package:bike_gps/core/utils/formatters/date_fromatter.dart';
import 'package:bike_gps/core/utils/snackbars.dart';
import 'package:bike_gps/view/screens/bottom_nav_bar/home/rider_states.dart';
import 'package:bike_gps/view/screens/emergency/emergency.dart';
import 'package:bike_gps/view/screens/profile/profile.dart';
import 'package:bike_gps/view/screens/test_screens/bluetooth.dart';
import 'package:bike_gps/view/widget/my_button_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

// ignore: must_be_immutable
class Home extends StatelessWidget {
  Home({super.key});

  //finding HomeController
  HomeController controller = Get.find<HomeController>();

  //finding InAppPurchasesController
  InAppPurchasesController inAppPurchasesController =
      Get.find<InAppPurchasesController>();

  RxBool isActive = false.obs;
  void handleAction() {
    isActive.value = !isActive.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Get.to(
              () => Profile(),
              binding: ProfileBinding(),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Assets.imagesMenuBlue,
                height: 18,
                color: kBlackColor,
              ),
            ],
          ),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.imagesLogoText,
              height: 18,
              color: kBlackColor,
            ),
          ],
        ),
      ),
      body: ListView(
        padding: AppSizes.DEFAULT,
        physics: const BouncingScrollPhysics(),
        children: [
          // ElevatedButton(
          //     onPressed: () async {
          //       // Get.to(
          //       //   () => SubscriptionsScreen(),
          //       //   binding: InAppPurchasesBinding(),
          //       // );
          //       // controller.markBikeAsStolen(context: context);
          //       // Get.to(() => BarcodeScanningScreen());
          //       Get.to(
          //             () => BluetoothTestingScreen(),
          //         binding: BluetoothBinding(),
          //       );
          //     },
          //     child: null),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kRedColor2.withOpacity(0.28),
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(Assets.imagesBikeOverlay),
                // image: AssetImage(Assets.imagesKnaapBikeBg),
                fit: BoxFit.cover,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        text: 'Find my bike',
                        size: 16,
                        weight: FontWeight.w600,
                        fontFamily: AppFonts.SYNE,
                        paddingBottom: 9,
                      ),
                      MyText(
                        text: 'Last Location',
                        size: 10,
                        weight: FontWeight.bold,
                        fontFamily: AppFonts.SYNE,
                        paddingBottom: 11,
                      ),
                      Obx(() => MyText(
                            text:
                                '${userModelGlobal.value.bikeLastKnownLocation}',
                            size: 10,
                            weight: FontWeight.w500,
                            fontFamily: AppFonts.SYNE,
                          )),
                      // IntrinsicHeight(
                      //   child: Row(
                      //     children: [
                      //       // Image.asset(
                      //       //   Assets.imagesRouteIcon,
                      //       //   height: 68,
                      //       // ),
                      //       // SizedBox(
                      //       //   width: 8,
                      //       // ),
                      //       Column(
                      //         mainAxisAlignment:
                      //             MainAxisAlignment.spaceBetween,
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           MyText(
                      //             text: 'Kubwa',
                      //             size: 10,
                      //             weight: FontWeight.w500,
                      //             fontFamily: AppFonts.SYNE,
                      //           ),
                      //           MyText(
                      //             text: 'Gwarlinpa',
                      //             size: 10,
                      //             weight: FontWeight.w500,
                      //             fontFamily: AppFonts.SYNE,
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: MyButton(
                              onTap: () async {
                                //checking if the user has purchased a plan
                                bool hasSubscribed =
                                    await inAppPurchasesController
                                        .hasSubscribed();

                                if (hasSubscribed) {
                                  //showing progress dialog
                                  DialogService.instance
                                      .showProgressDialog(context: context);
                                  await controller.getLastKnownLocation(
                                      context: context);
                                } else {
                                  CustomSnackBars.instance.showFailureSnackbar(
                                      title: "Not Subscribed",
                                      message:
                                          "You have not purchased any plan, please purchase a subscription to use this feature");
                                }
                              },
                              radius: 50,
                              height: 26,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    Assets.imagesFindNow,
                                    height: 14,
                                  ),
                                  MyText(
                                    text: 'Find Now',
                                    size: 10,
                                    weight: FontWeight.w500,
                                    fontFamily: AppFonts.SYNE,
                                    paddingLeft: 5,
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: MyButton(
                              // radius: 50,
                              height: 26,
                              bgColor: kBlueColor,
                              onTap: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    Assets.imagesClockIcon,
                                    height: 14,
                                  ),
                                  Obx(() => MyText(
                                        text:
                                            '${DateFormatters.instance.getTimeAgo(date: userModelGlobal.value.lastKnownLocFetchedOn!)}',
                                        size: 10,
                                        weight: FontWeight.w500,
                                        fontFamily: AppFonts.SYNE,
                                        paddingLeft: 5,
                                      ))
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  Assets.imagesMapBg,
                  height: 156,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 14,
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Get.to(
                    () => RiderStates(),
                  ),
                  child: Container(
                    height: 206,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: kSecondaryColor,
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        alignment: Alignment.centerRight,
                        image: AssetImage(
                          Assets.imagesBikeFront2,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MyText(
                          text: 'My bike',
                          size: 16,
                          weight: FontWeight.w600,
                          fontFamily: AppFonts.SYNE,
                          paddingBottom: 4,
                        ),
                        MyText(
                          text: 'Check Stats',
                          size: 10,
                          fontFamily: AppFonts.SYNE,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 18,
              ),
              Expanded(
                child: Column(
                  children: [
                    Obx(() => _BikeSwitchCard(
                          title: 'LOCK',
                          subTitle: 'Your bike',
                          inActiveTitle: 'LOCKED',
                          inActiveSubTitle: 'Your bike is locked',
                          activeIcon: Assets.imagesTablerUnlock,
                          inActiveIcon: Assets.imagesTablerLock,
                          isActive: userModelGlobal.value.isBikeLocked!,
                          onTap: () async {
                            //checking if the user has purchased a plan
                            bool hasSubscribed =
                                await inAppPurchasesController.hasSubscribed();

                            if (hasSubscribed) {
                              //showing progress dialog
                              DialogService.instance
                                  .showProgressDialog(context: context);

                              if (userModelGlobal.value.isBikeLocked!) {
                                //unlocking the bike
                                await controller.lockOrUnlockTheBike(
                                    isLock: false);
                              } else {
                                //locking the bike
                                await controller.lockOrUnlockTheBike(
                                    isLock: true);
                              }

                              //popping progress dialog
                              Navigator.pop(context);
                            } else {
                              CustomSnackBars.instance.showFailureSnackbar(
                                  title: "Not Subscribed",
                                  message:
                                      "You have not purchased any plan, please purchase a subscription to use this feature");
                            }
                          },
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Obx(() => _BikeSwitchCard(
                          title: 'STOLEN',
                          subTitle: 'Mark stolen',
                          inActiveTitle: 'STOLEN',
                          inActiveSubTitle: 'Your bike is marked stolen',
                          activeIcon: Assets.imagesStolen,
                          inActiveIcon: Assets.imagesStolen,
                          isActive: userModelGlobal.value.isBikeStolen!,
                          onTap: () async {
                            controller.handleBikeStolenTap(context: context);

                            //checking if the user has purchased a plan
                            // bool hasSubscribed =
                            //     await inAppPurchasesController.hasSubscribed();

                            // if (hasSubscribed) {
                            //   controller.handleBikeStolenTap(context: context);
                            // } else {
                            //   CustomSnackBars.instance.showFailureSnackbar(
                            //       title: "Not Subscribed",
                            //       message:
                            //           "You have not purchased any plan, please purchase a subscription to use this feature");
                            // }
                          },
                        )),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 14,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearPercentIndicator(
              lineHeight: 48,
              // barRadius: Radius.circular(12),

              percent: 0.75,
              animationDuration: 800,
              animation: true,
              padding: EdgeInsets.zero,
              backgroundColor: Color(0xff98DB8D).withOpacity(0.35),
              progressColor: kGreenColor,
              center: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.imagesBattery,
                    height: 28,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  MyText(
                    text: '80% Battery',
                    size: 16,
                    color: kPrimaryColor,
                    weight: FontWeight.w500,
                    fontFamily: AppFonts.SYNE,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 14,
          ),
          MyButton(
            buttonText: 'Emergency & safety',
            bgColor: kRedColor,
            onTap: () {
              Get.to(
                () => Emergency(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BikeSwitchCard extends StatelessWidget {
  final String title,
      subTitle,
      inActiveTitle,
      inActiveSubTitle,
      activeIcon,
      inActiveIcon;
  final VoidCallback onTap;
  final bool isActive;
  const _BikeSwitchCard({
    required this.title,
    required this.subTitle,
    required this.onTap,
    required this.isActive,
    required this.inActiveTitle,
    required this.inActiveSubTitle,
    required this.activeIcon,
    required this.inActiveIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: isActive ? kBlackColor : kSecondaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: isActive
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildButton(),
                  SizedBox(
                    width: 11,
                  ),
                  _buildDetail(),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildDetail(),
                  SizedBox(
                    width: 11,
                  ),
                  _buildButton(),
                ],
              ),
      ),
    );
  }

  Widget _buildDetail() => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MyText(
              text: isActive ? inActiveTitle : title,
              size: 16,
              color: isActive ? kPrimaryColor : kBlackColor,
              weight: FontWeight.w700,
              fontFamily: AppFonts.SYNE,
              paddingBottom: 4,
            ),
            MyText(
              text: isActive ? inActiveSubTitle : subTitle,
              size: 10,
              color: isActive ? kPrimaryColor : kBlackColor,
              fontFamily: AppFonts.SYNE,
            ),
          ],
        ),
      );

  Widget _buildButton() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: 74,
      width: 52,
      decoration: BoxDecoration(
        color: isActive ? kRedColor : kGreenColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Image.asset(
          isActive ? inActiveIcon : activeIcon,
          height: 24,
        ),
      ),
    );
  }
}
