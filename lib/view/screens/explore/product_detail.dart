import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/view/screens/explore/favorites.dart';
import 'package:bike_gps/view/screens/explore/my_cart.dart';
import 'package:bike_gps/view/widget/my_button_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:bike_gps/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Bike Shop',
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
                  text: 'Konna Air 270 Essential',
                  size: 26,
                  weight: FontWeight.bold,
                  paddingBottom: 8,
                ),
                MyText(
                  text: 'Men’s Bike',
                  size: 16,
                  weight: FontWeight.w500,
                  color: kGreyColor,
                ),
                MyText(
                  text: '\$179.39',
                  size: 24,
                  weight: FontWeight.w600,
                ),
                Image.asset(
                  Assets.imagesRorate,
                  height: 197,
                  width: Get.width,
                ),
                SizedBox(
                  height: 12,
                ),
                Wrap(
                  spacing: 11,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Transform.flip(
                      flipX: true,
                      child: Image.asset(
                        Assets.imagesBike,
                        height: 78,
                      ),
                    ),
                    Transform.flip(
                      flipX: true,
                      child: Image.asset(
                        Assets.imagesBike,
                        height: 78,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                MyText(
                  text:
                      'The Max Air Founded in Vancouver, BC, the company is still owned by the pair of friends that created the brand in 1988. Kona Bikes is probably best known........,',
                  color: Color(0xff707B81),
                  size: 14,
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.to(() => Favorites()),
                  child: Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffD9D9D9).withOpacity(0.4),
                    ),
                    child: Center(
                      child: Image.asset(
                        Assets.imagesHeart,
                        height: 24,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: MyButton(
                    onTap: () {
                      Get.to(() => MyCart());
                    },
                    buttonText: '',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Assets.imagesBag,
                          height: 24,
                          color: kPrimaryColor,
                        ),
                        MyText(
                          paddingRight: 16,
                          paddingLeft: 16,
                          text: 'Add to Cart',
                          size: 14,
                          weight: FontWeight.w600,
                          color: kPrimaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
