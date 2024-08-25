import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/main.dart';
import 'package:bike_gps/view/widget/common_image_view_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:bike_gps/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class DealerSupport extends StatelessWidget {
  const DealerSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Dealer Support',
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: AppSizes.DEFAULT,
        children: [
          Row(
            children: [
              CommonImageView(
                url: dummyImg,
                height: 52,
                width: 52,
                radius: 100,
              ),
              SizedBox(
                width: 9,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MyText(
                      text: 'Dealer Name',
                      weight: FontWeight.w500,
                    ),
                    MyText(
                      text: 'Street 27, road abc, Poland',
                      size: 10,
                      color: kGreyColor8,
                      weight: FontWeight.w500,
                    ),
                    MyText(
                      text: '34 m ago',
                      size: 10,
                      color: kGreyColor8,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 27,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 13,
            ),
            decoration: BoxDecoration(
              color: kSecondaryColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: 'My Questions',
                      size: 12,
                      color: kPrimaryColor,
                      weight: FontWeight.w500,
                    ),
                    MyText(
                      text: 'My Answers',
                      size: 12,
                      color: kPrimaryColor,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
                SizedBox(
                  height: 7,
                ),
                StepProgressIndicator(
                  totalSteps: 100,
                  currentStep: 40,
                  size: 2,
                  padding: 0,
                  selectedColor: kPrimaryColor,
                  unselectedColor: kPrimaryColor.withOpacity(0.26),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ...List.generate(10, (index) {
            return _DealerSupportCard(
              image: dummyImg,
              name: 'Dealer name',
              title: '',
              subTitle: 'Asked',
              time: '2 min ago',
              onLike: () {},
              onReply: () {},
              onMenuTap: () {},
            );
          }),
        ],
      ),
    );
  }
}

class _DealerSupportCard extends StatelessWidget {
  final String name, image, title, subTitle, time;
  final VoidCallback onLike, onReply, onMenuTap;
  const _DealerSupportCard({
    required this.name,
    required this.title,
    required this.subTitle,
    required this.time,
    required this.onLike,
    required this.onReply,
    required this.onMenuTap,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      margin: EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: kSecondaryColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonImageView(
                url: image,
                height: 32,
                width: 32,
                radius: 100,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyText(
                      text: name,
                      size: 11,
                      weight: FontWeight.w500,
                    ),
                    MyText(
                      text: subTitle,
                      size: 10,
                      color: kGreyColor8,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              MyText(
                text: time,
                size: 10,
                color: kGreyColor8,
              ),
            ],
          ),
          SizedBox(
            height: 18,
          ),
          Container(
            height: 2,
            color: kLightGreyColor7.withOpacity(0.38),
          ),
          MyText(
            text: title,
            weight: FontWeight.w500,
            paddingTop: 14,
            paddingBottom: 15,
          ),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Image.asset(
                      Assets.imagesFacebookLike,
                      height: 20,
                    ),
                    MyText(
                      text: 'Liked',
                      size: 12,
                      color: kGreyColor8,
                      paddingLeft: 6,
                      onTap: onLike,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 18),
                      height: 14,
                      width: 1,
                      color: kGreyColor8,
                    ),
                    Image.asset(
                      Assets.imagesSpeechBubble,
                      height: 20,
                    ),
                    MyText(
                      text: 'Replies',
                      size: 12,
                      color: kGreyColor8,
                      paddingLeft: 6,
                      onTap: onReply,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onMenuTap,
                child: Image.asset(
                  Assets.imagesVerticalMenu,
                  height: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
