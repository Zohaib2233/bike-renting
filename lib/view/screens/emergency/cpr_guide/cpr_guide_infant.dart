import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/view/widget/my_button_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:bike_gps/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/material.dart';

class CPRGuideInfant extends StatelessWidget {
  CPRGuideInfant({super.key});

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
                    Assets.imagesE2,
                    height: 152,
                  ),
                ),
                MyText(
                  paddingTop: 14,
                  text: 'Both hands interlocked between nipples',
                  color: kRedColor,
                  textAlign: TextAlign.center,
                  paddingBottom: 56,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    Image.asset(
                      Assets.imagesH1,
                      height: 113,
                    ),
                    SizedBox(),
                    Image.asset(
                      Assets.imagesH2,
                      height: 102,
                    ),
                    SizedBox(),
                  ],
                ),
                MyText(
                  paddingTop: 34,
                  text:
                      '30 compression at 100-120 compression per minute immediately alternate each compression session with two Rescue Breaths',
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
