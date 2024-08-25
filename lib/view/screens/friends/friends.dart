import 'package:bike_gps/constants/app_images.dart';
import 'package:bike_gps/controllers/friends_controller/friends_controller.dart';
import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';

import 'package:bike_gps/models/user_models/user_model.dart';
import 'package:bike_gps/view/widget/common_image_view_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:bike_gps/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class Friends extends StatefulWidget {
  Friends({super.key});

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  int _currentIndex = 0;
  FriendsController friendsController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Friends',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 40,
            child: ListView.builder(
              itemCount: 3,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 15),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  child: Container(
                    height: Get.height,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color:
                          _currentIndex == index ? kSecondaryColor : kBlueColor,
                    ),
                    child: Center(
                      child: MyText(
                        text: index == 0
                            ? 'Suggestions'
                            : index == 1
                                ? 'Your friends'
                                : 'Requests',
                        size: 12,
                        weight: FontWeight.w500,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: AppSizes.HORIZONTAL,
              physics: BouncingScrollPhysics(),
              children: [
                _Search(
                  onChanged: (val) {
                    if (val.length >= 4) {
                      friendsController.searchUsernames(partialUsername: val);
                    } else if (val.isEmpty) {
                      //clearing the found users list
                      friendsController.foundUsers.value = [];
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                //searched users list
                Obx(() => ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: BouncingScrollPhysics(),
                    itemCount: friendsController.foundUsers.length,
                    itemBuilder: (context, index) {
                      //getting UserModel
                      UserModel foundUser = friendsController.foundUsers[index];
                      return FutureBuilder<bool>(
                          future: friendsController.checkIfRequestExist(
                              requestTo: foundUser.userId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              //if we got an error
                              if (snapshot.hasError) {
                                // showSnackbar(title: 'Error', msg: 'Try again');
                              }
                              //if we got the data
                              else if (snapshot.hasData) {
                                //getting snapshot data
                                RxBool isRequestSent = RxBool(snapshot.data!);

                                return Obx(() => _FriendTile(
                                      image: foundUser.profilePic!,
                                      name: foundUser.fullName!,
                                      userName: foundUser.userName!,
                                      isOnline: foundUser.isOnline!,
                                      isRequested: false,
                                      requestSent: isRequestSent.value,
                                      isFriend: friendsController.friendsIds
                                          .contains(foundUser.userId),
                                      onTap: () async {
                                        if (isRequestSent.value == false) {
                                          //sending friend request
                                          await friendsController.requestToAdd(
                                              context: context,
                                              requestTo: foundUser.userId);
                                          isRequestSent.value = true;
                                        } else {
                                          //deleting friend request
                                          await friendsController.deleteRequest(
                                              requestTo: foundUser.userId);
                                          isRequestSent.value = false;
                                        }
                                      },
                                    ));
                              }
                            }
                            return Center(
                                child: const CupertinoActivityIndicator(
                              animating: true,
                              radius: 20,
                              color: kSecondaryColor,
                            ));
                          });
                    })),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          MyText(
                            text: _currentIndex == 0
                                ? 'Suggestions'
                                : _currentIndex == 1
                                    ? 'Friends'
                                    : 'Friend requests',
                            weight: FontWeight.w500,
                            paddingRight: 10,
                            size: 14,
                          ),
                          Obx(
                            () => MyText(
                              text: _currentIndex == 0
                                  ? '${friendsController.knownUsers.length}'
                                  : _currentIndex == 1
                                      ? '${friendsController.friendsList.length}'
                                      : '${friendsController.requestList.length}',
                              size: 14,
                              weight: FontWeight.w600,
                              color: kBlueColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // MyText(
                    //   text: 'See all',
                    //   size: 12,
                    //   color: kGreyColor7,
                    // ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                _currentIndex == 0
                    ? _Suggestions()
                    : _currentIndex == 1
                        ? _Friends()
                        : _FriendsRequests(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Suggestions extends StatelessWidget {
  _Suggestions({
    super.key,
  });
  FriendsController friendsController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        itemCount: friendsController.knownUsers.length,
        itemBuilder: (context, index) {
          var data = friendsController.knownUsers[index];
          return GetBuilder<FriendsController>(
              init: FriendsController(),
              builder: (ctrlr) {
                return FutureBuilder<bool>(
                    future: friendsController.checkIfRequestExist(
                        requestTo: data.userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: kQuaternaryColor,
                          ),
                        );
                      } else if (snapshot.data == true) {
                        return _FriendTile(
                          image: data.profilePic!,
                          name: data.fullName!,
                          userName: data.userName!,
                          isOnline: data.isOnline!,
                          isRequested: false,
                          isFriend: false,
                          onTap: () async {
                            await friendsController.deleteRequest(
                                requestTo: data.userId);
                          },
                          requestSent: snapshot.data!,
                        );
                      } else if (snapshot.data == false) {
                        return _FriendTile(
                          image: data.profilePic!,
                          name: data.fullName!,
                          userName: data.userName!,
                          isOnline: data.isOnline!,
                          isRequested: false,
                          isFriend: false,
                          onTap: () async {
                            await friendsController.requestToAdd(
                                context: context, requestTo: data.userId);
                          },
                          requestSent: snapshot.data!,
                        );
                      } else {
                        return MyText(text: 'Error');
                      }
                    });
              });
        },
      ),
    );
  }
}

class _Friends extends StatelessWidget {
  FriendsController friendsController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        itemCount: friendsController.friendsList.length,
        itemBuilder: (context, index) {
          var data = friendsController.friendsList[index];
          return _FriendTile(
            image: data.profilePic!,
            name: data.fullName!,
            userName: data.userName!,
            isOnline: data.isOnline!,
            isRequested: false,
            isFriend: true,
            onTap: () async {
              await friendsController.unfriendUser(requestFrom: data.userId!);
            },
            requestSent: false,
          );
        },
      ),
    );
  }
}

class _FriendsRequests extends StatelessWidget {
  FriendsController friendsController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        itemCount: friendsController.requestList.length,
        itemBuilder: (context, index) {
          var data = friendsController.requestList[index];
          return _FriendTile(
            image: data.profilePic!,
            name: data.fullName!,
            userName: data.userName!,
            isOnline: data.isOnline!,
            isRequested: true,
            isFriend: false,
            onTap: () async {
              await friendsController.acceptRequest(requestFrom: data.userId);
              friendsController.requestList
                  .removeWhere((element) => element.userId == data.userId);
            },
            requestSent: false,
          );
        },
      ),
    );
  }
}

class _FriendTile extends StatelessWidget {
  const _FriendTile({
    super.key,
    required this.image,
    required this.name,
    required this.userName,
    required this.isOnline,
    required this.isRequested,
    required this.requestSent,
    required this.isFriend,
    required this.onTap,
  });
  final String image, name, userName;
  final bool isOnline;
  final bool isRequested, requestSent;
  final bool isFriend;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: kSecondaryColor.withOpacity(0.15),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CommonImageView(
                height: 46,
                width: 46,
                radius: 100.0,
                url: image,
              ),
              if (isOnline)
                Positioned(
                  bottom: 3,
                  right: 3,
                  child: Image.asset(
                    Assets.imagesOnline,
                    height: 8,
                  ),
                ),
            ],
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyText(
                  text: name,
                  weight: FontWeight.w500,
                ),
                MyText(
                  text: '@$userName',
                  size: 12,
                  weight: FontWeight.w500,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 32,
              width: 84,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: requestSent ? kRedColor : kBlueColor,
              ),
              child: requestSent
                  ? Center(
                      child: MyText(
                        text: 'Cancel',
                        size: 12,
                        weight: FontWeight.w500,
                        color: kPrimaryColor,
                      ),
                    )
                  : isFriend
                      ? Center(
                          child: MyText(
                            text: 'Unfriend',
                            size: 12,
                            weight: FontWeight.w500,
                            color: kPrimaryColor,
                          ),
                        )
                      : isRequested
                          ? Center(
                              child: MyText(
                                text: 'Accept',
                                size: 12,
                                weight: FontWeight.w500,
                                color: kPrimaryColor,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  Assets.imagesAdd,
                                  height: 14,
                                ),
                                MyText(
                                  paddingLeft: 4,
                                  paddingRight: 4,
                                  text: 'Add',
                                  size: 12,
                                  weight: FontWeight.w500,
                                  color: kPrimaryColor,
                                ),
                              ],
                            ),
            ),
          ),
          // SizedBox(
          //   width: 12,
          // ),
          // Image.asset(
          //   Assets.imagesClose,
          //   height: 13,
          // ),
        ],
      ),
    );
  }
}

class _Search extends StatelessWidget {
  _Search({
    required this.onChanged,
  });

  void Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
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
        onChanged: onChanged,
        readOnly: false,
        // onTap: () => Get.to(() => SearchBikeCommunity()),
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
                height: 24,
              ),
            ],
          ),
          hintText: 'Search...',
          hintStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
      ),
    );
  }
}
