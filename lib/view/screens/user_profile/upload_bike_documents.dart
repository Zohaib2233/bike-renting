import 'dart:io';

import 'package:bike_gps/controllers/auth/signup_controller.dart';

import 'package:bike_gps/core/constants/app_colors.dart';

import 'package:bike_gps/core/constants/app_images.dart';

import 'package:bike_gps/core/constants/app_sizes.dart';

import 'package:bike_gps/core/utils/snackbars.dart';

import 'package:bike_gps/view/widget/headings_widget.dart';

import 'package:bike_gps/view/widget/my_button_widget.dart';

import 'package:bike_gps/view/widget/my_text_widget.dart';

import 'package:bike_gps/view/widget/simple_app_bar_widget.dart';

import 'package:dotted_border/dotted_border.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

// ignore: must_be_immutable
class UploadBikeDocuments extends StatelessWidget {
  UploadBikeDocuments({super.key});

  //finding SignUpController

  SignUpController controller = Get.find<SignUpController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Bike Setup',
        titleColor: kSecondaryColor,
        leadingIcon: Assets.imagesMenu,
        leadingIconSize: 12,
        onLeadingTap: () {},
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              children: [
                AuthHeading(
                  title: 'Bike Information',
                  subTitle: 'Upload pictures of the bike',
                  textAlign: TextAlign.start,
                  paddingTop: 0,
                  paddingBottom: 17,
                ),

                _UploadCard(
                  label: 'Pictures of your bike',
                  title: 'Upload your image here,',
                  onTap: () {
                    controller.openImgPickerBottomSheet(
                        context: context, isBikeDocTap: true);
                  },
                ),

                //selected bike pics list

                Obx(() => Visibility(
                      visible: controller.pickedBikeImages.isNotEmpty,
                      child: SizedBox(
                        height: 80,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.pickedBikeImages.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Stack(
                                  children: [
                                    Image.file(
                                        File(controller
                                            .pickedBikeImages[index].path),
                                        fit: BoxFit.fill,
                                        height: 80,
                                        width: 80),
                                    Positioned(
                                      right: 5,
                                      top: 5,
                                      child: Wrap(
                                        spacing: 10,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              controller.pickedBikeImages
                                                  .removeAt(index);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: ShapeDecoration(
                                                  color: Colors.grey.shade300,
                                                  shape: CircleBorder()),
                                              child: const Icon(Icons.close,
                                                  color: Colors.black,
                                                  size: 15),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ));
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(width: 10),
                        ),
                      ),
                    )),

                const SizedBox(
                  height: 10,
                ),

                _UploadCard(
                  label: 'Any other documents',
                  title: 'Upload your doc here, or',
                  onTap: () {
                    controller.openImgPickerBottomSheet(
                        context: context, isBikeDocTap: false);
                  },
                ),

                //other docs pics list

                Obx(() => Visibility(
                      visible: controller.otherDocsImages.isNotEmpty,
                      child: SizedBox(
                        height: 80,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.otherDocsImages.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Stack(
                                  children: [
                                    Image.file(
                                        File(controller
                                            .otherDocsImages[index].path),
                                        fit: BoxFit.fill,
                                        height: 80,
                                        width: 80),
                                    Positioned(
                                      right: 5,
                                      top: 5,
                                      child: Wrap(
                                        spacing: 10,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              controller.otherDocsImages
                                                  .removeAt(index);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: ShapeDecoration(
                                                  color: Colors.grey.shade300,
                                                  shape: CircleBorder()),
                                              child: const Icon(Icons.close,
                                                  color: Colors.black,
                                                  size: 15),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ));
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(width: 10),
                        ),
                      ),
                    )),
              ],
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: MyButton(
              buttonText: 'Next',
              onTap: () {
                if (controller.pickedBikeImages.isNotEmpty &&
                    controller.otherDocsImages.length >= 2) {
                  controller.uploadUserAdditionalInfo(context: context);
                } else if (controller.pickedBikeImages.isEmpty) {
                  CustomSnackBars.instance.showFailureSnackbar(
                      title: "Select Bike Images",
                      message: "Please select bike images");
                } else if (controller.otherDocsImages.length < 2) {
                  CustomSnackBars.instance.showFailureSnackbar(
                      title: "Upload Complete Documents",
                      message:
                          "Please upload the front and backside of the documents");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadCard extends StatelessWidget {
  final String label, title;

  final VoidCallback onTap;

  const _UploadCard({
    required this.label,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyText(
            text: label,
            size: 12,
            color: kDarkGreyColor,
            weight: FontWeight.w500,
            paddingBottom: 3,
          ),
          GestureDetector(
            onTap: onTap,
            child: SizedBox(
              height: 102,
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(8),
                color: kBorderColor2,
                strokeWidth: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      Assets.imagesUploadFile,
                      height: 26,
                    ),
                    SizedBox(
                      height: 17,
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
                        MyText(
                          text: title,
                          size: 12,
                          color: kBlackColor,
                        ),
                        MyText(
                          text: ' browse',
                          size: 12,
                          color: kSecondaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
