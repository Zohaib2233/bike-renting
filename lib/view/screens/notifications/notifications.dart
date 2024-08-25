import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_fonts.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: MyText(
          text: 'Notification',
          size: 18,
          weight: FontWeight.w700,
          fontFamily: AppFonts.DM_SANS,
        ),
      ),
      body: ListView(
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        children: [
          MyText(
            text: 'New',
            color: kDarkGreyColor3,
            weight: FontWeight.w700,
            paddingBottom: 22,
          ),
          ...List.generate(
            1,
            (index) {
              return _NotificationTile(
                title: 'Reminder! . ',
                notificationText: 'Get ready for your appointment at 9am',
                time: 'Just now',
                bottomPadding: 14,
              );
            },
          ),
          Container(
            height: 0.94,
            color: kLightGreyColor6,
          ),
          MyText(
            text: 'Earlier ',
            color: kDarkGreyColor3,
            weight: FontWeight.w700,
            paddingTop: 15,
            paddingBottom: 22,
          ),
          ...List.generate(
            10,
            (index) {
              return _NotificationTile(
                title: 'Reminder! . ',
                notificationText: 'Get ready for your appointment at 9am',
                time: 'Just now',
              );
            },
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final String title, notificationText, time;
  final double bottomPadding;
  const _NotificationTile({
    super.key,
    required this.title,
    required this.notificationText,
    required this.time,
    this.bottomPadding = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Row(
        children: [
          Image.asset(
            Assets.imagesCalenderBg,
            height: 42,
          ),
          SizedBox(
            width: 22,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 13.2,
                      color: kTextColor2,
                      fontFamily: AppFonts.DM_SANS,
                    ),
                    children: [
                      TextSpan(
                        text: title,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: notificationText,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MyText(
                text: time,
                size: 11.32,
                color: kTextColor9,
                paddingBottom: 8,
              ),
              CircleAvatar(
                backgroundColor: kSecondaryColor,
                radius: 4,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
