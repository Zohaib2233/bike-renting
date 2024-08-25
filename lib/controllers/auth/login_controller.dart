import 'dart:developer';

import 'package:bike_gps/controllers/community/community_controller.dart';
import 'package:bike_gps/core/common/functions.dart';
import 'package:bike_gps/core/constants/firebase_collection_references.dart';
import 'package:bike_gps/core/utils/dialogs.dart';
import 'package:bike_gps/core/utils/snackbars.dart';
import 'package:bike_gps/services/firebase/firebase_crud.dart';
import 'package:bike_gps/services/google_maps/google_maps.dart';
import 'package:bike_gps/services/local_storage/local_storage.dart';
import 'package:bike_gps/services/notification/notification.dart';
import 'package:bike_gps/view/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:bike_gps/view/screens/user_profile/lets_started.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LoginController extends GetxController {
  //text editing controllers
  TextEditingController emailCtrlr = TextEditingController();
  TextEditingController pwdCtrlr = TextEditingController();

  //booleans
  //password visibility
  RxBool isShowPwd = true.obs;
  RxBool isRememberMe = true.obs;

  //toggle password
  void togglePwdView() {
    isShowPwd.value = !isShowPwd.value;
  }

  //toggle remember me
  void toggleRememberMe() {
    isRememberMe.value = !isRememberMe.value;
  }

  //method to get user geohash
  Future<Map> getUserGeohash() async {
    Map userGeoHash = {};

    //getting user location
    Position? userLocation = await GoogleMapsService.instance.getUserLocation();

    //creating user geohash
    if (userLocation != null) {
      //creating user position latLng
      LatLng userLatLng = LatLng(userLocation.latitude, userLocation.longitude);

      //getting user location geo hash
      userGeoHash =
          await GoogleMapsService.instance.createGeoHash(latLng: userLatLng);
    }

    return userGeoHash;
  }

  //logging in user with email and password
  Future<void> loginUserWithEmailAndPassword(
      {required BuildContext context}) async {
    //showing progress dialog
    DialogService.instance.showProgressDialog(context: context);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailCtrlr.text, password: pwdCtrlr.text);

      if (FirebaseAuth.instance.currentUser == null) {
        // showLoaderOnSignupScreen.value = false;
      }

      if (FirebaseAuth.instance.currentUser != null) {
        String deviceToken =
            await NotificationService.instance.getDeviceToken();

        //getting user id
        String uid = FirebaseAuth.instance.currentUser!.uid;

        //getting user geohash
        Map _userGeohash = await getUserGeohash();

        if (_userGeohash.isNotEmpty) {
          await FirebaseCRUDService.instance.updateDocumentSingleKey(
            collection: usersCollection,
            docId: uid,
            key: "geoHash",
            value: _userGeohash,
          );
        }

        //updating user device token and user email (if the user has updated his email, we are updating the email)
        await FirebaseCRUDService.instance
            .updateDocument(collection: usersCollection, docId: uid, data: {
          "deviceToken": deviceToken,
          "email": emailCtrlr.text,
        });

        //storing remember me setting
        await LocalStorageService.instance
            .write(key: "isRememberMe", value: isRememberMe.value);

        //fetching user data
        getUserDataStream(userId: uid);

        //checking if the user has filled additional info too
        DocumentSnapshot? userDoc =
            await FirebaseCRUDService.instance.readSingleDocument(
          collectionReference: usersCollection,
          docId: uid,
        );

        bool isAdditionalInfoFilled = false;

        if (userDoc != null) {
          isAdditionalInfoFilled = userDoc.get("isAdditionalInfoFilled");
        }

        //calling get communities function to get the user communities
        Get.find<CommunityController>().callInitFunctions();

        //popping progress indicator
        Navigator.pop(context);

        //showing success snackbar
        CustomSnackBars.instance.showSuccessSnackbar(
            title: 'Success', message: 'Authenticated successfully');

        //navigating user accordingly (if he has not filled any additional info)
        if (isAdditionalInfoFilled) {
          Get.offAll(
            () => BottomNavBar(),
          );

          // //deleting unuseful controllers
          // Get.delete<SignUpController>();
          // Get.delete<FirebaseAuthService>();
          // Get.delete<SplashScreenController>();
          // Get.delete<LoginController>();
        } else {
          Get.offAll(
            () => LetsStarted(),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      //popping progress indicator
      Navigator.pop(context);

      if (e.code == "invalid-credential" || e.code=="INVALID_LOGIN_CREDENTIALS") {
        //showing failure snackbar
        CustomSnackBars.instance.showFailureSnackbar(
            title: 'Authentication Error',
            message:
                "You have entered incorrect credentials, please try again!");
      } else {
        //showing failure snackbar
        CustomSnackBars.instance.showFailureSnackbar(
            title: 'Authentication Error', message: "${e.message}");
      }
    } on FirebaseException catch (e) {
      //popping progress indicator
      Navigator.pop(context);

      //showing failure snackbar
      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Authentication Error', message: "${e.message}");
    } catch (e) {
      log("This was the exception while logging in user: $e");
    }
  }

  @override
  void onClose() {
    // TODO: implement dispose
    super.onClose();

    emailCtrlr.dispose();
    pwdCtrlr.dispose();

    log("onClose called");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
