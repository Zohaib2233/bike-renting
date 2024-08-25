import 'package:bike_gps/controllers/in_app_purchases/inapp_purchases_controller.dart';
import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_fonts.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/utils/formatters/date_fromatter.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

// ignore: must_be_immutable
class ActiveSubscriptions extends StatefulWidget {
  ActiveSubscriptions({super.key});

  @override
  State<ActiveSubscriptions> createState() => _ActiveSubscriptionsState();
}

class _ActiveSubscriptionsState extends State<ActiveSubscriptions> {
  //finding InAppPurchasesController
  InAppPurchasesController inAppPurchasesController =
      Get.find<InAppPurchasesController>();

  @override
  void initState() {
    super.initState();

    inAppPurchasesController.getCustomerActiveEntitlements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: MyText(
          text: 'Active Subscriptions',
          size: 18,
          weight: FontWeight.w700,
          fontFamily: AppFonts.DM_SANS,
        ),
      ),
      body: FutureBuilder<List<EntitlementInfo>>(
          future: inAppPurchasesController.getCustomerActiveEntitlements(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              //if we got an error
              if (snapshot.hasError) {
                // showSnackbar(title: 'Error', msg: 'Try again');
              }
              //if we got the data
              else if (snapshot.hasData) {
                //getting active entitlements list
                List<EntitlementInfo> activeEntitlements = snapshot.data!;

                return activeEntitlements.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: activeEntitlements.length,
                        itemBuilder: (context, index) {
                          //getting package
                          EntitlementInfo entitlementInfo =
                              activeEntitlements[index];

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _ActiveSubscriptionTile(
                              onTap: () {
                                // inAppPurchasesController.purchasePlan(package: package);
                              },
                              icon: Assets.imagesCreditCard,
                              title: "${entitlementInfo.identifier}",
                              trailing:
                                  "Expiring on: ${DateFormatters.instance.formatStringDate(dateString: entitlementInfo.expirationDate ?? "")}",
                            ),
                          );
                        })
                    : _NoActiveSubscriptions();
              }
            }
            return Center(
                child: const CupertinoActivityIndicator(
              animating: true,
              radius: 20,
              color: kSecondaryColor,
            ));
          }),
    );
  }
}

//no active subscriptions indicator
class _NoActiveSubscriptions extends StatelessWidget {
  const _NoActiveSubscriptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info),
            MyText(
              text: "You have no active subscriptions",
              size: 15,
              weight: FontWeight.w700,
              fontFamily: AppFonts.DM_SANS,
              paddingLeft: 12,
            ),
          ],
        ),
      ],
    );
  }
}

class _ActiveSubscriptionTile extends StatelessWidget {
  final String title, icon, trailing;

  final VoidCallback onTap;

  const _ActiveSubscriptionTile({
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
        color: kRedColor,
        weight: FontWeight.w700,
        fontFamily: AppFonts.DM_SANS,
      ),
    );
  }
}
