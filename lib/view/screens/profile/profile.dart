import 'dart:developer';
import 'dart:io';
import 'package:bike_gps/controllers/in_app_purchases/inapp_purchases_controller.dart';
import 'package:bike_gps/controllers/profile/profile_controller.dart';
import 'package:bike_gps/core/bindings/bindings.dart';
import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_fonts.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/core/constants/instances_constants.dart';
import 'package:bike_gps/core/utils/formatters/date_fromatter.dart';
import 'package:bike_gps/services/local_storage/local_storage.dart';
import 'package:bike_gps/view/screens/profile/favorite_posts.dart';
import 'package:bike_gps/view/screens/profile/privacy_policy.dart';
import 'package:bike_gps/view/screens/profile/subscriptions/active_subscriptions.dart';
import 'package:bike_gps/view/screens/profile/subscriptions/subscriptions.dart';
import 'package:bike_gps/view/screens/profile/edit_profile.dart';
import 'package:bike_gps/view/screens/auth/login/login.dart';
import 'package:bike_gps/view/widget/common_image_view_widget.dart';
import 'package:bike_gps/view/widget/custom_bottom_sheet_widget.dart';
import 'package:bike_gps/view/widget/my_button_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:bike_gps/view/widget/simple_app_bar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

// ignore: must_be_immutable
class Profile extends StatelessWidget {
  Profile({super.key});

  //finding ProfileController
  ProfileController controller = Get.find<ProfileController>();

  //finding InAppPurchasesController
  InAppPurchasesController inAppPurchasesController =
      Get.find<InAppPurchasesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        leadingIcon: Assets.imagesArrowBackIos,
        leadingIconSize: 42,
      ),
      body: ListView(
        padding: AppSizes.DEFAULT,
        physics: const BouncingScrollPhysics(),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Obx(() => MyText(
                          text: userModelGlobal.value.fullName!,
                          size: 22,
                          color: kTextColor6,
                          weight: FontWeight.w700,
                          fontFamily: AppFonts.NUNITO_SANS,
                          paddingBottom: 4,
                        )),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        //premium user badge
                        FutureBuilder<bool>(
                            future: inAppPurchasesController.hasSubscribed(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                //if we got an error
                                if (snapshot.hasError) {
                                  // showSnackbar(title: 'Error', msg: 'Try again');
                                }
                                //if we got the data
                                else if (snapshot.hasData) {
                                  //getting snapshot data
                                  bool hasSubscribed = snapshot.data!;
                                  return Visibility(
                                    visible: hasSubscribed,
                                    child: _PremiumUserBdage(),
                                  );
                                }
                              }
                              return Center(
                                  child: const CupertinoActivityIndicator(
                                animating: true,
                                radius: 20,
                                color: kSecondaryColor,
                              ));
                            }),
                        Image.asset(
                          Assets.imagesLocation,
                          height: 16,
                        ),
                        Obx(() => MyText(
                              text: userModelGlobal.value.country!,
                              size: 11,
                              color: kBlackColor,
                              weight: FontWeight.w500,
                              fontFamily: AppFonts.SYNE,
                              paddingLeft: 2,
                              paddingRight: 6,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              Obx(() => CommonImageView(
                    url: userModelGlobal.value.profilePic,
                    height: 76,
                    width: 76,
                    radius: 100,
                  )),
            ],
          ),
          SizedBox(
            height: 28,
          ),
          Wrap(
            spacing: 30,
            children: [
              _ProfileDetailColumn(
                title: DateFormatters.instance
                    .mmYYYYFormat(date: userModelGlobal.value.joinedOn!),
                subTitle: 'Joined',
                icon: Assets.imagesWatchLater,
              ),
              Obx(() => _ProfileDetailColumn(
                    title: userModelGlobal.value.rating.toString(),
                    subTitle: 'Rating',
                    icon: Assets.imagesStarBorder,
                  )),
              Obx(() => _ProfileDetailColumn(
                    title: userModelGlobal.value.totalRides.toString(),
                    subTitle: 'Rides',
                    icon: Assets.imagesPedalBike,
                  )),
            ],
          ),
          SizedBox(
            height: 28,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: kBlackColor.withOpacity(0.05),
                  blurRadius: 18,
                  offset: Offset(0, 7),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MyText(
                        text: 'My Online Status',
                        color: kBlackColor,
                        weight: FontWeight.w500,
                        paddingBottom: 10,
                      ),
                      MyText(
                        text: 'It shows you are online there',
                        size: 10,
                        color: kTextColor8,
                      ),
                    ],
                  ),
                ),
                Obx(() => FlutterSwitch(
                      height: 22,
                      width: 44,
                      toggleSize: 18,
                      activeColor: kBlueColor,
                      padding: 2,
                      value: controller.isShowOnline.value,
                      onToggle: (v) async {
                        await controller.handleOnlineStatus();
                      },
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 24,
          ),
          _ProfileTile(
            title: 'Profile',
            subTitle: 'Edit your basic profile option',
            icon: Assets.imagesProfile,
            onTap: () => Get.to(() => EditProfile()),
          ),
          // _ProfileTile(
          //   title: 'Your favorites',
          //   subTitle: 'Reorder your favorite service in a click',
          //   icon: Assets.imagesHeartOutlineBlack,
          //   onTap: () => Get.to(() => DealerSupport()),
          // ),
          Visibility(
            visible: Platform.isAndroid,
            child: _ProfileTile(
              title: 'Favorite Posts',
              subTitle: 'The posts you added to your favorites',
              icon: Assets.imagesHeartOutlineBlack,
              onTap: () => Get.to(
                () => UserFavPosts(),
                binding: UserFavPostBinding(),
              ),
            ),
          ),
          _ProfileTile(
            title: 'Subscriptions',
            subTitle: 'Subscribe to a plan which suits you best',
            icon: Assets.imagesCreditCard,
            onTap: () => Get.to(
              () => Subscriptions(),
            ),
          ),

          _ProfileTile(
            title: 'Active Subscriptions',
            subTitle: 'Your active subscriptions',
            icon: Assets.imagesCreditCard,
            onTap: () => Get.to(
              () => ActiveSubscriptions(),
            ),
          ),
          // _ProfileTile(
          //   title: 'Register as partner',
          //   subTitle: 'Want to list your service? Register with us',
          //   icon: Assets.imagesPartner,
          //   onTap: () => Get.to(
          //     () => Membership(),
          //   ),
          // ),
          _ProfileTile(
            title: 'About',
            subTitle: 'Privacy Policy, Terms of Services, Licenses',
            icon: Assets.imagesAbout,
            onTap: () {
              Get.to(
                () => PrivacyPolicy(),
                binding: PrivacyBinding(),
              );
            },
          ),
          GestureDetector(
            onTap: () {
              Get.bottomSheet(
                _LogoutBottomSheet(
                  title: "Logout?",
                  subtitle: "Are you sure want to logout from the app?",
                  actionBtnText: "Logout",
                  onActionBtnTap: () async {
                    //logging out the user
                    await FirebaseAuth.instance.signOut();

                    GoogleSignIn googleSignIn = GoogleSignIn();

                    await GoogleSignIn().signOut();

                    try {
                      await googleSignIn.disconnect();
                      await googleSignIn.currentUser!.clearAuthCache();

                      log("Google acccount disconnected and signed out");
                    } catch (e) {
                      log('failed to disconnect on signout');
                    }

                    //deleting isRemember me key from local storage
                    await LocalStorageService.instance
                        .deleteKey(key: "isRememberMe");

                    Get.offAll(
                      () => Login(),
                      binding: LogoutBinding(),
                    );
                  },
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.imagesLogout,
                  height: 24,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: MyText(
                    text: 'Logout',
                    size: 15,
                    color: kRedColor,
                    weight: FontWeight.w700,
                    fontFamily: AppFonts.DM_SANS,
                  ),
                ),
                Image.asset(
                  Assets.imagesArrowIosRight,
                  height: 16,
                  color: kRedColor,
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 15,
          ),

          //delete account button
          GestureDetector(
            onTap: () {
              Get.bottomSheet(
                _LogoutBottomSheet(
                  title: "Delete Account?",
                  subtitle: "Are you sure you want to delete your account?",
                  actionBtnText: "Delete",
                  onActionBtnTap: () async {
                    await controller.initiateDeleteAccount(context: context);
                  },
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.imagesLogout,
                  height: 24,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: MyText(
                    text: 'Delete Account',
                    size: 15,
                    color: kRedColor,
                    weight: FontWeight.w700,
                    fontFamily: AppFonts.DM_SANS,
                  ),
                ),
                Image.asset(
                  Assets.imagesArrowIosRight,
                  height: 16,
                  color: kRedColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileDetailColumn extends StatelessWidget {
  final String title, subTitle, icon;
  const _ProfileDetailColumn({
    required this.title,
    required this.subTitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MyText(
          text: title,
          size: 16,
          color: kBlackColor,
          weight: FontWeight.w500,
          paddingBottom: 12,
        ),
        Wrap(
          spacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Image.asset(
              icon,
              height: 16,
            ),
            MyText(
              text: subTitle,
              size: 12,
              color: kLightGreyColor3,
            ),
          ],
        )
      ],
    );
  }
}

class _LogoutBottomSheet extends StatelessWidget {
  const _LogoutBottomSheet({
    required this.title,
    required this.subtitle,
    required this.actionBtnText,
    required this.onActionBtnTap,
  });

  final String title, subtitle, actionBtnText;

  final VoidCallback onActionBtnTap;

  @override
  Widget build(BuildContext context) {
    return SimpleBottomSheet(
      height: 160,
      child: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: MyText(
                    text: title,
                    size: 18,
                    fontFamily: AppFonts.DM_SANS,
                    weight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Image.asset(
                    Assets.imagesClose2,
                    height: 24,
                  ),
                ),
              ],
            ),
            Expanded(
              child: MyText(
                text: subtitle,
                size: 15,
                fontFamily: AppFonts.DM_SANS,
                color: kTextColor5,
                paddingTop: 8,
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: MyBorderButton(
                    buttonText: 'Cancel',
                    borderColor: kTertiaryColor,
                    textColor: kTertiaryColor,
                    weight: FontWeight.w500,
                    onTap: () => Get.back(),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 6,
                  child: MyButton(
                    buttonText: actionBtnText,
                    bgColor: kRedColor,
                    onTap: onActionBtnTap,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final String title, subTitle, icon;
  final VoidCallback onTap;
  const _ProfileTile({
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 33),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              icon,
              height: 24,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MyText(
                          text: title,
                          size: 15,
                          weight: FontWeight.w700,
                          fontFamily: AppFonts.DM_SANS,
                        ),
                        MyText(
                          text: subTitle,
                          size: 10,
                          color: kTextColor5,
                          fontFamily: AppFonts.DM_SANS,
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    Assets.imagesArrowIosRight,
                    height: 16,
                    color: kQuaternaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//premium user badge
class _PremiumUserBdage extends StatelessWidget {
  const _PremiumUserBdage({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Image.asset(
          Assets.imagesMembership,
          height: 20,
        ),
        MyText(
          text: 'Premium User',
          size: 11,
          color: kBlackColor,
          weight: FontWeight.w500,
          fontFamily: AppFonts.SYNE,
          paddingLeft: 2,
          paddingRight: 6,
        ),
      ],
    );
  }
}
