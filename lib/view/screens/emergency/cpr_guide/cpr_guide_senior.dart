import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/view/widget/my_button_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:bike_gps/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/material.dart';

class CPRGuideSenior extends StatelessWidget {
  CPRGuideSenior({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Emergency & safety',
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
                Center(
                  child: Image.asset(
                    Assets.imagesE4,
                    height: 160,
                  ),
                ),
                MyText(
                  paddingTop: 13,
                  text:
                      'Put the palm of your hand on the person’s forehead and tilt your head back. Gently lift their chin forward with your other hand.',
                  color: kRedColor,
                  textAlign: TextAlign.center,
                  paddingBottom: 56,
                ),
                Center(
                  child: Image.asset(
                    Assets.imagesE5,
                    height: 160,
                  ),
                ),
                MyText(
                  paddingTop: 34,
                  text:
                      'Give two rescue breaths, each 1 second. Watch for their chest to rise with each breath. ',
                  color: kRedColor,
                  textAlign: TextAlign.center,
                  size: 13,
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
