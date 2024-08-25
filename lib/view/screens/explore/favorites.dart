import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/view/screens/explore/product_detail.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:bike_gps/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Favorite',
        actions: [
          Center(
            child: Image.asset(
              Assets.imagesHeart,
              height: 24,
            ),
          ),
          SizedBox(
            width: 16,
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          mainAxisExtent: 200,
        ),
        itemCount: 10,
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Get.to(() => ProductDetail()),
            child: Stack(
              children: [
                Container(
                  height: Get.height,
                  width: Get.width,
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
                        color: Color(0xff0D6EFD),
                      ),
                      MyText(
                        text: 'Bike 01',
                        size: 16,
                        weight: FontWeight.w500,
                        color: kGreyColor,
                        paddingBottom: 4,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: MyText(
                              text: '\$1302.00',
                              size: 14,
                              weight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            height: 16,
                            width: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kRedColor,
                              border: Border.all(
                                width: 2.0,
                                color: Color(0xffF7F7F9),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 16,
                            width: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xff0B2F8B),
                              border: Border.all(
                                width: 2.0,
                                color: Color(0xffF7F7F9),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    height: 28,
                    width: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffF7F7F9),
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: Color(0xffF87265),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
