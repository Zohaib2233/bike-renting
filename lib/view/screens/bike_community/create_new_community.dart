import 'dart:io';

import 'package:bike_gps/constants/app_images.dart';
import 'package:bike_gps/controllers/community/community_controller.dart';
import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/core/constants/instances_constants.dart';
import 'package:bike_gps/core/utils/snackbars.dart';
import 'package:bike_gps/core/utils/validators.dart';
import 'package:bike_gps/main.dart';
import 'package:bike_gps/models/community_model/community_model.dart';
import 'package:bike_gps/view/widget/common_image_view_widget.dart';
import 'package:bike_gps/view/widget/custom_drop_down_widget.dart';
import 'package:bike_gps/view/widget/my_button_widget.dart';
import 'package:bike_gps/view/widget/my_textfield_widget.dart';
import 'package:bike_gps/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/uuid/uuid_functions.dart';

class CreateNewCommunity extends StatelessWidget {
  CreateNewCommunity({super.key});
  CommunityController communityController = Get.find();
  final key1 = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: key1,
      child: Scaffold(
        appBar: simpleAppBar(
          title: 'Create Community',
          actions: [
            Center(
              child: SizedBox(
                width: 60,
                child: MyButton(
                  height: 34,
                  textSize: 10,
                  radius: 6,
                  onTap: () async {
                    if (key1.currentState!.validate() &&
                        communityController.communityImage != null) {
                      var docId = UuidFunctions.instance.createUuidV7();
                      CommunityModel communityModel = CommunityModel(
                          name: communityController.communityName.text,
                          docId: docId,
                          address: communityController.communityAddress.text,
                          picture: communityController.communityImage!.path,
                          createdAt: DateTime.now(),
                          members: [userModelGlobal.value.userId],
                          createdByUser: userModelGlobal.value.userId!);
                      await communityController.createCommunity(
                          communityModel: communityModel, context: context);
                    } else if (communityController.communityImage == null) {
                      CustomSnackBars.instance.showFailureSnackbar(
                          title: 'Error',
                          message: 'Please select a community image');
                    }
                  },
                  bgColor: kBlueColor,
                  buttonText: 'Create',
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        body: ListView(
          padding: AppSizes.DEFAULT,
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            Center(
              child: Stack(
                children: [
                  GetBuilder<CommunityController>(
                      init: CommunityController(),
                      builder: (ctrlr) {
                        return ctrlr.communityImage == null
                            ? CommonImageView(
                                height: 110,
                                width: 110,
                                radius: 100.0,
                                url: dummyImg,
                              )
                            : CommonImageView(
                                height: 110,
                                width: 110,
                                radius: 100.0,
                                file: File(ctrlr.communityImage!.path),
                              );
                      }),
                  GestureDetector(
                    onTap: () async {
                      communityController.openImgPickerBottomSheet(
                        context: context,
                      );
                    },
                    child: CommonImageView(
                      height: 110,
                      width: 110,
                      radius: 100.0,
                      imagePath: Assets.imagesEditEffect,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            MyTextField(
              labelText: 'Community name',
              hintText: '',
              validator: ValidationService.instance.emptyValidator,
              controller: communityController.communityName,
            ),
            MyTextField(
              labelText: 'Address',
              hintText: '',
              validator: ValidationService.instance.emptyValidator,
              controller: communityController.communityAddress,
            ),
            // CustomDropDown(
            //   hint: 'hint',
            //   items: [
            //     'Public',
            //     'Private',
            //   ],
            //   heading: 'Privacy',
            //   selectedValue: 'Public',
            //   onChanged: (v) {},
            // ),
          ],
        ),
      ),
    );
  }
}
