import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/view/screens/user_profile/bike_information.dart';
import 'package:bike_gps/view/widget/headings_widget.dart';
import 'package:bike_gps/view/widget/my_button_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:bike_gps/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LetsStarted extends StatelessWidget {
  const LetsStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Bike Setup',
        titleColor: kSecondaryColor,
        leadingIcon: Assets.imagesMenu,
        leadingIconSize: 12,
      ),
      body: Column(
        children: [
          AuthHeading(
            title: 'Let’s get started',
            subTitle: 'Please select an option bellow',
            paddingTop: 15,
            paddingBottom: 16,
          ),
          MyText(
            text:
                'Welcome to the KNAAP crew! I will be your perfect WINGMAN. Let’s have an awesome ride together.',
            size: 12,
            color: kLightGreyColor2.withOpacity(0.56),
            weight: FontWeight.w300,
            textAlign: TextAlign.center,
            paddingLeft: 20,
            paddingRight: 20,
            paddingBottom: 51,
          ),
          Padding(
            padding: AppSizes.HORIZONTAL,
            child: MyButton(
              buttonText: 'Next',
              onTap: () => Get.to(
                () => BikeInformation(),
              ),
            ),
          ),
          Expanded(
            child: Image.asset(
              Assets.imagesMap,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
