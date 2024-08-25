import 'dart:async';
import 'package:bike_gps/controllers/auth/login_controller.dart';
import 'package:bike_gps/core/common/functions.dart';
import 'package:bike_gps/core/constants/firebase_collection_references.dart';
import 'package:bike_gps/services/firebase/firebase_crud.dart';
import 'package:bike_gps/services/local_storage/local_storage.dart';
import 'package:bike_gps/view/screens/auth/login/login.dart';
import 'package:bike_gps/view/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:bike_gps/view/screens/launch/get_started.dart';
import 'package:bike_gps/view/screens/user_profile/lets_started.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  //method to save in local storage that the uses is onboarded
  Future<void> userOnboarded() async {
    await LocalStorageService.instance.write(key: "isOnboarded", value: true);
  }

  //method to check if the user has tunred on remember me
  Future<bool> isUserRemembered() async {
    return await LocalStorageService.instance.read(key: "isRememberMe") ??
        false;
  }

  //method to check if the user is onboarded or not
  Future<bool> isUserOnboarded() async {
    return await LocalStorageService.instance.read(key: "isOnboarded") ?? false;
  }

  //method to update user geohash
  Future<void> updateUserGeohash() async {
    //getting user id
    String uid = FirebaseAuth.instance.currentUser!.uid;

    //getting user geohash
    Map _userGeohash = await Get.find<LoginController>().getUserGeohash();

    if (_userGeohash.isNotEmpty) {
      await FirebaseCRUDService.instance.updateDocumentSingleKey(
        collection: usersCollection,
        docId: uid,
        key: "geoHash",
        value: _userGeohash,
      );
    }
  }

  //method to handle splash screen
  void splashScreenHandler() async {
    bool isOnboarded = await isUserOnboarded();

    if (isOnboarded == false) {
      Timer(
        Duration(milliseconds: 2400),
        () => Get.offAll(() => GetStarted()),
      );
    } else {
      //checking if the user is logged in
      bool isRememberMe = await isUserRemembered();

      if (FirebaseAuth.instance.currentUser != null && isRememberMe) {
        //getting user id
        String userId = FirebaseAuth.instance.currentUser!.uid;

        //checking if the user has filled additional info also
        DocumentSnapshot? userDoc =
            await FirebaseCRUDService.instance.readSingleDocument(
          collectionReference: usersCollection,
          docId: userId,
        );

        bool isAdditionalInfoFilled = false;

        if (userDoc != null) {
          isAdditionalInfoFilled = userDoc.get("isAdditionalInfoFilled");
        }

        //deleting unuseful controllers
        // Get.delete<LoginController>();
        // Get.delete<SignUpController>();
        // Get.delete<FirebaseAuthService>();
        // Get.delete<SplashScreenController>();

        await updateUserGeohash();

        //navigating user accordingly (if he has not filled any additional info)
        if (isAdditionalInfoFilled) {
          //fetching user data
          getUserDataStream(userId: userId);

          Get.offAll(
            () => BottomNavBar(),
          );
        } else {
          Get.offAll(
            () => LetsStarted(),
          );
        }
      } else {
        Get.offAll(
          () => Login(),
        );
      }
    }
  }
}
