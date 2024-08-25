import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/view/screens/explore/check_out.dart';
import 'package:bike_gps/view/widget/my_button_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:bike_gps/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class MyCart extends StatelessWidget {
  const MyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          MyText(
            text: '3 Item',
            size: 16,
            weight: FontWeight.w500,
            paddingLeft: 16,
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 4,
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Slidable(
                  endActionPane: ActionPane(
                    extentRatio: 0.19,
                    motion: ScrollMotion(),
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 12),
                        height: Get.height,
                        width: 58,
                        decoration: BoxDecoration(
                          color: kRedColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            splashColor: kGreyColor.withOpacity(0.05),
                            highlightColor: kGreyColor.withOpacity(0.05),
                            onTap: () {},
                            child: Center(
                              child: Image.asset(
                                Assets.imagesDelete,
                                height: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  startActionPane: ActionPane(
                    extentRatio: 0.19,
                    motion: ScrollMotion(),
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 12),
                        height: Get.height,
                        width: 58,
                        decoration: BoxDecoration(
                          color: kSecondaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Icon(
                                Icons.add,
                                color: kPrimaryColor,
                              ),
                            ),
                            MyText(
                              paddingTop: 4,
                              text: '1',
                              size: 14,
                              color: kPrimaryColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Icon(
                                Icons.remove,
                                color: kPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: 12,
                    ),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: kPrimaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: kQuaternaryColor.withOpacity(0.04),
                          offset: Offset(0, 2),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 85,
                          width: 87,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: kSeoulColor,
                          ),
                          child: Center(
                            child: Transform.flip(
                              flipX: true,
                              child: Image.asset(
                                Assets.imagesBike,
                                height: 50,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              MyText(
                                text: 'More',
                                size: 16,
                                weight: FontWeight.w500,
                              ),
                              MyText(
                                text: '\$94.05',
                                size: 14,
                                weight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
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
                Get.to(() => Checkout());
              },
              buttonText: 'Checkout',
            ),
          ),
        ],
      ),
    );
  }
}

class TotalAndSubTotal extends StatelessWidget {
  const TotalAndSubTotal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: 'Subtotal',
              size: 16,
              weight: FontWeight.w500,
              color: Color(0xfff707B81),
            ),
            MyText(
              text: '\$760.20',
              size: 16,
              weight: FontWeight.w500,
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: 'Delivery',
              size: 16,
              weight: FontWeight.w500,
              color: Color(0xfff707B81),
            ),
            MyText(
              text: '\$60.20',
              size: 16,
              weight: FontWeight.w500,
            ),
          ],
        ),
        Padding(
          padding: AppSizes.VERTICAL,
          child: Image.asset(
            Assets.imagesDottedBorder,
            height: 2,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: 'Total Cost',
              size: 16,
              weight: FontWeight.w500,
            ),
            MyText(
              text: '\$814.15',
              size: 16,
              color: kSecondaryColor,
              weight: FontWeight.w500,
            ),
          ],
        ),
      ],
    );
  }
}
