import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_fonts.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/main.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_stack/image_stack.dart';

class Membership extends StatelessWidget {
  const Membership({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: kSecondaryColor,
        title: Image.asset(
          Assets.imagesLogoText,
          height: 15,
        ),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyText(
                text: 'Skip',
                size: 16,
                color: kPrimaryColor,
                fontFamily: AppFonts.NUNITO_SANS,
                weight: FontWeight.w600,
                paddingRight: 20,
              ),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            padding: AppSizes.HORIZONTAL,
            color: kSecondaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyText(
                  text: '',
                  size: 18,
                  color: kPrimaryColor,
                  weight: FontWeight.w700,
                  fontFamily: AppFonts.NUNITO_SANS,
                  textAlign: TextAlign.center,
                  paddingBottom: 12,
                ),
                MyText(
                  text:
                      '',
                  color: kPrimaryColor,
                  fontFamily: AppFonts.NUNITO_SANS,
                  textAlign: TextAlign.center,
                  paddingBottom: 31,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageStack(
                      imageList: [
                        dummyImg,
                        dummyImg,
                        dummyImg,
                        dummyImg,
                        dummyImg,
                      ],
                      totalCount: 5,
                      imageRadius: 36,
                      imageCount: 5,
                      imageBorderWidth: 2,
                      imageBorderColor: kPrimaryColor,
                    ),
                  ],
                ),
                MyText(
                  text: 'Joey and millions of other people use\nour membership',
                  color: kPrimaryColor,
                  fontFamily: AppFonts.NUNITO_SANS,
                  textAlign: TextAlign.center,
                  paddingTop: 17,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              children: [
                MyText(
                  text: 'Membership Plans',
                  size: 18,
                  weight: FontWeight.w700,
                  fontFamily: AppFonts.NUNITO_SANS,
                  paddingBottom: 22,
                ),
                ...List.generate(
                  4,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Image.asset(
                            Assets.imagesCheckBlack,
                            height: 20,
                          ),
                          Expanded(
                            child: MyText(
                              text: 'Membership Plans',
                              weight: FontWeight.w500,
                              fontFamily: AppFonts.NUNITO_SANS,
                              paddingLeft: 8,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                _MembershipButton(
                  title: 'KNAAP, Monthly',
                  subTitle: 'Billed every month',
                  price: 80.00,
                  isSelected: false,
                  onTap: () {},
                ),
                _MembershipButton(
                  title: 'KNAAP, Annual',
                  subTitle: 'Billed every year',
                  price: 80.00,
                  isSelected: true,
                  onTap: () {},
                ),
                MyText(
                  text: 'Restore purchase',
                  weight: FontWeight.w700,
                  fontFamily: AppFonts.NUNITO_SANS,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MembershipButton extends StatelessWidget {
  final String title, subTitle;
  final bool isSelected;
  final double price;
  final VoidCallback onTap;
  const _MembershipButton({
    required this.title,
    required this.subTitle,
    required this.onTap,
    required this.isSelected,
    required this.price,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyText(
              text: title,
              color: isSelected ? kPrimaryColor : kTertiaryColor,
              weight: FontWeight.w700,
              fontFamily: AppFonts.NUNITO_SANS,
              paddingBottom: 2,
            ),
            MyText(
              text: '\$ $price',
              size: 24,
              color: isSelected ? kPrimaryColor : kTertiaryColor,
              weight: FontWeight.w800,
              fontFamily: AppFonts.NUNITO_SANS,
              paddingBottom: 2,
            ),
            MyText(
              text: title,
              size: 12,
              color: isSelected ? kPrimaryColor : kHintColor,
              weight: FontWeight.w500,
              fontFamily: AppFonts.NUNITO_SANS,
            ),
          ],
        ),
      ),
    );
  }
}
