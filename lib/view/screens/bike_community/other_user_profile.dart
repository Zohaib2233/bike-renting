import 'package:bike_gps/constants/app_images.dart';
import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/main.dart';
import 'package:bike_gps/view/widget/common_image_view_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_fonts.dart';

class OtherUserProfile extends StatelessWidget {
  const OtherUserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> _tabs = [
      'POSTS',
      'MEDIA',
    ];
    return DefaultTabController(
      length: _tabs.length,
      initialIndex: 0,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                elevation: 1,
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                expandedHeight: 300,
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Container(
                          padding: AppSizes.HORIZONTAL,
                          color: Color(0xff79A73A).withOpacity(0.17),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CommonImageView(
                                      height: 80,
                                      width: 80,
                                      radius: 100.0,
                                      url: dummyImg,
                                    ),
                                    MyText(
                                      paddingTop: 6,
                                      paddingBottom: 4,
                                      text: 'John Amelia',
                                      size: 16,
                                      weight: FontWeight.w500,
                                    ),
                                    Row(
                                      children: [
                                        MyText(
                                          text: '@jamesjcall ',
                                          size: 14,
                                          color: Color(0xff5B5B5B)
                                              .withOpacity(0.6),
                                          paddingRight: 7,
                                        ),
                                        CircleAvatar(
                                          radius: 5,
                                          backgroundColor: Color(0xff2FFF2B),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 50,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Column(
                                          children: [
                                            MyText(
                                              text: '142',
                                              size: 16,
                                              weight: FontWeight.w500,
                                            ),
                                            MyText(
                                              text: 'Posts',
                                              size: 12,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          children: [
                                            MyText(
                                              text: '142',
                                              size: 16,
                                              weight: FontWeight.w500,
                                            ),
                                            MyText(
                                              text: 'Friends',
                                              size: 12,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: AppSizes.DEFAULT,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            MyText(
                              text:
                                  'Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis ajodjmdokf.',
                              size: 13,
                              paddingBottom: 12,
                            ),
                            Row(
                              children: [
                                MyText(
                                  text: 'More info',
                                  size: 13,
                                  weight: FontWeight.w500,
                                  color: Color(0xff157EFE),
                                  paddingRight: 8,
                                ),
                                Image.asset(
                                  Assets.imagesEditNewIcon,
                                  height: 16,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size(0, 55),
                  child: Container(
                    color: kPrimaryColor,
                    child: TabBar(
                      labelColor: Color(0xff157EFE),
                      labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.DM_SANS,
                        color: kBlackColor,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: AppFonts.DM_SANS,
                        color: Color(0xff737479),
                      ),
                      tabs: _tabs
                          .map((e) => Tab(
                                child: Text(
                                  e == 'POSTS' ? '335 $e' : '1212 $e',
                                ),
                              ))
                          .toList(),
                      indicatorColor: Color(0xff157EFE),
                      indicatorWeight: 2,
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              _Posts(),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Posts extends StatelessWidget {
  const _Posts({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 120,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: BouncingScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        if (index == 4) {
          return Stack(
            children: [
              CommonImageView(
                width: Get.width,
                height: Get.height,
                radius: 0.0,
                url: dummyImg,
              ),
              Center(
                child: Image.asset(
                  Assets.imagesPlayButton,
                  height: 30,
                ),
              ),
            ],
          );
        }

        return CommonImageView(
          width: Get.width,
          height: Get.height,
          radius: 0.0,
          url: dummyImg,
        );
      },
    );
  }
}
