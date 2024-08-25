import 'package:bike_gps/core/constants/firebase_collection_references.dart';
import 'package:bike_gps/core/constants/instances_constants.dart';
import 'package:bike_gps/core/utils/dialogs.dart';
import 'package:bike_gps/core/utils/snackbars.dart';
import 'package:bike_gps/models/community_model/community_model.dart';
import 'package:bike_gps/models/post_model/post_model.dart';
import 'package:bike_gps/services/firebase/firebase_crud.dart';
import 'package:bike_gps/services/firebase/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/utils/file_pickers/image_picker.dart';

class CommunityController extends GetxController {
  TextEditingController communityName = TextEditingController();
  TextEditingController communityAddress = TextEditingController();
  TextEditingController caption = TextEditingController();
  XFile? communityImage;
  RxList<CommunityModel> allCommunities = RxList([]);
  RxList<CommunityModel> joinedCommunities = RxList([]);
  RxList<CommunityModel> myCommunities = RxList([]);
  RxList<XFile> pickedImagesForPost = RxList([]);

  //user reported posts ids list
  List reportedPostsIds = [];

  //method to select image from gallery

  Future<void> selectImageFromGallery() async {
    //selecting other doc images

    var img = await ImagePickerService.instance.pickSingleImageFromGallery();
    if (img != null) {
      communityImage = img;
    }
    update();
  }

  Future<void> selectImageFromGalleryForPost() async {
    //selecting other doc images

    var img = await ImagePickerService.instance.pickSingleImageFromGallery();
    if (img != null) {
      pickedImagesForPost.add(img);
    }
    update();
  }

  //method to select image from camera
  Future<void> selectImageFromCamera() async {
    //selecting other docs images
    XFile? img = await ImagePickerService.instance.pickImageFromCamera();

    if (img != null) {
      communityImage = img;
    }
    update();
  }

  Future<void> selectImageFromCameraForPost() async {
    //selecting other docs images
    XFile? img = await ImagePickerService.instance.pickImageFromCamera();

    if (img != null) {
      pickedImagesForPost.add(img);
    }
    update();
  }

  //method to open image picker bottom sheet
  void openImgPickerBottomSheet({required BuildContext context}) {
    ImagePickerService.instance.openProfilePickerBottomSheet(
        context: context,
        onCameraPick: () async {
          await selectImageFromCamera();

          //closing modal bottom sheet
          Get.back();
        },
        onGalleryPick: () async {
          await selectImageFromGallery();

          //closing modal bottom sheet
          Get.back();
        });
  }

  //method to get user reported posts ids
  Future<void> getUserReportedPostsIds() async {
    //getting user id
    String userId = FirebaseAuth.instance.currentUser!.uid;

    var userReportedPosts =
        await FirebaseCRUDService.instance.readSingleDocument(
      collectionReference: userReportedPostsCollection,
      docId: userId,
    );

    if (userReportedPosts != null) {
      //getting user reported posts ids list
      reportedPostsIds = userReportedPosts.get("reportedPosts");
    }
  }

  createCommunity(
      {required CommunityModel communityModel,
      required BuildContext context}) async {
    DialogService.instance.showProgressDialog(context: context);
    var downloadImage = await FirebaseStorageService.instance.uploadSingleImage(
        imgFilePath: communityModel.picture, storageRef: 'communityImages');
    communityModel.picture = downloadImage;
    var response = await FirebaseCRUDService.instance.createDocument(
        collectionReference: communityCollection,
        docId: communityModel.docId,
        data: communityModel.toMap());
    Get.back();
    if (response) {
      await callInitFunctions();
      Get.back();
      cleanControllers();

      CustomSnackBars.instance.showSuccessSnackbar(
          title: 'Success', message: 'Community created successfully');
    }
    return response;
  }

  cleanControllers() {
    communityName.clear();
    communityImage = null;
    communityAddress.clear();
  }

  getAllCommunities() async {
    allCommunities.clear();
    var response = await FirebaseCRUDService.instance
        .readAllDoc(collectionReference: communityCollection);
    if (response != null) {
      for (var data in response) {
        allCommunities
            .add(CommunityModel.fromMap(data.data() as Map<String, dynamic>));
      }

      await separateCommunities();
    }
  }

  joinCommunity({required CommunityModel communityModel}) async {
    var response = await FirebaseCRUDService.instance.updateDocument(
        collection: communityCollection,
        docId: communityModel.docId,
        data: {
          'members': FieldValue.arrayUnion([userModelGlobal.value.userId])
        });
    if (response) {
      //adding community in joined communities
      joinedCommunities.add(communityModel);

      CustomSnackBars.instance
          .showToast(message: 'Joined ${communityModel.name}');
    }
    update();
    return response;
  }

  leaveCommunity({required CommunityModel communityModel}) async {
    var response = await FirebaseCRUDService.instance.updateDocument(
        collection: communityCollection,
        docId: communityModel.docId,
        data: {
          'members': FieldValue.arrayRemove([userModelGlobal.value.userId])
        });
    if (response) {
      //removing community from joined communities
      joinedCommunities.remove(communityModel);

      CustomSnackBars.instance
          .showToast(message: 'Left ${communityModel.name}');
    }
    update();
    return response;
  }

  separateCommunities() {
    joinedCommunities.clear();
    myCommunities.clear();
    print('IN SEPERATE LIST FUNCTION ${allCommunities.length}');
    allCommunities.forEach((element) {
      print(element.members);
      print(element.createdByUser);
      if (element.members.contains(FirebaseAuth.instance.currentUser!.uid)) {
        print(element.docId);
        joinedCommunities.add(element);
      }
      if (element.createdByUser == FirebaseAuth.instance.currentUser!.uid) {
        print(element.docId);
        myCommunities.add(element);
      }
    });
  }

  uploadPost(
      {required PostModel postModel, required BuildContext context}) async {
    DialogService.instance.showProgressDialog(context: context);
    var downloadImages = await FirebaseStorageService.instance
        .uploadMultipleImages(
            imagesPaths: pickedImagesForPost, storageRef: 'communityPost');
    postModel.postImages = downloadImages;
    var response = await FirebaseCRUDService.instance.createDocument(
        collectionReference: postsCollection,
        docId: postModel.docId,
        data: postModel.toMap());
    Get.back();
    if (response) {
      await callInitFunctions();
      Get.back();
      cleanControllers();

      CustomSnackBars.instance.showSuccessSnackbar(
          title: 'Success', message: 'Post uploaded successfully');
    }
    return response;
  }

  callInitFunctions() async {
    //calling this function if the user is logged in
    if (FirebaseAuth.instance.currentUser != null) {
      //getting user repodted posts ids
      await getUserReportedPostsIds();
      await getAllCommunities();
    }
  }

  //method to get community recent 3 posts
  Future<List<PostModel>> getCommunityRecentPosts(
      {required String communityId}) async {
    //list of recent posts of a community
    List<PostModel> recentPosts = [];

    //getting community recent posts
    List<QueryDocumentSnapshot>? recentPostsDocs =
        await FirebaseCRUDService.instance.readRecentDocsWithWhere(
            collectionReference: postsCollection,
            fieldName: "communityId",
            fieldValue: communityId,
            timeStampFieldName: "createAt",
            limit: 3);

    //getting recent posts
    if (recentPostsDocs != null && recentPostsDocs.isNotEmpty) {
      //adding recent posts in the recentPosts list
      for (var recentPostDoc in recentPostsDocs) {
        //adding the community posts based on the condition those posts are not reported by the user
        if (!reportedPostsIds.contains(recentPostDoc['docId'])) {
          recentPosts.add(PostModel.fromMap(recentPostDoc));
        }
      }
    }

    return recentPosts;
  }

  @override
  void onInit() {
    callInitFunctions();
    // TODO: implement onInit
    super.onInit();
  }
}
