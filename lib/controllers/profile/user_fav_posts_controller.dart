import 'dart:async';
import 'dart:developer';

import 'package:bike_gps/core/constants/firebase_collection_references.dart';
import 'package:bike_gps/core/constants/instances_constants.dart';
import 'package:bike_gps/core/utils/dialogs.dart';
import 'package:bike_gps/core/utils/snackbars.dart';
import 'package:bike_gps/core/utils/uuid/uuid_functions.dart';
import 'package:bike_gps/models/post_model/post_comment_model.dart';
import 'package:bike_gps/models/post_model/post_model.dart';
import 'package:bike_gps/models/user_models/user_model.dart';
import 'package:bike_gps/services/firebase/firebase_crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserFavPostsController extends GetxController {
  //comments stream
  StreamSubscription<QuerySnapshot>? commentsStream;

  //observable list of PostModel
  RxList<PostModel> favPosts = RxList<PostModel>([]);

  //observable list of postComments
  RxList<PostCommentModel> postComments = RxList<PostCommentModel>([]);

  //focus node for comment field
  FocusNode commentFocusNode = FocusNode();

  //comment field controller
  TextEditingController commentCtrlr = TextEditingController();

  //scroll controller for fav posts list
  ScrollController scrollController = ScrollController();

  //scroll controller listener
  void scrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == 0) {
          // User is at the top of the list
          // isFetchingMoreBlogs.value = false;
          log("User is at the top of the list");
        } else {
          log("User is at the bottom of the list");
          // User is at the bottom of the list
          // isFetchingMoreBlogs.value = true;

          //getting more fav posts
          // getBlogs(wellnessGoals: userModelGlobal.value.wellnessGoals!);
        }
      }
    });
  }

  //method to get user fav posts
  Future<void> getUserFavPosts() async {
    //getting user fav posts
    List userFavPosts = userFavPostModelGlobal.value.favPosts!;

    //getting fav posts with pagination
    for (String postId in userFavPosts) {
      DocumentSnapshot? favPostDoc = await FirebaseCRUDService.instance
          .readSingleDocument(
              collectionReference: postsCollection, docId: postId);

      //adding post in user fav posts list
      if (favPostDoc != null) {
        //initializing UserFavPostModel
        PostModel userFavPostModel = PostModel.fromMap(favPostDoc);

        //adding in user fav posts list
        favPosts.add(userFavPostModel);
      }
    }
  }

  //method to get user model
  Future<UserModel> getUploaderModel({required String uploaderId}) async {
    //getting uploader doc from Firebase
    DocumentSnapshot? uploaderDoc = await FirebaseCRUDService.instance
        .readSingleDocument(
            collectionReference: usersCollection, docId: uploaderId);

    String dummyProfileImg =
        "https://firebasestorage.googleapis.com/v0/b/knaap-app.appspot.com/o/dummyImg.png?alt=media&token=92ddcb05-65a1-4316-adda-4db2d03ce95b";

    //dummy model (in case the user data is not found, so that this model can be used)
    UserModel uploaderModel = UserModel(
      userId: "",
      fullName: "",
      userName: "",
      email: "",
      phoneNo: "",
      phoneCode: "",
      profilePic: dummyProfileImg,
      geoHash: {},
      deviceToken: "",
      userType: "",
      country: "",
      joinedOn: DateTime.now(),
      rating: 0.0,
      totalRides: 0,
      isOnline: false,
      isShowOnline: false,
      favorites: [],
      isAdditionalInfoFilled: false,
      isShowNotification: false,
      bikeName: "",
      bikeType: "",
      bikeModel: "",
      bikeColor: "",
      bikeFrameNo: "",
      bikeIMEINo: "",
      isElectricBike: false,
      bikePics: [],
      docsPics: [],
      lastSeenOn: DateTime.now(),
      lastKnownLocFetchedOn: DateTime.now(),
      bikeLastKnownLocation: "",
      bikeLastKnownLocGeohash: {},
      isBikeLocked: false,
      isBikeStolen: false,
      isSocialSignIn: false,
    );

    if (uploaderDoc != null) {
      //initializing UserModel
      uploaderModel = UserModel.fromJson(uploaderDoc);
    }

    return uploaderModel;
  }

  //method to add a like in the post
  Future<bool> likeUnlikePost(
      {required String postId, required bool isLike}) async {
    bool isSuccess = false;

    if (isLike) {
      //adding the user id in the likes of post document
      isSuccess = await FirebaseCRUDService.instance.updateDocumentSingleKey(
          collection: postsCollection,
          docId: postId,
          key: "likes",
          value: FieldValue.arrayUnion([userModelGlobal.value.userId]));
    } else {
      //removing the user id in the likes of post document
      isSuccess = await FirebaseCRUDService.instance.updateDocumentSingleKey(
          collection: postsCollection,
          docId: postId,
          key: "likes",
          value: FieldValue.arrayRemove([userModelGlobal.value.userId]));
    }

    return isSuccess;
  }

  //method to add a post in the favorite posts of the user
  Future<void> removePostFromFav({
    required PostModel postModel,
  }) async {
    //removing the user id from the favorites of the user
    await FirebaseCRUDService.instance.updateDocumentSingleKey(
      collection: userFavPostsCollection,
      docId: userModelGlobal.value.userId!,
      key: "favPosts",
      value: FieldValue.arrayRemove([postModel.docId]),
    );

    //removing fav post id in local userFavPostModel list (to use it throughout the app)
    List userFavPosts = userFavPostModelGlobal.value.favPosts!;

    userFavPosts.remove(postModel.docId);

    userFavPostModelGlobal.value.favPosts = userFavPosts;

    //removing fav post model from favPosts list
    favPosts.remove(postModel);

    CustomSnackBars.instance
        .showToast(message: "Post removed from your favorites");

    //updating the UI
    update();
  }

  //method to get post comments
  void getPostComments({required String postId}) {
    //getting document snapshots stream
    commentsStream = postsCommentsCollection
        .where("commentedOnPost", isEqualTo: postId)
        .orderBy("commentedOn", descending: true)
        .snapshots()
        .listen((querySnapshot) {
      //clearing postComments list
      postComments.value = [];

      for (DocumentSnapshot document in querySnapshot.docs) {
        //initializing PostCommentModel
        PostCommentModel postCommentModel = PostCommentModel.fromJson(document);

        //adding post model in observable postComments list
        postComments.add(postCommentModel);
      }
    });
  }

  //method to dispose post comments stream
  Future<void> disposePostCommentsStream() async {
    //disposing off the comments stream
    if (commentsStream != null) {
      await commentsStream!.cancel();
    }

    //clearing the postComments list
    postComments.value = [];
  }

  //init PostCommentModel
  Map<String, dynamic> _initPostCommentModel({
    required String postId,
  }) {
    //generating unique id for comment
    String commentId = UuidFunctions.instance.createUuidV7();

    PostCommentModel postCommentModel = PostCommentModel(
      commentId: commentId,
      commentatorId: userModelGlobal.value.userId,
      comment: commentCtrlr.text,
      commentedOnPost: postId,
      commentedOn: DateTime.now(),
    );

    return postCommentModel.toJson();
  }

  //method to upload comment on post
  Future<bool> uploadCommentOnPost(
      {required String postId, required BuildContext context}) async {
    //checking if the user is trying to send empty comment
    if (commentCtrlr.text.isEmpty) {
      CustomSnackBars.instance.showToast(message: "Please type a comment");

      return false;
    }
    //if the comment is not empty
    else if (commentCtrlr.text.isNotEmpty) {
      //showing progress dialog
      DialogService.instance.showProgressDialog(context: context);

      //getting comment model
      Map<String, dynamic> commentMap = _initPostCommentModel(postId: postId);

      //uploading comment
      bool isCommentUploaded =
          await FirebaseCRUDService.instance.createDocument(
        collectionReference: postsCommentsCollection,
        docId: commentMap['commentId'],
        data: commentMap,
      );

      commentFocusNode.unfocus();

      //clearing the comment controller text
      commentCtrlr.text = "";

      //popping progress dialog
      Navigator.pop(context);

      if (isCommentUploaded) {
        //increasing comment count on the post
        await FirebaseCRUDService.instance.updateDocumentSingleKey(
          collection: postsCollection,
          docId: postId,
          key: "comments",
          value: FieldValue.increment(1),
        );

        CustomSnackBars.instance
            .showToast(message: "Comment uploaded successfully");

        return true;
      } else {
        CustomSnackBars.instance.showFailureSnackbar(
            title: "Failure", message: "Comment could not be posted");

        return false;
      }
    }

    return false;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    scrollListener();

    getUserFavPosts();

    super.onInit();
  }

  @override
  void onClose() async {
    // TODO: implement onClose
    super.onClose();

    commentFocusNode.dispose();

    commentCtrlr.dispose();

    scrollController.dispose();

    await disposePostCommentsStream();
  }
}
