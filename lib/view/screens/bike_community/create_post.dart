import 'dart:io';

import 'package:bike_gps/constants/app_images.dart';
import 'package:bike_gps/controllers/community/community_controller.dart';
import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/core/constants/instances_constants.dart';
import 'package:bike_gps/core/utils/snackbars.dart';
import 'package:bike_gps/core/utils/uuid/uuid_functions.dart';
import 'package:bike_gps/core/utils/validators.dart';
import 'package:bike_gps/main.dart';
import 'package:bike_gps/models/community_model/community_model.dart';
import 'package:bike_gps/models/post_model/post_model.dart';
import 'package:bike_gps/view/widget/common_image_view_widget.dart';
import 'package:bike_gps/view/widget/my_button_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:bike_gps/view/widget/my_textfield_widget.dart';
import 'package:bike_gps/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class CreatePost extends StatelessWidget {
  CommunityModel communityModel;
  CreatePost({super.key, required this.communityModel});
  CommunityController communityController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        leadingIcon: Assets.imagesMenuNew,
        title: 'Create',
        actions: [
          Center(
            child: Image.asset(
              Assets.imagesNotificationNew,
              height: 24,
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Center(
            child: Image.asset(
              Assets.imagesBookMark,
              height: 24,
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MyText(
                text: 'Create Post',
                size: 16,
                weight: FontWeight.w500,
              ),
              SizedBox(
                width: 70,
                child: MyButton(
                  radius: 8,
                  height: 32,
                  bgColor: Color(0xff157EFE),
                  buttonText: 'Post',
                  onTap: () async {
                    if (communityController.pickedImagesForPost.isNotEmpty) {
                      var docId = UuidFunctions.instance.createUuidV7();
                      PostModel postModel = PostModel(
                          docId: docId,
                          caption: communityController.caption.text,
                          postedByUser: userModelGlobal.value.userId!,
                          createAt: DateTime.now(),
                          postImages: communityController.pickedImagesForPost,
                          communityId: communityModel.docId,
                          likes: [],
                          comments: 0);
                      await communityController.uploadPost(
                          postModel: postModel, context: context);
                    } else {
                      CustomSnackBars.instance.showFailureSnackbar(
                          title: "Select Image",
                          message: "Please select atleast 1 image for post");
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              CommonImageView(
                height: 45,
                width: 45,
                radius: 100.0,
                url: userModelGlobal.value.profilePic!,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: MyText(
                  text: userModelGlobal.value.fullName!,
                  size: 14,
                  weight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              MyTextField(
                radius: 0.0,
                labelText: '',
                controller: communityController.caption,
                hintText: 'What’s on your mind?',
                maxLines: 10,
                marginBottom: 0.0,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        communityController.selectImageFromGalleryForPost();
                      },
                      child: Image.asset(
                        Assets.imagesImg,
                        height: 24,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        communityController.selectImageFromCameraForPost();
                      },
                      child: Image.asset(
                        Assets.imagesCam,
                        height: 24,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: Get.height * 0.3,
            child: GetBuilder<CommunityController>(
              init: CommunityController(),
              builder: (ctrlr) {
                return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: ctrlr.pickedImagesForPost.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Stack(
                          children: [
                            CommonImageView(
                              height: 90,
                              width: 100,
                              fit: BoxFit.fill,
                              file: File(ctrlr.pickedImagesForPost[index].path),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                  onPressed: () {
                                    ctrlr.pickedImagesForPost.removeAt(index);
                                    ctrlr.update();
                                  },
                                  icon: Icon(
                                    Icons.cancel_outlined,
                                    color: kSecondaryColor,
                                    size: 28,
                                  )),
                            ),
                          ],
                        ),
                      );
                    });
              },
            ),
          )
        ],
      ),
    );
  }
}
