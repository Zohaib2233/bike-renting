import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/view/screens/emergency/call_emergency.dart';
import 'package:bike_gps/view/screens/emergency/cpr_guide/cpr_guide_adult.dart';
import 'package:bike_gps/view/screens/emergency/cpr_guide/cpr_guide_child.dart';
import 'package:bike_gps/view/screens/emergency/cpr_guide/cpr_guide_infant.dart';
import 'package:bike_gps/view/screens/emergency/cpr_guide/cpr_guide_senior.dart';
import 'package:bike_gps/view/widget/my_button_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:bike_gps/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Emergency extends StatelessWidget {
  Emergency({super.key});

  final List<Map<String, dynamic>> _data = [
    {
      'icon': Assets.imagesInfant,
      'title': 'Infant',
    },
    {
      'icon': Assets.imagesChild18,
      'title': 'Children 1-8',
    },
    {
      'icon': Assets.imagesAdult,
      'title': 'Adult',
    },
    {
      'icon': Assets.imagesSenior,
      'title': 'Senior',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Emergency & safety',
        haveLeading: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              itemCount: _data.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1.0,
                            color: kRedColor,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              switch (index) {
                                case 0:
                                  Get.to(() => CPRGuideInfant());
                                  break;
                                case 1:
                                  Get.to(() => CPRGuideChild());
                                  break;
                                case 2:
                                  Get.to(() => CPRGuideAdult());
                                  break;
                                case 3:
                                  Get.to(() => CPRGuideSenior());
                                  break;
                                default:
                                  () {};
                              }
                            },
                            borderRadius: BorderRadius.circular(10),
                            splashColor: kRedColor.withOpacity(0.1),
                            highlightColor: kRedColor.withOpacity(0.1),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(
                                child: Image.asset(_data[index]['icon']),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    MyText(
                      paddingTop: 6,
                      text: _data[index]['title'],
                      size: 10,
                      weight: FontWeight.bold,
                      color: kRedColor,
                    ),
                  ],
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                mainAxisExtent: 113,
              ),
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: MyButton(
              radius: 50.0,
              onTap: () {
                Get.to(() => CallEmergency());
              },
              bgColor: kRedColor,
              buttonText: 'Call Emergency',
            ),
          ),
        ],
      ),
    );
  }
}
