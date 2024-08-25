import 'package:bike_gps/constants/app_images.dart';
import 'package:bike_gps/controllers/profile/user_fav_posts_controller.dart';
import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/core/constants/instances_constants.dart';
import 'package:bike_gps/core/utils/formatters/date_fromatter.dart';
import 'package:bike_gps/models/post_model/post_comment_model.dart';
import 'package:bike_gps/models/post_model/post_model.dart';
import 'package:bike_gps/models/user_models/user_model.dart';
import 'package:bike_gps/view/widget/comment_field.dart';
import 'package:bike_gps/view/widget/common_image_view_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:bike_gps/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class UserFavPosts extends StatelessWidget {
  UserFavPosts({super.key});

  //finding UserFavPostsController
  UserFavPostsController controller = Get.find<UserFavPostsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        leadingIcon: Assets.imagesArrowBack,
        title: 'Your Favorite Posts',
      ),
      body: Obx(() => ListView.builder(
            shrinkWrap: true,
            controller: controller.scrollController,
            padding: AppSizes.DEFAULT,
            physics: BouncingScrollPhysics(),
            itemCount: controller.favPosts.length,
            itemBuilder: (context, index) {
              return GetBuilder<UserFavPostsController>(builder: (ctrlr) {
                //getting PostModel
                PostModel postModel = controller.favPosts[index];

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
                  isLiked:
                      postModel.likes.contains(userModelGlobal.value.userId),
                  isFav: userFavPostModelGlobal.value.favPosts!
                      .contains(postModel.docId),
                  onFavTap: () async {
                    //removing the post from user favorites
                    await ctrlr.removePostFromFav(
                      postModel: postModel,
                    );
                  },
                  onLikeTap: () async {
                    //checking if the user is liking/unliking the post
                    bool isLike =
                        !postModel.likes.contains(userModelGlobal.value.userId);

                    //liking the post
                    bool isSuccess = await ctrlr.likeUnlikePost(
                      postId: postModel.docId,
                      isLike: isLike,
                    );

                    //updating the UI
                    if (isLike && isSuccess) {
                      //adding the userId in likes list
                      postModel.likes.add(userModelGlobal.value.userId);

                      controller.update();
                    } else if (isLike == false && isSuccess) {
                      //removing the userId in likes list
                      postModel.likes.remove(userModelGlobal.value.userId);

                      controller.update();
                    }
                  },
                  onCommentTap: () async {
                    //disposing the comments stream (if there is any)
                    await ctrlr.disposePostCommentsStream();

                    //getting post comments stream
                    ctrlr.getPostComments(postId: postModel.docId);

                    //opening comments bottom sheet
                    _openCommentsBottomSheet(
                      context: context,
                      onSendComment: () async {
                        bool isCommentUploaded =
                            await ctrlr.uploadCommentOnPost(
                                postId: postModel.docId, context: context);

                        //updating the UI
                        if (isCommentUploaded) {
                          postModel.comments += 1;

                          controller.update();
                        }
                      },
                      onCloseTap: () async {
                        //disposing the comments stream (if there is any)
                        await ctrlr.disposePostCommentsStream();

                        ctrlr.commentFocusNode.unfocus();

                        //closing comments bottom sheet
                        Navigator.pop(context);
                      },
                      commentController: ctrlr.commentCtrlr,
                      commentFocusNode: ctrlr.commentFocusNode,
                    );
                  },
                );
              });
            },
          )),
    );
  }
}

//method to open modal bottom sheet for viewing comments
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
  });

  final PostModel postModel;

  final VoidCallback onLikeTap, onCommentTap, onFavTap;

  final bool isLiked, isFav;

  //finding CommunityDetailController
  UserFavPostsController userFavPostsController =
      Get.find<UserFavPostsController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FutureBuilder<UserModel>(
            future: userFavPostsController.getUploaderModel(
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

  //finding UserFavPostsController
  UserFavPostsController userFavPostsController =
      Get.find<UserFavPostsController>();

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
                        itemCount: userFavPostsController.postComments.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          //getting PostCommentModel
                          PostCommentModel postCommentModel =
                              userFavPostsController.postComments[index];

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

  //finding UserFavPostsController
  UserFavPostsController userFavPostsController =
      Get.find<UserFavPostsController>();

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
              future: userFavPostsController.getUploaderModel(
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
