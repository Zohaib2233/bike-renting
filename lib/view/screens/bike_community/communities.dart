import 'package:bike_gps/constants/app_images.dart';
import 'package:bike_gps/controllers/community/community_controller.dart';
import 'package:bike_gps/controllers/community/community_detail_controller.dart';
import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/core/constants/instances_constants.dart';

import 'package:bike_gps/core/utils/formatters/date_fromatter.dart';
import 'package:bike_gps/models/post_model/post_comment_model.dart';
import 'package:bike_gps/models/post_model/post_model.dart';
import 'package:bike_gps/models/user_models/user_model.dart';
import 'package:bike_gps/view/screens/bike_community/create_post.dart';
import 'package:bike_gps/view/widget/comment_field.dart';
import 'package:bike_gps/view/widget/common_image_view_widget.dart';
import 'package:bike_gps/view/widget/dialogs/post_report_dialog.dart';
import 'package:bike_gps/view/widget/my_button_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:bike_gps/view/widget/simple_app_bar_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/community_model/community_model.dart';

// ignore: must_be_immutable
class Communities extends StatefulWidget {
  CommunityModel communityModel;
  List reportedPostsIds;
  Communities({
    super.key,
    required this.communityModel,
    required this.reportedPostsIds,
  });

  @override
  State<Communities> createState() => _CommunitiesState();
}

class _CommunitiesState extends State<Communities> {
  //finding CommunityController
  CommunityController communityController = Get.find<CommunityController>();

  //finding CommunityDetailController
  CommunityDetailController communityDetailController =
      Get.find<CommunityDetailController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //getting community posts
    communityDetailController.initFunction(
      reportedPostsIds: widget.reportedPostsIds,
      communityId: widget.communityModel.docId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        leadingIcon: Assets.imagesArrowBack,
        title: 'Communities',
        // actions: [
        //   Center(
        //     child: Image.asset(
        //       Assets.imagesSearch,
        //       height: 22,
        //     ),
        //   ),
        //   SizedBox(
        //     width: 12,
        //   ),
        //   Center(
        //     child: Image.asset(
        //       Assets.imagesNotificationNew,
        //       height: 24,
        //     ),
        //   ),
        //   SizedBox(
        //     width: 20,
        //   ),
        // ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView(
            shrinkWrap: true,
            padding: AppSizes.DEFAULT,
            physics: BouncingScrollPhysics(),
            children: [
              // ElevatedButton(
              //     onPressed: () async {
              //       // await communityDetailController.uploadPostsInBulk();
              //     },
              //     child: null),
              // Row(
              //   children: [
              //     SizedBox(
              //       width: 170,
              //       child: _CustomDropDown(
              //         hint: 'Mars Community',
              //         items: [
              //           'Mars Community',
              //           'Leave Community',
              //         ],
              //         selectedValue: 'Mars Community',
              //         onChanged: (v) {},
              //       ),
              //     ),
              //   ],
              // ),
              Obx(() => ListView.builder(
                    shrinkWrap: true,
                    padding: AppSizes.VERTICAL,
                    physics: BouncingScrollPhysics(),
                    itemCount: communityDetailController.communityPosts.length,
                    itemBuilder: (context, index) {
                      //getting PostModel
                      PostModel postModel =
                          communityDetailController.communityPosts[index];

                      return GetBuilder<CommunityDetailController>(
                          builder: (ctrlr) {
                        return _PostWidget(
                          postModel: PostModel(
                            docId: postModel.docId,
                            caption: postModel.caption,
                            postedByUser: postModel.postedByUser,
                            createAt: postModel.createAt,
                            postImages: postModel.postImages,
                            communityId: postModel.communityId,
                            likes: postModel.likes,
                            comments: postModel.comments,
                          ),
                          isLiked: postModel.likes
                              .contains(userModelGlobal.value.userId),
                          isFav: userFavPostModelGlobal.value.favPosts!
                              .contains(postModel.docId),
                          onFavTap: () async {
                            //checking if the user is adding/removing the post from his favorites
                            bool isFav = !userFavPostModelGlobal.value.favPosts!
                                .contains(postModel.docId);

                            //adding or removing the post from user favorites
                            await communityDetailController.addRemovePostToFav(
                              postId: postModel.docId,
                              isFav: isFav,
                            );
                          },
                          onLikeTap: () async {
                            //checking if the user is liking/unliking the post
                            bool isLike = !postModel.likes
                                .contains(userModelGlobal.value.userId);

                            //liking the post
                            await communityDetailController.likeUnlikePost(
                              postId: postModel.docId,
                              isLike: isLike,
                            );
                          },
                          onCommentTap: () async {
                            //disposing the comments stream (if there is any)
                            await communityDetailController
                                .disposePostCommentsStream();

                            //getting post comments stream
                            communityDetailController.getPostComments(
                                postId: postModel.docId);

                            //opening comments bottom sheet
                            _openCommentsBottomSheet(
                              context: context,
                              onSendComment: () async {
                                await communityDetailController
                                    .uploadCommentOnPost(
                                        postId: postModel.docId,
                                        context: context);
                              },
                              onCloseTap: () async {
                                //disposing the comments stream (if there is any)
                                await communityDetailController
                                    .disposePostCommentsStream();

                                communityDetailController.commentFocusNode
                                    .unfocus();

                                //closing comments bottom sheet
                                Navigator.pop(context);
                              },
                              commentController:
                                  communityDetailController.commentCtrlr,
                              commentFocusNode:
                                  communityDetailController.commentFocusNode,
                            );
                          },
                          index: index,
                        );
                      });

                      // return GetBuilder<CommunityDetailController>(
                      //     builder: (ctrlr) {

                      // });
                    },
                  ))
            ],
          ),
          // Padding(
          //   padding: AppSizes.DEFAULT,
          //   child: GetBuilder<CommunityController>(builder: (ctrlr) {
          //     return MyButton(
          //       radius: 50.0,
          //       buttonText: widget.communityModel.members
          //               .contains(userModelGlobal.value.userId!)
          //           ? '+ Create Post'
          //           : 'Join Community',
          //       onTap: () async {
          //         if (widget.communityModel.members
          //             .contains(userModelGlobal.value.userId!)) {
          //           Get.to(() => CreatePost(
          //                 communityModel: widget.communityModel,
          //               ));
          //         } else {
          //           bool isJoined = await communityController.joinCommunity(
          //               communityId: widget.communityModel.docId,
          //               communityName: widget.communityModel.name);

          //           if (isJoined) {
          //             widget.communityModel.members
          //                 .add(userModelGlobal.value.userId);

          //             ctrlr.update();
          //           }
          //         }
          //       },
          //     );
          //   }),
          // ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: AppSizes.DEFAULT,
        child: GetBuilder<CommunityController>(builder: (ctrlr) {
          return MyButton(
            radius: 50.0,
            buttonText: widget.communityModel.members
                    .contains(userModelGlobal.value.userId!)
                ? '+ Create Post'
                : 'Join Community',
            onTap: () async {
              if (widget.communityModel.members
                  .contains(userModelGlobal.value.userId!)) {
                Get.to(() => CreatePost(
                      communityModel: widget.communityModel,
                    ));
              } else {
                bool isJoined = await communityController.joinCommunity(
                  communityModel: widget.communityModel,
                );

                if (isJoined) {
                  widget.communityModel.members
                      .add(userModelGlobal.value.userId);

                  ctrlr.update();
                }
              }
            },
          );
        }),
      ),
    );
  }
}

//post widget
// ignore: must_be_immutable
class _PostWidget extends StatelessWidget {
  _PostWidget({
    super.key,
    required this.postModel,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.isLiked,
    required this.onFavTap,
    required this.isFav,
    required this.index,
  });

  final PostModel postModel;

  final VoidCallback onLikeTap, onCommentTap, onFavTap;

  final bool isLiked, isFav;
  final int index;

  //finding CommunityDetailController
  CommunityDetailController communityDetailController =
      Get.find<CommunityDetailController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FutureBuilder<UserModel>(
            future: communityDetailController.getUploaderModel(
                uploaderId: postModel.postedByUser),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                //if we got an error
                if (snapshot.hasError) {
                  // showSnackbar(title: 'Error', msg: 'Try again');
                }
                //if we got the data
                else if (snapshot.hasData) {
                  //getting snapshot data
                  UserModel commentatorModel = snapshot.data!;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonImageView(
                        height: 50,
                        width: 50,
                        radius: 100.0,
                        url: commentatorModel.profilePic,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            MyText(
                              text: commentatorModel.fullName!,
                              size: 16,
                            ),
                            MyText(
                              text: '@${commentatorModel.userName}',
                              size: 14,
                              color: Color(0xff979797),
                            ),
                          ],
                        ),
                      ),
                      MyText(
                        text: DateFormatters.instance
                            .getTimeAgo(date: postModel.createAt),
                        size: 14,
                        color: Color(0xff979797),
                      ),
                      ReportPostBtn(onSelected: (val) {
                        if (val == "postReport") {
                          //showing post report dialog
                          Get.dialog(ReportDialog(
                            onReportTap: () {
                              if (communityDetailController
                                  .reportFormKey.currentState!
                                  .validate()) {
                                //popping report dialog
                                Get.back();
                                communityDetailController.reportPost(
                                  postId: postModel.docId,
                                  index: index,
                                );
                              }
                            },
                            title: 'Why are you reporting this post?',
                            reasonCtrlr: communityDetailController.reasonCtrlr,
                            reportFormKey:
                                communityDetailController.reportFormKey,
                          ));
                          // communityDetailController.reportPost(
                          //   postId: postId,
                          //   reportReason: reportReason,
                          // );
                        }
                      })
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
        MyText(
          paddingTop: 12,
          text: postModel.caption,
          size: 14,
          color: Color(0xff979797),
          paddingBottom: 12,
        ),
        SizedBox(
          height: 220,
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(
                width: 10,
              );
            },
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: postModel.postImages.length,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return CommonImageView(
                height: 206,
                radius: 12,
                url: postModel.postImages[index],
              );
            },
          ),
        ),
        // Row(
        //   children: [
        //     Expanded(
        //       flex: 4,
        //       child: CommonImageView(
        //         height: 206,
        //         radius: 12,
        //         url: dummyImg,
        //       ),
        //     ),
        //     SizedBox(
        //       width: 8,
        //     ),
        //     Expanded(
        //       flex: 6,
        //       child: CommonImageView(
        //         height: 206,
        //         radius: 12,
        //         url: dummyImg,
        //       ),
        //     ),
        //   ],
        // ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  GestureDetector(
                    onTap: onLikeTap,
                    child: Image.asset(
                      isLiked
                          ? Assets.imagesHeartFilled
                          : Assets.imagesHeartOutlineBlack,
                      height: 24,
                    ),
                  ),
                  MyText(
                    paddingLeft: 5,
                    paddingRight: 5,
                    text: postModel.likes.length.toString(),
                    size: 13,
                    color: Color(0xff8A96A3),
                    weight: FontWeight.w500,
                  ),
                ],
              ),
              SizedBox(
                width: 13,
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  GestureDetector(
                    onTap: onCommentTap,
                    child: Image.asset(
                      Assets.imagesComment,
                      height: 24,
                    ),
                  ),
                  MyText(
                    paddingLeft: 5,
                    paddingRight: 5,
                    text: postModel.comments.toString(),
                    size: 13,
                    color: Color(0xff8A96A3),
                    weight: FontWeight.w500,
                  ),
                ],
              ),
              SizedBox(
                width: 13,
              ),
              // Wrap(
              //   crossAxisAlignment: WrapCrossAlignment.center,
              //   children: [
              //     GestureDetector(
              //       onTap: () {},
              //       child: Image.asset(
              //         Assets.imagesShare,
              //         height: 20,
              //       ),
              //     ),
              //     MyText(
              //       paddingLeft: 5,
              //       paddingRight: 5,
              //       text: '3K',
              //       size: 13,
              //       color: Color(0xff8A96A3),
              //       weight: FontWeight.w500,
              //     ),
              //   ],
              // ),
              Spacer(),
              GestureDetector(
                onTap: onFavTap,
                child: Image.asset(
                  isFav
                      ? Assets.imagesBookMarkFilled
                      : Assets.imagesBookMarkUnfilled,
                  height: 24,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 16),
          height: 1,
          color: Color(0xffF0F0F0),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class _CustomDropDown extends StatelessWidget {
  _CustomDropDown({
    required this.hint,
    required this.items,
    this.selectedValue,
    required this.onChanged,
  });

  final List<dynamic>? items;
  String? selectedValue;
  final ValueChanged<dynamic>? onChanged;
  String hint;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        items: items!
            .map(
              (item) => DropdownMenuItem<dynamic>(
                value: item,
                child: MyText(
                  text: item,
                  size: 14,
                  color:
                      item == 'Leave Community' ? Colors.red : kTertiaryColor,
                  weight: FontWeight.w500,
                ),
              ),
            )
            .toList(),
        value: selectedValue,
        onChanged: onChanged,
        iconStyleData: IconStyleData(
          icon: Image.asset(
            Assets.imagesArrowRightIosBlack,
            height: 14,
          ),
        ),
        isDense: true,
        isExpanded: false,
        customButton: Container(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(
                text: selectedValue!,
                size: 16,
                weight: FontWeight.w500,
                color: kTertiaryColor,
              ),
              RotatedBox(
                quarterTurns: 1,
                child: Image.asset(
                  Assets.imagesArrowRightIosBlack,
                  height: 14,
                ),
              ),
            ],
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 48,
        ),
        dropdownStyleData: DropdownStyleData(
          elevation: 3,
          maxHeight: 300,
          offset: Offset(0, -0),
          decoration: BoxDecoration(
            border: Border.all(
              color: kTertiaryColor.withOpacity(0.06),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(2),
            color: kPrimaryColor,
          ),
        ),
      ),
    );
  }
}

//method to open modal bottom sheet for selecting profile pic
void _openCommentsBottomSheet({
  required BuildContext context,
  required VoidCallback onSendComment,
  required VoidCallback onCloseTap,
  required TextEditingController commentController,
  required FocusNode commentFocusNode,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    elevation: 0,
    builder: (_) {
      return Padding(
        padding: MediaQuery.of(context).systemGestureInsets,
        child: _CommentsBottomSheet(
          commentController: commentController,
          onSendComment: onSendComment,
          onCloseTap: onCloseTap,
          commentFocusNode: commentFocusNode,
        ),
      );
    },
  );
}

//comments bottom sheet
// ignore: must_be_immutable
class _CommentsBottomSheet extends StatelessWidget {
  _CommentsBottomSheet({
    super.key,
    required this.commentController,
    required this.onSendComment,
    required this.onCloseTap,
    required this.commentFocusNode,
  });

  final TextEditingController commentController;
  final VoidCallback onSendComment, onCloseTap;
  final FocusNode commentFocusNode;

  //finding CommunityDetailController
  CommunityDetailController communityDetailController =
      Get.find<CommunityDetailController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 215,
      child: Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                // const SizedBox(
                //   height: 10,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(text: ""),
                    Image.asset(
                      Assets.imagesBottomSheetHandle,
                      color: kSecondaryColor,
                      height: 5,
                    ),
                    IconButton(
                      onPressed: onCloseTap,
                      icon: Icon(Icons.close),
                      color: kSecondaryColor,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(() => ListView.builder(
                        itemCount:
                            communityDetailController.postComments.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          //getting PostCommentModel
                          PostCommentModel postCommentModel =
                              communityDetailController.postComments[index];

                          return _CommentCard(
                            commentatorId: postCommentModel.commentatorId!,
                            comment: postCommentModel.comment!,
                            commentedOn: postCommentModel.commentedOn!,
                          );
                        })),
                  ),
                ),
                //comment field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: CommentField(
                    focusnode: commentFocusNode,
                    controller: commentController,
                    onSendComment: onSendComment,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

//comment card widget
// ignore: must_be_immutable
class _CommentCard extends StatelessWidget {
  _CommentCard({
    super.key,
    required this.commentatorId,
    required this.comment,
    required this.commentedOn,
  });

  final String commentatorId, comment;
  final DateTime commentedOn;

  //finding CommunityDetailController
  CommunityDetailController communityDetailController =
      Get.find<CommunityDetailController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: kSecondaryColor.withOpacity(0.15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FutureBuilder<UserModel>(
              future: communityDetailController.getUploaderModel(
                  uploaderId: commentatorId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  //if we got an error
                  if (snapshot.hasError) {
                    // showSnackbar(title: 'Error', msg: 'Try again');
                  }
                  //if we got the data
                  else if (snapshot.hasData) {
                    //getting snapshot data
                    UserModel commentatorModel = snapshot.data!;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonImageView(
                          height: 52,
                          width: 52,
                          radius: 100.0,
                          url: commentatorModel.profilePic,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              MyText(
                                text: commentatorModel.fullName!,
                                size: 14,
                                weight: FontWeight.w500,
                              ),
                              MyText(
                                text: commentatorModel.bikeName!,
                                size: 10,
                                weight: FontWeight.w500,
                                color: kGreyColor8,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        MyText(
                          text: DateFormatters.instance
                              .getTimeAgo(date: commentedOn),
                          size: 10,
                          color: kGreyColor8,
                          weight: FontWeight.w500,
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
          SizedBox(
            height: 20,
          ),
          //comment text
          MyText(
            text: comment,
            size: 10,
            weight: FontWeight.w500,
            color: kGreyColor8,
          )
        ],
      ),
    );
  }
}

//post report button
// ignore: must_be_immutable
class ReportPostBtn extends StatelessWidget {
  ReportPostBtn({
    super.key,
    required this.onSelected,
  });

  Function(String)? onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      itemBuilder: (BuildContext context) {
        return [
          // PopupMenuItem<String>(
          //   value: 'userReport',
          //   child: Text('Report User'),
          // ),
          PopupMenuItem<String>(
            value: 'postReport',
            child: Text('Report Post'),
          ),
        ];
      },
    );
  }
}
