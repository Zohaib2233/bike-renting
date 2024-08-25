import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/view/screens/explore/product_detail.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.imagesMenu,
              height: 18,
            ),
          ],
        ),
        title: Image.asset(
          Assets.imagesExplore,
          height: 38,
        ),
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
      body: ListView(
        shrinkWrap: true,
        padding: AppSizes.VERTICAL,
        children: [
          _Search(),
          SizedBox(
            height: 17,
          ),
          MyText(
            text: 'Select Category',
            size: 16,
            weight: FontWeight.w600,
            paddingLeft: 20,
            paddingBottom: 11,
          ),
          SizedBox(
            height: 40,
            child: ListView.builder(
              itemCount: 10,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 15),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  height: Get.height,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: index == 0 ? kSecondaryColor : kPrimaryColor,
                  ),
                  child: Center(
                    child: MyText(
                      text: 'Category ${index + 1}',
                      size: 12,
                      weight: FontWeight.w500,
                      color: index == 0 ? kPrimaryColor : kQuaternaryColor,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 13,
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  text: 'Popular Bikes',
                  size: 16,
                  weight: FontWeight.w500,
                ),
                MyText(
                  text: 'See all',
                  size: 12,
                  weight: FontWeight.w500,
                  color: kSecondaryColor,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 201,
            child: ListView.builder(
              itemCount: 10,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 15),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Get.to(() => ProductDetail()),
                  child: Stack(
                    children: [
                      Container(
                        height: Get.height,
                        width: 157,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: kPrimaryColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Image.asset(Assets.imagesDummy),
                            MyText(
                              text: 'Best Seller'.toUpperCase(),
                              size: 12,
                              weight: FontWeight.w500,
                              color: kSecondaryColor,
                            ),
                            MyText(
                              text: 'Bike 01',
                              size: 16,
                              weight: FontWeight.w500,
                              color: kGreyColor,
                              paddingBottom: 4,
                            ),
                            MyText(
                              text: '\$1302.00',
                              size: 14,
                              weight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                            color: kSecondaryColor,
                          ),
                          child: Icon(
                            Icons.add,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  text: 'New Arrivals',
                  size: 16,
                  weight: FontWeight.w500,
                ),
                MyText(
                  text: 'See all',
                  size: 12,
                  weight: FontWeight.w500,
                  color: kSecondaryColor,
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSizes.HORIZONTAL,
            child: Image.asset(
              Assets.imagesNew,
              width: Get.width,
            ),
          ),
        ],
      ),
    );
  }
}

class _Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSizes.HORIZONTAL,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: kPrimaryColor,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 3),
                    blurRadius: 5,
                    color: kTertiaryColor.withOpacity(0.1),
                  ),
                ],
              ),
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  prefixIcon: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Assets.imagesSearch,
                        height: 20,
                        color: kGreyColor,
                      ),
                    ],
                  ),
                  hintText: 'Looking for bikes',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: kGreyColor,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kSecondaryColor,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 3),
                  blurRadius: 5,
                  color: kTertiaryColor.withOpacity(0.1),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                Assets.imagesFilter,
                height: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
