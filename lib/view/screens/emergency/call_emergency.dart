import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/view/widget/my_button_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:bike_gps/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/material.dart';

class CallEmergency extends StatelessWidget {
  CallEmergency({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Emergency & safety',
        haveLeading: false,
        actions: [
          Center(
            child: Image.asset(
              Assets.imagesCall,
              height: 24,
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              children: [
                MyText(
                  text: '1. Survey the scene.',
                  size: 14,
                  weight: FontWeight.bold,
                  color: kRedColor,
                  paddingBottom: 12,
                ),
                MyText(
                  text:
                      'Make sure it’s safe for you to reach the person in need of help.',
                  size: 14,
                  color: kRedColor,
                  paddingBottom: 12,
                ),
                MyText(
                  text: '2. Check the person for responsiveness.',
                  size: 14,
                  weight: FontWeight.bold,
                  color: kRedColor,
                  paddingBottom: 12,
                ),
                MyText(
                  text: 'Tap their shoulder and ask loudly, “Are you OK?”',
                  size: 14,
                  color: kRedColor,
                  paddingBottom: 12,
                ),
                MyText(
                  text:
                      '3. If the person isn’t responsive, seek immediate help.',
                  size: 14,
                  weight: FontWeight.bold,
                  color: kRedColor,
                  paddingBottom: 12,
                ),
                MyText(
                  text:
                      'f you’re alone and believe the person is a victim of drowning, begin CPR first for 2 minutes before calling emergency services.',
                  size: 14,
                  color: kRedColor,
                  paddingBottom: 12,
                ),
                MyText(
                  text: '4. Place the person on a firm, flat surface.',
                  size: 14,
                  weight: FontWeight.bold,
                  color: kRedColor,
                  paddingBottom: 12,
                ),
                MyText(
                  text:
                      'place them safely on a flat surface and kneel beside them.',
                  size: 14,
                  color: kRedColor,
                  paddingBottom: 12,
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: MyButton(
              radius: 50.0,
              onTap: () {},
              bgColor: kRedColor,
              buttonText: 'Next',
            ),
          ),
        ],
      ),
    );
  }
}
