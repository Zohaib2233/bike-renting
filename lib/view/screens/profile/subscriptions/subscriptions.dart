import 'package:bike_gps/controllers/in_app_purchases/inapp_purchases_controller.dart';
import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_fonts.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/core/utils/dialogs.dart';
import 'package:bike_gps/view/screens/legal/license_agreement.dart';
import 'package:bike_gps/view/screens/legal/privacy_policy_screen.dart';
import 'package:bike_gps/view/screens/profile/subscriptions/add_card.dart';
import 'package:bike_gps/view/widget/common_image_view_widget.dart';
import 'package:bike_gps/view/widget/custom_bottom_sheet_widget.dart';
import 'package:bike_gps/view/widget/my_button_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';

// ignore: must_be_immutable
class Subscriptions extends StatefulWidget {
  Subscriptions({super.key});

  @override
  State<Subscriptions> createState() => _SubscriptionsState();
}

class _SubscriptionsState extends State<Subscriptions> {
  //finding InAppPurchasesController
  InAppPurchasesController inAppPurchasesController =
      Get.find<InAppPurchasesController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    inAppPurchasesController.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: MyText(
          text: 'Subscriptions',
          size: 18,
          weight: FontWeight.w700,
          fontFamily: AppFonts.DM_SANS,
        ),
      ),
      body: Column(
        children: [
          Obx(() => ListView.builder(
              shrinkWrap: true,
              itemCount: inAppPurchasesController.packages.length,
              itemBuilder: (context, index) {
                //getting package
                Package package = inAppPurchasesController.packages[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(() => _MembershipButton(
                        title: "${package.storeProduct.title}",
                        onTap: () async {
                          inAppPurchasesController.setSubscriptionPlanIndex =
                              index;

                          //showing progress dialog
                          DialogService.instance
                              .showProgressDialog(context: context);

                          await inAppPurchasesController.purchasePlan(
                              package: package);

                          //popping progress dialog
                          Navigator.pop(context);
                        },
                        isSelected:
                            inAppPurchasesController.selectedPlanIndex.value ==
                                index,
                        price:
                            "${package.storeProduct.currencyCode} ${package.storeProduct.price}",
                        billingPeriod:
                            package.storeProduct.subscriptionPeriod == "P1M"
                                ? "Month"
                                : "Year",
                        days: package.storeProduct.subscriptionPeriod == "P1M"
                            ? "30"
                            : "365",
                      )),
                );

                // return Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: _PaymentMethodTile(
                //     onTap: () async {
                //       log("title: ${package.storeProduct.title}");
                //       //showing progress dialog
                //       DialogService.instance.showProgressDialog(context: context);

                //       await inAppPurchasesController.purchasePlan(package: package);

                //       //popping progress dialog
                //       Navigator.pop(context);
                //     },
                //     icon: Assets.imagesCreditCard,
                //     title: "${package.storeProduct.title}",
                //     trailing: "In ${package.storeProduct.price}",
                //   ),
                // );
              })),

          const SizedBox(
            height: 20,
          ),

          //license agreement url launcher
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  Get.to(() => LicenseAgreement());
                },
                child: Text(
                  'License Agreement',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    fontFamily: AppFonts.NUNITO_SANS,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          //license agreement url launcher
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  Get.to(() => PrivacyPolicyScreen());
                },
                child: Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    fontFamily: AppFonts.NUNITO_SANS,
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

//membership button tile
class _MembershipButton extends StatelessWidget {
  final String title, price, billingPeriod, days;
  final bool isSelected;
  final VoidCallback onTap;
  const _MembershipButton({
    required this.title,
    required this.onTap,
    required this.isSelected,
    required this.price,
    required this.billingPeriod,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isSelected ? kSecondaryColor : kTransparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? kTransparent : kLightGreyColor7,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                MyText(
                  text: title,
                  color: isSelected ? kPrimaryColor : kTertiaryColor,
                  weight: FontWeight.w700,
                  fontFamily: AppFonts.NUNITO_SANS,
                  paddingBottom: 2,
                ),
                Row(
                  children: [
                    CommonImageView(
                      imagePath: Assets.imagesRenew,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    MyText(
                      text: "Auto Renewed",
                      color: isSelected ? kPrimaryColor : kSecondaryColor,
                      weight: FontWeight.w700,
                      fontFamily: AppFonts.NUNITO_SANS,
                      paddingBottom: 2,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            MyText(
              text: '$price',
              size: 24,
              color: isSelected ? kPrimaryColor : kTertiaryColor,
              weight: FontWeight.w800,
              fontFamily: AppFonts.NUNITO_SANS,
              paddingBottom: 2,
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MyText(
                    text: "Billed every $billingPeriod",
                    size: 12,
                    color: isSelected ? kPrimaryColor : kHintColor,
                    weight: FontWeight.w500,
                    fontFamily: AppFonts.NUNITO_SANS,
                  ),
                ),
                Expanded(
                  child: MyText(
                    text: "$days days",
                    color: isSelected ? kPrimaryColor : kSecondaryColor,
                    weight: FontWeight.w700,
                    fontFamily: AppFonts.NUNITO_SANS,
                    paddingBottom: 2,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 5,
            ),

            //features provided
            MyText(
              text:
                  "Access bike tracking, lock/unlock and bike steal reporting features during subscription period",
              color: isSelected ? kPrimaryColor : kTertiaryColor,
              size: 12,
              weight: FontWeight.w500,
              fontFamily: AppFonts.NUNITO_SANS,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddPaymentMethodSheet extends StatelessWidget {
  const _AddPaymentMethodSheet();

  @override
  Widget build(BuildContext context) {
    return SimpleBottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Image.asset(
                    Assets.imagesClose2,
                    height: 24,
                  ),
                ),
                MyText(
                  text: 'Add payment method',
                  size: 18,
                  weight: FontWeight.w700,
                  fontFamily: AppFonts.DM_SANS,
                  paddingLeft: 8,
                ),
              ],
            ),
          ),
          Container(
            height: 0.5,
            color: kInputBorderColor,
          ),
          Expanded(
            child: ListView(
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              children: [
                _addPaymentMethodTile(
                  title: 'Apple Pay',
                  icon: Assets.imagesApplePay,
                  onTap: () {
                    Get.to(
                      () => AddCard(),
                    );
                  },
                ),
                _addPaymentMethodTile(
                  title: 'PayPal',
                  icon: Assets.imagesPaypal,
                  onTap: () {},
                ),
                _addPaymentMethodTile(
                  title: 'Credit or debit card',
                  icon: Assets.imagesCreditCardMethod,
                  onTap: () {},
                ),
                _addPaymentMethodTile(
                  title: 'Gift Card',
                  icon: Assets.imagesGiftCard,
                  onTap: () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: MyButton(
              buttonText: 'Show 32 results',
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _addPaymentMethodTile({
    required String title,
    required String icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: kInputBorderColor,
            width: 0.5,
          ),
        ),
      ),
      child: MyRippleEffect(
        onTap: onTap,
        radius: 0,
        splashColor: kBlackColor.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Image.asset(
                icon,
                height: 24,
              ),
              Expanded(
                child: MyText(
                  text: title,
                  size: 15,
                  weight: FontWeight.w700,
                  fontFamily: AppFonts.DM_SANS,
                  paddingLeft: 12,
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
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final String title, icon, trailing;

  final VoidCallback onTap;

  const _PaymentMethodTile({
    required this.title,
    required this.trailing,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Image.asset(
        icon,
        height: 24,
      ),
      title: MyText(
        text: title,
        size: 15,
        weight: FontWeight.w700,
        fontFamily: AppFonts.DM_SANS,
        paddingLeft: 12,
      ),
      trailing: MyText(
        text: trailing,
        size: 12,
        color: kQuaternaryColor,
        weight: FontWeight.w700,
        fontFamily: AppFonts.DM_SANS,
      ),
    );
  }
}
