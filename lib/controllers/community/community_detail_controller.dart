import 'dart:async';
import 'dart:developer';

import 'package:bike_gps/core/constants/firebase_collection_references.dart';
import 'package:bike_gps/core/constants/instances_constants.dart';
import 'package:bike_gps/core/utils/dialogs.dart';
import 'package:bike_gps/core/utils/snackbars.dart';
import 'package:bike_gps/core/utils/uuid/uuid_functions.dart';
import 'package:bike_gps/models/post_model/post_comment_model.dart';
import 'package:bike_gps/models/post_model/post_model.dart';
import 'package:bike_gps/models/post_model/post_report_model.dart';
import 'package:bike_gps/models/post_model/user_fav_post_model.dart';
import 'package:bike_gps/models/user_models/user_model.dart';
import 'package:bike_gps/services/firebase/firebase_crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityDetailController extends GetxController {
  //community posts stream
  StreamSubscription<QuerySnapshot>? postsStream;

  //comments stream
  StreamSubscription<QuerySnapshot>? commentsStream;

  //observable list of PostModel
  RxList<PostModel> communityPosts = RxList<PostModel>([]);

  //observable list of postComments
  RxList<PostCommentModel> postComments = RxList<PostCommentModel>([]);

  //focus node for comment field
  FocusNode commentFocusNode = FocusNode();

  //comment field controller
  TextEditingController commentCtrlr = TextEditingController();

  TextEditingController reasonCtrlr = TextEditingController();

  //report form key for validation
  final reportFormKey = GlobalKey<FormState>();

  //list of user reported posts ids
  List userReportedPostsIds = [];

  //init function
  void initFunction(
      {required List reportedPostsIds, required String communityId}) async {
    //setting reported posts ids
    userReportedPostsIds = reportedPostsIds;

    //getting community posts
    getCommunityPosts(communityId: communityId);
  }

  //method to get community posts
  void getCommunityPosts({required String communityId}) {
    //getting document snapshots stream
    postsStream = postsCollection
        .where("communityId", isEqualTo: communityId)
        .orderBy("createAt", descending: true)
        .snapshots()
        .listen((querySnapshot) {
      //clearing communityPosts list
      communityPosts.value = [];

      for (DocumentSnapshot document in querySnapshot.docs) {
        //initializing PostModel
        PostModel postModel = PostModel.fromMap(document);

        //adding post model in observable communityPosts list (if it is not reported by the user before)
        if (!userReportedPostsIds.contains(postModel.docId)) {
          communityPosts.add(postModel);
        }
      }
    });
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
  Future<void> likeUnlikePost(
      {required String postId, required bool isLike}) async {
    if (isLike) {
      //adding the user id in the likes of post document
      await FirebaseCRUDService.instance.updateDocumentSingleKey(
          collection: postsCollection,
          docId: postId,
          key: "likes",
          value: FieldValue.arrayUnion([userModelGlobal.value.userId]));
    } else {
      //removing the user id in the likes of post document
      await FirebaseCRUDService.instance.updateDocumentSingleKey(
          collection: postsCollection,
          docId: postId,
          key: "likes",
          value: FieldValue.arrayRemove([userModelGlobal.value.userId]));
    }
  }

  //initializing UserFavPostModel
  Map<String, dynamic> _initUserFavPostModel({required String postId}) {
    UserFavPostModel userFavPostModel = UserFavPostModel(
      userId: userModelGlobal.value.userId,
      favPosts: [postId],
    );

    return userFavPostModel.toJson();
  }

  //method to add a post in the favorite posts of the user
  Future<void> addRemovePostToFav(
      {required String postId, required bool isFav}) async {
    //checking if the user fav posts doc exists
    bool isFavPostDocExist = await FirebaseCRUDService.instance.isDocExist(
        collectionReference: userFavPostsCollection,
        docId: userModelGlobal.value.userId!);

    if (isFavPostDocExist) {
      if (isFav) {
        //adding the post id in the favorites of the user
        await FirebaseCRUDService.instance.updateDocumentSingleKey(
            collection: userFavPostsCollection,
            docId: userModelGlobal.value.userId!,
            key: "favPosts",
            value: FieldValue.arrayUnion([postId]));

        //adding fav post id in local userFavPostModel list (to use it throughout the app)
        List userFavPosts = userFavPostModelGlobal.value.favPosts!;

        userFavPosts.add(postId);

        userFavPostModelGlobal.value.favPosts = userFavPosts;

        CustomSnackBars.instance
            .showToast(message: "Post added to your favorites");
      } else {
        //removing the user id from the favorites of the user
        await FirebaseCRUDService.instance.updateDocumentSingleKey(
            collection: userFavPostsCollection,
            docId: userModelGlobal.value.userId!,
            key: "favPosts",
            value: FieldValue.arrayRemove([postId]));

        //removing fav post id in local userFavPostModel list (to use it throughout the app)
        List userFavPosts = userFavPostModelGlobal.value.favPosts!;

        userFavPosts.remove(postId);

        userFavPostModelGlobal.value.favPosts = userFavPosts;

        CustomSnackBars.instance
            .showToast(message: "Post removed from your favorites");
      }
    }
    //creating a new user fav post doc if it does not exist already (in case the user is adding the fav post first time)
    else {
      //creating user fav post model
      Map<String, dynamic> userFavPostMap =
          _initUserFavPostModel(postId: postId);

      bool isFavPostDocCreated =
          await FirebaseCRUDService.instance.createDocument(
        collectionReference: userFavPostsCollection,
        docId: userModelGlobal.value.userId!,
        data: userFavPostMap,
      );

      if (isFavPostDocCreated) {
        //adding fav post id in local userFavPostModel list (to use it throughout the app)
        userFavPostModelGlobal.value.favPosts!.add(postId);

        CustomSnackBars.instance
            .showToast(message: "Post added to your favorites");
      }
    }

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
  Future<void> uploadCommentOnPost(
      {required String postId, required BuildContext context}) async {
    //checking if the user is trying to send empty comment
    if (commentCtrlr.text.isEmpty) {
      CustomSnackBars.instance.showToast(message: "Please type a comment");

      return;
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
      } else {
        CustomSnackBars.instance.showFailureSnackbar(
            title: "Failure", message: "Comment could not be posted");
      }
    }
  }

  //remove after testing
  Future<void> uploadPostsInBulk() async {
    for (int i = 0; i < 25; i++) {
      var docId = UuidFunctions.instance.createUuidV7();

      PostModel postModel = PostModel(
        docId: docId,
        caption: "Caption no $i",
        postedByUser: userModelGlobal.value.userId!,
        createAt: DateTime.now(),
        postImages: [
          "https://firebasestorage.googleapis.com/v0/b/bikegps-c6e94.appspot.com/o/communityPost%2F9dac3c0b-dbd2-4517-8a20-88c73b7c3216345140007183236087.jpg?alt=media&token=bfbc0101-50a9-4571-93e3-3c1cfa329cf6",
          "https://firebasestorage.googleapis.com/v0/b/bikegps-c6e94.appspot.com/o/communityPost%2F18f028c1-80c5-43d2-82bd-24ef3ea23cbd5558660023645991633.jpg?alt=media&token=2c8592f0-a1da-41e6-a8c8-2fe89c9d2515",
        ],
        communityId: "9fa50bc0-da29-1e51-9358-bba37c21f040",
        likes: [],
        comments: 0,
      );

      var response = await FirebaseCRUDService.instance.createDocument(
          collectionReference: postsCollection,
          docId: postModel.docId,
          data: postModel.toMap());

      log("post $i upload status: $response");
    }
  }

  //method to check if the post is reported 5 times
  Future<void> _checkPostReportLimit({required String postId}) async {
    //getting post reports
    var postReports = await FirebaseCRUDService.instance.readAllDocByFieldName(
      collectionReference: postReportsCollection,
      fieldName: "postId",
      fieldValue: postId,
    );

    if (postReports != null) {
      if (postReports.length >= 5) {
        //deleting the post (as the post has reached the limit of reports)
        FirebaseCRUDService.instance.deleteDocument(
          collection: postsCollection,
          docId: postId,
        );
      }
    }
  }

  //initializing post report model
  Map<String, dynamic> _initPostReportModel(
      {required String postId,
      required String reportReason,
      required String reportedBy}) {
    //creating uuid
    String id = UuidFunctions.instance.createUuidV7();

    //current date
    DateTime reportedOn = DateTime.now();

    PostReportModel _postReportModel = PostReportModel(
      id: id,
      postId: postId,
      reportReason: reportReason,
      reportedBy: reportedBy,
      reportedOn: reportedOn,
    );

    return _postReportModel.toJson();
  }

  //method to report post
  Future<void> reportPost({
    required String postId,
    required int index,
  }) async {
    //getting user id
    String userId = FirebaseAuth.instance.currentUser!.uid;

    //getting post report json
    Map<String, dynamic> postReportMap = _initPostReportModel(
      postId: postId,
      reportReason: reasonCtrlr.text,
      reportedBy: userId,
    );

    //uploading post report on Firestore
    await FirebaseCRUDService.instance.createDocument(
      collectionReference: postReportsCollection,
      docId: postReportMap['id'],
      data: postReportMap,
    );

    //checking if the user reports exist
    var userReports = await FirebaseCRUDService.instance.readSingleDocument(
      collectionReference: userReportedPostsCollection,
      docId: userId,
    );

    //it means the user is reported for the first time
    if (userReports == null) {
      //adding post id into user reported posts list
      await FirebaseCRUDService.instance.createDocument(
        collectionReference: userReportedPostsCollection,
        docId: userId,
        data: {
          "reportedPosts": [postId]
        },
      );
    } else {
      await FirebaseCRUDService.instance.updateDocumentSingleKey(
        collection: userReportedPostsCollection,
        docId: userId,
        key: "reportedPosts",
        value: FieldValue.arrayUnion([postId]),
      );
    }

    //removing the post model from communityPosts
    communityPosts.removeAt(index);

    //clearing report reason controller
    reasonCtrlr.text = "";

    CustomSnackBars.instance.showToast(message: "Post reported!");

    //checking if the post has greater than 5 reports (if yes the post will be deleted automatically)
    await _checkPostReportLimit(postId: postId);
  }

  @override
  void onClose() async {
    // TODO: implement onClose
    super.onClose();

    commentFocusNode.dispose();

    commentCtrlr.dispose();
    reasonCtrlr.dispose();

    if (postsStream != null) {
      await postsStream!.cancel();
    }

    await disposePostCommentsStream();
  }
}
