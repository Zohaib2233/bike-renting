import 'package:bike_gps/controllers/home/ride_stats_controller.dart';
import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/core/utils/formatters/date_fromatter.dart';
import 'package:bike_gps/models/user_models/user_stats_model.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:bike_gps/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class RiderStates extends StatelessWidget {
  RiderStates({super.key});

  //finding RideStatsController
  RideStatsController controller = Get.find<RideStatsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Rider States',
      ),
      body: ListView(
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        children: [
          Image.asset(
            Assets.images3dBike,
            height: 125,
          ),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder<UserStatsModel>(
              future: controller.getUserStats(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  //if we got an error
                  if (snapshot.hasError) {
                    // showSnackbar(title: 'Error', msg: 'Try again');
                  }
                  //if we got the data
                  else if (snapshot.hasData) {
                    //getting snapshot data
                    UserStatsModel userStatsModel = snapshot.data!;

                    return Row(
                      children: [
                        Expanded(
                          child: _StatsWidget(
                              title: "SPENT TIME",
                              subTitle:
                                  "${DateFormatters.instance.convertSecondsToHours(userStatsModel.timeSpent!)} H"),
                        ),
                        Expanded(
                          child: _StatsWidget(
                              title: "TOTAL DISTANCE",
                              subTitle: "${userStatsModel.timeSpent!} M"),
                        ),
                      ],
                    );
                  }
                }
                return Center(
                    child: const CupertinoActivityIndicator(
                  animating: true,
                  radius: 20,
                  color: kSecondaryColor,
                ));
              }),
          // Stack(
          //   alignment: Alignment.center,
          //   children: [
          //     GridView.builder(
          //       padding: EdgeInsets.zero,
          //       shrinkWrap: true,
          //       physics: BouncingScrollPhysics(),
          //       itemCount: 4,
          //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //         crossAxisCount: 2,
          //         mainAxisExtent: 140,
          //       ),
          //       itemBuilder: (ctx, index) {
          //         final List<Map<String, dynamic>> data = [
          //           {
          //             'title': '01.00.33',
          //             'subTitle': 'SPEND TIME',
          //           },
          //           {
          //             'title': '25 KM/H',
          //             'subTitle': 'AVERAGE SPEED',
          //           },
          //           {
          //             'title': '2995 M',
          //             'subTitle': 'TOTAL DISTANCE',
          //           },
          //           {
          //             'title': '92 BPM',
          //             'subTitle': 'AVERAGE PULSE',
          //           },
          //         ];

          //         return _StatsWidget(
          //           title: data[index]['title'],
          //           subTitle: data[index]['subTitle'],
          //         );
          //       },
          //     ),
          //     Image.asset(
          //       Assets.imagesDivider,
          //       height: 300,
          //     ),
          //   ],
          // ),
          // GestureDetector(
          //   onTap: () => Get.to(
          //     () => RiderMap(),
          //   ),
          //   child: Image.asset(
          //     Assets.imagesTrackMap,
          //     height: 178,
          //   ),
          // ),
        ],
      ),
    );
  }
}

//stats widget
class _StatsWidget extends StatelessWidget {
  const _StatsWidget({
    super.key,
    required this.title,
    required this.subTitle,
  });

  final String title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 27),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            Assets.imagesOutlineSpeed,
            height: 26,
            alignment: Alignment.centerLeft,
          ),
          MyText(
            text: title,
            size: 28,
            color: kTextColor4,
            weight: FontWeight.w200,
          ),
          MyText(
            text: subTitle,
            size: 11,
            color: kSecondaryColor,
          ),
        ],
      ),
    );
  }
}
