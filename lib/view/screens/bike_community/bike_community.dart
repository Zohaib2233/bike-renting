import 'package:bike_gps/constants/app_images.dart';
import 'package:bike_gps/controllers/community/community_controller.dart';
import 'package:bike_gps/core/bindings/bindings.dart';
import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_fonts.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/core/constants/instances_constants.dart';
import 'package:bike_gps/models/post_model/post_model.dart';
import 'package:bike_gps/view/screens/bike_community/communities.dart';
import 'package:bike_gps/view/screens/bike_community/create_new_community.dart';
import 'package:bike_gps/view/screens/friends/friends.dart';
import 'package:bike_gps/view/widget/common_image_view_widget.dart';
import 'package:bike_gps/view/widget/my_button_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BikeCommunity extends StatefulWidget {
  BikeCommunity({super.key});

  @override
  State<BikeCommunity> createState() => _BikeCommunityState();
}

class _BikeCommunityState extends State<BikeCommunity> {
  List<String> _items = [
    'Favorites',
    'Cafes',
    'Bars',
    'Cafes',
    'Bars',
  ];
  List<String> _tabs = [
    'All Communities',
    'Joined Communities',
    'My Communities',
  ];

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   Get.dialog(
    //     _DiscoverPopup(),
    //   );
    // });
    // Timer(
    //   Duration(seconds: 4),
    //   () {
    //     Get.dialog(
    //       DiscoverPopup(),
    //     );
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
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
                centerTitle: true,
                floating: true,
                expandedHeight: 160,
                title: MyText(
                  text: 'Bike Community',
                  size: 18,
                  color: kTextColor4,
                  weight: FontWeight.w700,
                  fontFamily: AppFonts.NUNITO_SANS,
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _Search(),
                      SizedBox(
                        height: 58,
                      ),
                    ],
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size(0, 55),
                  child: Container(
                    color: kPrimaryColor,
                    child: TabBar(
                      labelColor: kBlackColor,
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
                      tabs: _tabs.map((e) => Tab(child: Text(e))).toList(),
                      indicatorColor: kBlueColor,
                      indicatorWeight: 2,
                      isScrollable: true,
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              _AllCommunities(),
              _JoinedCommunities(),
              _MyCommunities(),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class _AllCommunities extends StatelessWidget {
  _AllCommunities({
    super.key,
  });
  CommunityController communityController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemCount: communityController.allCommunities.length,
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          var data = communityController.allCommunities[index];
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
                GestureDetector(
                  onTap: () {
                    Get.to(
                      () => Communities(
                        communityModel: data,
                        reportedPostsIds: communityController.reportedPostsIds,
                      ),
                      binding: CommunityDetailBinding(),
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonImageView(
                        height: 52,
                        width: 52,
                        radius: 100.0,
                        url: data.picture,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            MyText(
                              text: '${data.name}',
                              size: 14,
                              weight: FontWeight.w500,
                            ),
                            MyText(
                              text: '${data.address}',
                              size: 10,
                              weight: FontWeight.w500,
                              color: kGreyColor8,
                            ),
                            // MyText(
                            //   text: '34m ago',
                            //   size: 10,
                            //   color: kGreyColor8,
                            //   weight: FontWeight.w500,
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Obx(
                        () => data.createdByUser == userModelGlobal.value.userId
                            ? SizedBox.shrink()
                            : GetBuilder<CommunityController>(
                                init: CommunityController(),
                                builder: (ctrlr) {
                                  return GestureDetector(
                                    onTap: () async {
                                      if (data.members.contains(
                                          userModelGlobal.value.userId)) {
                                        var response = await communityController
                                            .leaveCommunity(
                                          communityModel: data,
                                        );
                                        if (response) {
                                          data.members.remove(
                                              userModelGlobal.value.userId);
                                        } else {}
                                      } else {
                                        if (!data.members.contains(
                                            userModelGlobal.value.userId)) {
                                          var response =
                                              await communityController
                                                  .joinCommunity(
                                            communityModel: data,
                                          );
                                          if (response) {
                                            data.members.add(
                                                userModelGlobal.value.userId);
                                          } else {}
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: 32,
                                      width: 62,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: data.members.contains(
                                                userModelGlobal.value.userId)
                                            ? kRedColor
                                            : kBlueColor,
                                      ),
                                      child: Center(
                                        child: MyText(
                                          text: data.members.contains(
                                                  userModelGlobal.value.userId)
                                              ? 'Leave'
                                              : 'Join',
                                          size: 14,
                                          weight: FontWeight.w500,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                //community post preview
                FutureBuilder<List<PostModel>>(
                    future: communityController.getCommunityRecentPosts(
                        communityId: data.docId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        //if we got an error
                        if (snapshot.hasError) {
                          // showSnackbar(title: 'Error', msg: 'Try again');
                        }
                        //if we got the data
                        else if (snapshot.hasData) {
                          //getting snapshot data
                          List<PostModel> recentPosts = snapshot.data!;
                          return Visibility(
                            visible: recentPosts.isNotEmpty,
                            child: SizedBox(
                              height: 220,
                              child: ListView.separated(
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: 10,
                                  );
                                },
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: recentPosts.length,
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  //getting recent post model
                                  PostModel recentPostModel =
                                      recentPosts[index];

                                  return recentPostModel.postImages.isNotEmpty
                                      ? CommonImageView(
                                          height: Get.height,
                                          width: 120,
                                          radius: 12,
                                          url: recentPostModel.postImages[0],
                                        )
                                      : MyText(text: recentPostModel.caption);
                                },
                              ),
                            ),
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
              ],
            ),
          );
        },
      ),
    );
  }
}

class _JoinedCommunities extends StatelessWidget {
  _JoinedCommunities({
    super.key,
  });
  CommunityController communityController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemCount: communityController.joinedCommunities.length,
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          var data = communityController.joinedCommunities[index];
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
                GestureDetector(
                  onTap: () {
                    Get.to(
                      () => Communities(
                        communityModel: data,
                        reportedPostsIds: communityController.reportedPostsIds,
                      ),
                      binding: CommunityDetailBinding(),
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonImageView(
                        height: 52,
                        width: 52,
                        radius: 100.0,
                        url: data.picture,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            MyText(
                              text: '${data.name}',
                              size: 14,
                              weight: FontWeight.w500,
                            ),
                            MyText(
                              text: '${data.address}',
                              size: 10,
                              weight: FontWeight.w500,
                              color: kGreyColor8,
                            ),
                            // MyText(
                            //   text: '34m ago',
                            //   size: 10,
                            //   color: kGreyColor8,
                            //   weight: FontWeight.w500,
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Obx(
                        () => data.createdByUser == userModelGlobal.value.userId
                            ? SizedBox.shrink()
                            : GetBuilder<CommunityController>(
                                init: CommunityController(),
                                builder: (ctrlr) {
                                  return GestureDetector(
                                    onTap: () async {
                                      if (data.members.contains(
                                          userModelGlobal.value.userId)) {
                                        var response = await communityController
                                            .leaveCommunity(
                                          communityModel: data,
                                        );
                                        if (response) {
                                          data.members.remove(
                                              userModelGlobal.value.userId);
                                        } else {}
                                      } else {
                                        if (!data.members.contains(
                                            userModelGlobal.value.userId)) {
                                          var response =
                                              await communityController
                                                  .joinCommunity(
                                            communityModel: data,
                                          );
                                          if (response) {
                                            data.members.add(
                                                userModelGlobal.value.userId);
                                          } else {}
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: 32,
                                      width: 62,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: data.members.contains(
                                                userModelGlobal.value.userId)
                                            ? kRedColor
                                            : kBlueColor,
                                      ),
                                      child: Center(
                                        child: MyText(
                                          text: data.members.contains(
                                                  userModelGlobal.value.userId)
                                              ? 'Leave'
                                              : 'Join',
                                          size: 14,
                                          weight: FontWeight.w500,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                //community post preview
                FutureBuilder<List<PostModel>>(
                    future: communityController.getCommunityRecentPosts(
                        communityId: data.docId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        //if we got an error
                        if (snapshot.hasError) {
                          // showSnackbar(title: 'Error', msg: 'Try again');
                        }
                        //if we got the data
                        else if (snapshot.hasData) {
                          //getting snapshot data
                          List<PostModel> recentPosts = snapshot.data!;
                          return Visibility(
                            visible: recentPosts.isNotEmpty,
                            child: SizedBox(
                              height: 220,
                              child: ListView.separated(
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: 10,
                                  );
                                },
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: recentPosts.length,
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  //getting recent post model
                                  PostModel recentPostModel =
                                      recentPosts[index];

                                  return recentPostModel.postImages.isNotEmpty
                                      ? CommonImageView(
                                          height: Get.height,
                                          width: 120,
                                          radius: 12,
                                          url: recentPostModel.postImages[0],
                                        )
                                      : MyText(text: recentPostModel.caption);
                                },
                              ),
                            ),
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
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MyCommunities extends StatelessWidget {
  _MyCommunities({super.key});
  CommunityController communityController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemCount: communityController.myCommunities.length,
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          var data = communityController.myCommunities[index];
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
                GestureDetector(
                  onTap: () {
                    Get.to(
                      () => Communities(
                        communityModel: data,
                        reportedPostsIds: communityController.reportedPostsIds,
                      ),
                      binding: CommunityDetailBinding(),
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonImageView(
                        height: 52,
                        width: 52,
                        radius: 100.0,
                        url: data.picture,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            MyText(
                              text: '${data.name}',
                              size: 14,
                              weight: FontWeight.w500,
                            ),
                            MyText(
                              text: '${data.address}',
                              size: 10,
                              weight: FontWeight.w500,
                              color: kGreyColor8,
                            ),
                            // MyText(
                            //   text: '34m ago',
                            //   size: 10,
                            //   color: kGreyColor8,
                            //   weight: FontWeight.w500,
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Obx(
                        () => data.createdByUser == userModelGlobal.value.userId
                            ? SizedBox.shrink()
                            : GetBuilder<CommunityController>(
                                init: CommunityController(),
                                builder: (ctrlr) {
                                  return GestureDetector(
                                    onTap: () async {
                                      if (data.members.contains(
                                          userModelGlobal.value.userId)) {
                                        var response = await communityController
                                            .leaveCommunity(
                                          communityModel: data,
                                        );
                                        if (response) {
                                          data.members.remove(
                                              userModelGlobal.value.userId);
                                        } else {}
                                      } else {
                                        if (!data.members.contains(
                                            userModelGlobal.value.userId)) {
                                          var response =
                                              await communityController
                                                  .joinCommunity(
                                            communityModel: data,
                                          );
                                          if (response) {
                                            data.members.add(
                                                userModelGlobal.value.userId);
                                          } else {}
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: 32,
                                      width: 62,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: data.members.contains(
                                                userModelGlobal.value.userId)
                                            ? kRedColor
                                            : kBlueColor,
                                      ),
                                      child: Center(
                                        child: MyText(
                                          text: data.members.contains(
                                                  userModelGlobal.value.userId)
                                              ? 'Leave'
                                              : 'Join',
                                          size: 14,
                                          weight: FontWeight.w500,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                //community post preview
                FutureBuilder<List<PostModel>>(
                    future: communityController.getCommunityRecentPosts(
                        communityId: data.docId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        //if we got an error
                        if (snapshot.hasError) {
                          // showSnackbar(title: 'Error', msg: 'Try again');
                        }
                        //if we got the data
                        else if (snapshot.hasData) {
                          //getting snapshot data
                          List<PostModel> recentPosts = snapshot.data!;
                          return Visibility(
                            visible: recentPosts.isNotEmpty,
                            child: SizedBox(
                              height: 220,
                              child: ListView.separated(
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: 10,
                                  );
                                },
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: recentPosts.length,
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  //getting recent post model
                                  PostModel recentPostModel =
                                      recentPosts[index];

                                  return recentPostModel.postImages.isNotEmpty
                                      ? CommonImageView(
                                          height: Get.height,
                                          width: 120,
                                          radius: 12,
                                          url: recentPostModel.postImages[0],
                                        )
                                      : MyText(text: recentPostModel.caption);
                                },
                              ),
                            ),
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
              ],
            ),
          );
        },
      ),
    );
  }
}

class DiscoverPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: AppSizes.DEFAULT,
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(23),
            color: kPrimaryColor,
          ),
          child: Column(
            children: [
              Image.asset(
                Assets.imagesPlacesBaloons,
                height: 85,
              ),
              MyText(
                paddingTop: 13,
                weight: FontWeight.w500,
                text: 'Discover places',
                size: 18,
                textAlign: TextAlign.center,
              ),
              MyText(
                paddingTop: 13,
                weight: FontWeight.w500,
                text:
                    'Discover places that are popular with friends, find your favorites, and see where you’ve been before.',
                size: 14,
                color: kGreyColor8,
                textAlign: TextAlign.center,
                paddingBottom: 30,
              ),
              Center(
                child: SizedBox(
                  width: Get.width,
                  child: MyButton(
                    bgColor: kBlueColor,
                    radius: 50.0,
                    onTap: () {
                      Get.back();
                    },
                    buttonText: 'Let’s go',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
          // GestureDetector(
          //   onTap: () => Get.back(),
          //   child: Image.asset(
          //     Assets.imagesArrowBack,
          //     height: 24,
          //   ),
          // ),
          // SizedBox(
          //   width: 12,
          // ),
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
                readOnly: true,
                // onTap: () => Get.to(() => Friends()),
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  prefixIcon: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Assets.imagesSearch,
                        height: 18,
                      ),
                    ],
                  ),
                  hintText: 'Search for communities',
                  hintStyle: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
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
            width: 8,
          ),
          MyButton(
            height: 40,
            radius: 50,
            btnChildPadding: 8.0,
            bgColor: kBlueColor,
            textSize: 10,
            onTap: () {
              Get.to(() => CreateNewCommunity());
            },
            buttonText: '+ Create Community',
          ),
        ],
      ),
    );
  }
}
