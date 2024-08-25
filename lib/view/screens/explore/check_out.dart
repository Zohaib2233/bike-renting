import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/view/screens/explore/my_cart.dart';
import 'package:bike_gps/view/widget/common_image_view_widget.dart';
import 'package:bike_gps/view/widget/my_button_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:bike_gps/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Checkout extends StatelessWidget {
  const Checkout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: simpleAppBar(
        title: 'My Cart',
        actions: [
          Center(
            child: Image.asset(
              Assets.imagesBag,
              height: 24,
            ),
          ),
          SizedBox(
            width: 16,
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
                  text: 'Contact Information',
                  size: 14,
                  weight: FontWeight.w500,
                  paddingBottom: 16,
                ),
                Row(
                  children: [
                    Image.asset(
                      Assets.imagesEml,
                      height: 40,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          MyText(
                            text: 'emmanueloyiboke@gmail.com',
                            size: 14,
                            weight: FontWeight.w500,
                          ),
                          MyText(
                            text: 'Email',
                            size: 12,
                            color: kGreyColor,
                            weight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      Assets.imagesEdit,
                      height: 20,
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Image.asset(
                      Assets.imagesPhne,
                      height: 40,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          MyText(
                            text: '+234-811-732-5298',
                            size: 14,
                            weight: FontWeight.w500,
                          ),
                          MyText(
                            text: 'Phone',
                            size: 12,
                            color: kGreyColor,
                            weight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      Assets.imagesEdit,
                      height: 20,
                    ),
                  ],
                ),
                MyText(
                  paddingTop: 16,
                  text: 'Address',
                  size: 14,
                  weight: FontWeight.w500,
                  paddingBottom: 6,
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyText(
                        text: '1082 Airport Road, Nigeria',
                        size: 12,
                        color: kGreyColor,
                        weight: FontWeight.w500,
                      ),
                    ),
                    Image.asset(
                      Assets.imagesDrpIcon,
                      height: 20,
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Stack(
                  children: [
                    CommonImageView(
                      imagePath: Assets.imagesDummyMap,
                      height: 101,
                      width: Get.width,
                      fit: BoxFit.cover,
                      radius: 16,
                    ),
                    CommonImageView(
                      imagePath: Assets.imagesViewMap,
                      height: 101,
                      width: Get.width,
                      fit: BoxFit.cover,
                      radius: 16,
                    ),
                  ],
                ),
                MyText(
                  paddingTop: 12,
                  text: 'Payment Method',
                  size: 14,
                  weight: FontWeight.w500,
                  paddingBottom: 16,
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color(0xffF8F9FA),
                      ),
                      child: Center(
                        child: Image.asset(
                          Assets.imagesDbl,
                          height: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          MyText(
                            text: 'DbL Card',
                            size: 14,
                            weight: FontWeight.w500,
                          ),
                          MyText(
                            text: '**** **** 0696 4629',
                            size: 12,
                            color: kGreyColor,
                            weight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      Assets.imagesDrpIcon,
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: TotalAndSubTotal(),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: MyButton(
              onTap: () {
                Get.dialog(
                  _CongratsDialog(),
                );
              },
              buttonText: 'Checkout',
            ),
          ),
        ],
      ),
    );
  }
}

class _CongratsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: AppSizes.DEFAULT,
          padding: EdgeInsets.all(36),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: kPrimaryColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Image.asset(
                  Assets.imagesCongrats,
                  height: 121,
                ),
              ),
              MyText(
                paddingTop: 21,
                paddingBottom: 21,
                text: 'Your Payment Is Successful',
                size: 18.8,
                textAlign: TextAlign.center,
              ),
              MyButton(
                onTap: () {
                  Get.back();
                },
                buttonText: 'Back To Shopping',
                radius: 14.46,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
