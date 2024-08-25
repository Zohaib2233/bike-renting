import 'dart:developer';
import 'package:bike_gps/controllers/community/community_controller.dart';
import 'package:bike_gps/core/common/functions.dart';
import 'package:bike_gps/core/constants/firebase_collection_references.dart';
import 'package:bike_gps/core/utils/dialogs.dart';
import 'package:bike_gps/core/utils/file_pickers/image_picker.dart';
import 'package:bike_gps/core/utils/snackbars.dart';
import 'package:bike_gps/models/user_models/user_model.dart';
import 'package:bike_gps/models/user_models/user_stats_model.dart';
import 'package:bike_gps/services/firebase/firebase_authentication.dart';
import 'package:bike_gps/services/firebase/firebase_crud.dart';
import 'package:bike_gps/services/firebase/firebase_storage.dart';
import 'package:bike_gps/services/google_maps/google_maps.dart';
import 'package:bike_gps/services/local_storage/local_storage.dart';
import 'package:bike_gps/services/notification/notification.dart';
import 'package:bike_gps/view/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:bike_gps/view/screens/user_profile/lets_started.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignUpController extends GetxController {
  //text editing controllers
  TextEditingController fullNameCtrlr = TextEditingController();
  TextEditingController userNameCtrlr = TextEditingController();
  TextEditingController emailCtrlr = TextEditingController();
  TextEditingController pwdCtrlr = TextEditingController();
  TextEditingController phoneNoCtrlr = TextEditingController();

  //bike info
  TextEditingController bikeNameCtrlr = TextEditingController();
  TextEditingController bikeModelCtrlr = TextEditingController();
  TextEditingController bikeColorCtrlr = TextEditingController();
  TextEditingController bikeFrameNoCtrlr = TextEditingController();
  TextEditingController bikeIMEICtrlr = TextEditingController();

  //selection variables
  RxString selectedBikeType = "".obs;
  RxString selectedPhoneCode = "+86".obs;

  //list of selected bike pics
  RxList<XFile> pickedBikeImages = RxList<XFile>([]);

  //list of other docs pics
  RxList<XFile> otherDocsImages = RxList<XFile>([]);

  //user location
  Position? userLocation;

  //booleans
  //password visibility
  RxBool isShowPwd = true.obs;
  RxBool isShowConfirmPwd = true.obs;

  RxBool isElectricBike = false.obs;

  //dummy image url (for initial upload)
  final String dummyProfileImg =
      "https://firebasestorage.googleapis.com/v0/b/knaap-app.appspot.com/o/dummyImg.png?alt=media&token=92ddcb05-65a1-4316-adda-4db2d03ce95b";

  //toggle password
  void togglePwdView() {
    isShowPwd.value = !isShowPwd.value;
  }

  //toggle confirm password
  void toggleConfirmPwdView() {
    isShowConfirmPwd.value = !isShowConfirmPwd.value;
  }

  //method to handle bike type dropdown
  void handleBikeTypeSelection({required String userSelection}) {
    if (userSelection == "Yes") {
      isElectricBike.value = true;
    } else if (userSelection == "No") {
      isElectricBike.value = false;
    }
  }

  //method to scan the barcode (to get the IMEI)
  void scanIMEI() async {
    String barcodeScanRes = "";

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      //setting scanned barcode result with bikeIMEI controller
      bikeIMEICtrlr.text = barcodeScanRes;
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  //method to select image from gallery
  Future<void> selectImageFromGallery({required bool isBikeDocTap}) async {
    if (isBikeDocTap) {
      //selecting bike doc images
      pickedBikeImages.addAll(
          await ImagePickerService.instance.pickMultiImagesFromGallery());
    } else {
      //selecting other doc images
      otherDocsImages.addAll(
          await ImagePickerService.instance.pickMultiImagesFromGallery());
    }
  }

  //method to select image from camera
  Future<void> selectImageFromCamera({required bool isBikeDocTap}) async {
    if (isBikeDocTap) {
      //selecting bike docs images
      XFile? selectedBikeImg =
          await ImagePickerService.instance.pickImageFromCamera();

      if (selectedBikeImg != null) {
        pickedBikeImages.add(selectedBikeImg);
      }
    } else {
      //selecting other docs images
      XFile? otherDocImg =
          await ImagePickerService.instance.pickImageFromCamera();

      if (otherDocImg != null) {
        otherDocsImages.add(otherDocImg);
      }
    }
  }

  //method to open image picker bottom sheet
  void openImgPickerBottomSheet(
      {required BuildContext context, required bool isBikeDocTap}) {
    ImagePickerService.instance.openProfilePickerBottomSheet(
        context: context,
        onCameraPick: () async {
          await selectImageFromCamera(isBikeDocTap: isBikeDocTap);

          //closing modal bottom sheet
          Get.back();
        },
        onGalleryPick: () async {
          await selectImageFromGallery(isBikeDocTap: isBikeDocTap);

          //closing modal bottom sheet
          Get.back();
        });
  }

  //getting user location
  Future<void> getUserLocation() async {
    userLocation = await GoogleMapsService.instance.getUserLocation();

    log("userLocation: $userLocation");
  }

  //method to get country from user location
  Future<String> _getUserCountry() async {
    Position? userPosition = await GoogleMapsService.instance.getUserLocation();

    if (userPosition != null) {
      //creating user latLng
      LatLng userLatLng = LatLng(userPosition.latitude, userPosition.longitude);

      String country =
          await GoogleMapsService.instance.getCountryName(latLng: userLatLng);

      return country;
    }

    return "";
  }

  //initializing user model
  Future<Map<String, dynamic>> initUserModel({required String userId}) async {
    Map userGeoHash = {};

    //getting user country
    String country = await _getUserCountry();

    //getting user location
    userLocation = await GoogleMapsService.instance.getUserLocation();

    //creating user geohash
    if (userLocation != null) {
      //creating user position latLng
      LatLng userLatLng =
          LatLng(userLocation!.latitude, userLocation!.longitude);

      //getting user location geo hash
      userGeoHash =
          await GoogleMapsService.instance.createGeoHash(latLng: userLatLng);
    }

    //getting device token
    String deviceToken = await NotificationService.instance.getDeviceToken();

    UserModel userModel = UserModel(
      userId: userId,
      fullName: fullNameCtrlr.text.trim(),
      userName: userNameCtrlr.text.trim(),
      email: emailCtrlr.text.trim(),
      phoneNo: '${selectedPhoneCode.value}${phoneNoCtrlr.text.trim()}',
      phoneCode: '',
      profilePic: dummyProfileImg,
      geoHash: userGeoHash,
      deviceToken: deviceToken,
      userType: "",
      country: country,
      joinedOn: DateTime.now(),
      rating: 0.0,
      totalRides: 0,
      isOnline: true,
      isShowOnline: true,
      favorites: [],
      isAdditionalInfoFilled: false,
      isShowNotification: true,
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
      bikeLastKnownLocation: "Unknown",
      bikeLastKnownLocGeohash: {},
      isBikeLocked: false,
      isBikeStolen: false,
      isSocialSignIn: false,
    );

    return userModel.toJson();
  }

  //initializing user model for google auth
  Future<Map<String, dynamic>> initUserModelForGoogleAuth(
      {required GoogleSignInAccount googleUser, required String userId}) async {
    Map userGeoHash = {};

    //getting user location
    userLocation = await GoogleMapsService.instance.getUserLocation();

    //getting user country
    String country = await _getUserCountry();

    //creating user geohash
    if (userLocation != null) {
      //creating user position latLng
      LatLng userLatLng =
          LatLng(userLocation!.latitude, userLocation!.longitude);

      //getting user location geo hash
      userGeoHash =
          await GoogleMapsService.instance.createGeoHash(latLng: userLatLng);
    }

    //getting device token
    String deviceToken = await NotificationService.instance.getDeviceToken();

    UserModel userModel = UserModel(
      userId: userId,
      fullName: googleUser.displayName ?? "No Name",
      userName: googleUser.email.split("@").first,
      email: googleUser.email,
      phoneNo: "",
      phoneCode: "",
      profilePic: googleUser.photoUrl ?? dummyProfileImg,
      geoHash: userGeoHash,
      deviceToken: deviceToken,
      userType: "",
      country: country,
      joinedOn: DateTime.now(),
      rating: 0.0,
      totalRides: 0,
      isOnline: true,
      isShowOnline: true,
      favorites: [],
      isAdditionalInfoFilled: false,
      isShowNotification: true,
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
      bikeLastKnownLocation: "Unknown",
      bikeLastKnownLocGeohash: {},
      isBikeLocked: false,
      isBikeStolen: false,
      isSocialSignIn: true,
    );

    return userModel.toJson();
  }

  //initializing UserStatsModel
  Map<String, dynamic> initUserStatsModel() {
    //getting userId
    String userId = FirebaseAuth.instance.currentUser!.uid;

    UserStatsModel userStatsModel = UserStatsModel(
      userId: userId,
      timeSpent: 0.0,
      avgSpeed: 0.0,
      totalDistance: 0.0,
      avgPulse: 0.0,
    );

    return userStatsModel.toJson();
  }

  //method to upload only user related information to firestore
  Future<void> uploadUserAdditionalInfo({required BuildContext context}) async {
    //showing progress dialog
    DialogService.instance.showProgressDialog(context: context);

    //uploading bike pics and getting urls
    List bikeImages = await FirebaseStorageService.instance
        .uploadMultipleImages(
            imagesPaths: pickedBikeImages, storageRef: "bikeImages");

    List otherDocsPics = [];

    //uploading other docs images (if selected)
    if (otherDocsImages.isNotEmpty) {
      otherDocsPics = await FirebaseStorageService.instance
          .uploadMultipleImages(
              imagesPaths: otherDocsImages, storageRef: "docsImages");
    }

    //creating user additional info map
    Map<String, dynamic> userAdditionalInfoMap = {
      "bikeColor": bikeColorCtrlr.text.trim(),
      "bikeFrameNo": bikeFrameNoCtrlr.text.trim(),
      "bikeIMEINo": bikeIMEICtrlr.text.trim(),
      "bikeModel": bikeModelCtrlr.text.trim(),
      "bikeName": bikeNameCtrlr.text.trim(),
      "bikePics": bikeImages,
      "bikeType": selectedBikeType.value,
      "docsPics": otherDocsPics,
      "isElectricBike": isElectricBike.value,
      "isAdditionalInfoFilled": true,
    };

    //getting userId
    String userId = FirebaseAuth.instance.currentUser!.uid;

    //uploading additional info
    bool isUploaded = await FirebaseCRUDService.instance.updateDocument(
      collection: usersCollection,
      docId: userId,
      data: userAdditionalInfoMap,
    );

    //initializing user stats model
    Map<String, dynamic> userStatsMap = initUserStatsModel();

    //uploading initial data for user stats model
    await FirebaseCRUDService.instance.createDocument(
      collectionReference: userStatsCollection,
      docId: userId,
      data: userStatsMap,
    );

    //popping progress indicator
    Navigator.pop(context);

    //deleting unuseful controllers
    // Get.delete<LoginController>();
    // Get.delete<SignUpController>();
    // Get.delete<FirebaseAuthService>();
    // Get.delete<SplashScreenController>();

    if (isUploaded) {
      //calling get communities function to get the user communities
      Get.find<CommunityController>().callInitFunctions();

      //fetching user data
      getUserDataStream(userId: userId);

      Get.offAll(
        () => BottomNavBar(),
      );
    }
  }

  //method to create user account
  Future<void> registerUser({required BuildContext context}) async {
    //showing progress dialog
    DialogService.instance.showProgressDialog(context: context);

    //finding FirebaseAuthService controller
    FirebaseAuthService firebaseAuthService = Get.find<FirebaseAuthService>();

    //creating user account
    User? firebaseUser = await firebaseAuthService.signUpUsingEmailAndPassword(
        email: emailCtrlr.text.trim(), password: pwdCtrlr.text.trim());

    //checking if the account creation was successful
    if (firebaseUser != null) {
      //getting userId
      String userId = FirebaseAuth.instance.currentUser!.uid;

      //initializing user model
      Map<String, dynamic> userMap = await initUserModel(userId: userId);

      //uploading user info to firestore
      bool isDocCreated = await FirebaseCRUDService.instance.createDocument(
        collectionReference: usersCollection,
        docId: userMap['userId'],
        data: userMap,
      );

      //popping progress indicator
      Navigator.pop(context);

      if (isDocCreated) {
        //storing remember me setting
        await LocalStorageService.instance
            .write(key: "isRememberMe", value: true);

        CustomSnackBars.instance.showSuccessSnackbar(
            title: "Success", message: "Account created successfully!");

        //navigating to UploadDocuments page
        Get.to(
          () => LetsStarted(),
        );
      }
    } else {
      //popping progress indicator
      Navigator.pop(context);
    }
  }

  //method to sign in user with google
  Future<void> googleSignInWithAlreadyAccount(
      {required String uid, required BuildContext context}) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);

    if (FirebaseAuth.instance.currentUser != null) {
      String deviceToken = await NotificationService.instance.getDeviceToken();

      //updating user's device token whenever he is logging in
      await usersCollection.doc(uid).update({'deviceToken': deviceToken});

      //checking if the user has filled additional info
      DocumentSnapshot? userDoc =
          await FirebaseCRUDService.instance.readSingleDocument(
        collectionReference: usersCollection,
        docId: uid,
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

      //popping progress indicator
      Navigator.pop(context);

      //showing success snackbar
      CustomSnackBars.instance.showSuccessSnackbar(
          title: 'Success', message: 'Authenticated successfully');

      //fetching user data
      getUserDataStream(userId: uid);

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
    } else {
      //popping progress indicator
      Navigator.pop(context);
      //showing failure snackbar
      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Error', message: 'Something went wrong, please try again');
    }
  }

  //method to create user account using google auth
  Future<void> registerUserWithGoogleAuth(
      {required BuildContext context}) async {
    //showing progress dialog
    DialogService.instance.showProgressDialog(context: context);

    //finding FirebaseAuthService controller
    FirebaseAuthService firebaseAuthService = Get.find<FirebaseAuthService>();

    //creating user account
    //(Firebase user,google user credentials,is user already exist on Firestore)
    (User?, GoogleSignInAccount?, bool) googleUser =
        await firebaseAuthService.authWithGoogle();

    //checking if the account creation was successful
    if (googleUser.$1 != null &&
        googleUser.$2 != null &&
        googleUser.$3 == false) {
      //getting userId
      String userId = FirebaseAuth.instance.currentUser!.uid;

      //initializing user model
      Map<String, dynamic> userMap = await initUserModelForGoogleAuth(
        googleUser: googleUser.$2!,
        userId: userId,
      );

      //uploading user info to firestore
      bool isDocCreated = await FirebaseCRUDService.instance.createDocument(
        collectionReference: usersCollection,
        docId: userMap['userId'],
        data: userMap,
      );

      //popping progress indicator
      Navigator.pop(context);

      if (isDocCreated) {
        //storing remember me setting
        await LocalStorageService.instance
            .write(key: "isRememberMe", value: true);

        CustomSnackBars.instance.showSuccessSnackbar(
            title: "Success", message: "Account created successfully!");

        //navigating to UploadDocuments page
        Get.to(
          () => LetsStarted(),
        );
      }
    } else if (googleUser.$1 != null &&
        googleUser.$2 != null &&
        googleUser.$3 == true) {
      //popping progress indicator
      Navigator.pop(context);

      //getting user id
      String userId = FirebaseAuth.instance.currentUser!.uid;

      //storing remember me setting
      await LocalStorageService.instance
          .write(key: "isRememberMe", value: true);

      await googleSignInWithAlreadyAccount(uid: userId, context: context);
    } else if (googleUser.$1 == null &&
        googleUser.$2 == null &&
        googleUser.$3 == false) {
      //popping progress indicator
      Navigator.pop(context);

      CustomSnackBars.instance.showFailureSnackbar(
          title: "Failure", message: "Something went wrong, please try again!");
    }
  }

  //initializing UserModel for appleAuth
  Future<Map<String, dynamic>> _initUserModelForAppleAuth(
      {required User appleUser}) async {
    Map userGeoHash = {};

    //getting user location
    userLocation = await GoogleMapsService.instance.getUserLocation();

    //getting user country
    String country = await _getUserCountry();

    //creating user geohash
    if (userLocation != null) {
      //creating user position latLng
      LatLng userLatLng =
          LatLng(userLocation!.latitude, userLocation!.longitude);

      //getting user location geo hash
      userGeoHash =
          await GoogleMapsService.instance.createGeoHash(latLng: userLatLng);
    }

    //getting device token
    String deviceToken = await NotificationService.instance.getDeviceToken();

    //getting user id
    String userId = appleUser.uid;

    //getting user name
    String userName =
        appleUser.displayName != null ? appleUser.displayName! : "Apple User";

    //getting email
    String userEmail = appleUser.email != null ? appleUser.email! : "";

    UserModel userModel = UserModel(
      userId: userId,
      fullName: userName,
      userName: userName,
      email: userEmail,
      phoneNo: "",
      phoneCode: "",
      profilePic: dummyProfileImg,
      geoHash: userGeoHash,
      deviceToken: deviceToken,
      userType: "",
      country: country,
      joinedOn: DateTime.now(),
      rating: 0.0,
      totalRides: 0,
      isOnline: true,
      isShowOnline: true,
      favorites: [],
      isAdditionalInfoFilled: false,
      isShowNotification: true,
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
      bikeLastKnownLocation: "Unknown",
      bikeLastKnownLocGeohash: {},
      isBikeLocked: false,
      isBikeStolen: false,
      isSocialSignIn: true,
    );

    return userModel.toJson();
  }

  //method to create user account using Apple sign in
  Future<void> registerUserWithAppleAuth(
      {required BuildContext context}) async {
    //showing progress indicator
    DialogService.instance.showProgressDialog(context: context);
    try {
      //(Firebase user,is user already exist on Firestore)
      (User?, bool) appleUser =
          await Get.find<FirebaseAuthService>().signInWithApple();

      if (appleUser.$1 != null && appleUser.$2 != true) {
        //creating a new account on Firestore
        Map<String, dynamic> userMap =
            await _initUserModelForAppleAuth(appleUser: appleUser.$1!);

        //uploading user info to firestore
        bool isDocCreated = await FirebaseCRUDService.instance.createDocument(
          collectionReference: usersCollection,
          docId: userMap['userId'],
          data: userMap,
        );

        //popping progress indicator
        Navigator.pop(context);

        if (isDocCreated) {
          //storing remember me setting
          await LocalStorageService.instance
              .write(key: "isRememberMe", value: true);

          CustomSnackBars.instance.showSuccessSnackbar(
              title: "Success", message: "Account created successfully!");

          //navigating to UploadDocuments page
          Get.to(
            () => LetsStarted(),
          );
        }
      } else if (appleUser.$1 != null && appleUser.$2 == true) {
        //it means the user has already registered an account using the Apple id

        //getting user id
        String userId = FirebaseAuth.instance.currentUser!.uid;

        //storing remember me setting
        await LocalStorageService.instance
            .write(key: "isRememberMe", value: true);

        String deviceToken =
            await NotificationService.instance.getDeviceToken();

        //updating user's device token whenever he is logging in
        await usersCollection.doc(userId).update({'deviceToken': deviceToken});

        //checking if the user has filled additional info
        DocumentSnapshot? userDoc =
            await FirebaseCRUDService.instance.readSingleDocument(
          collectionReference: usersCollection,
          docId: userId,
        );

        bool isAdditionalInfoFilled = false;

        if (userDoc != null) {
          isAdditionalInfoFilled = userDoc.get("isAdditionalInfoFilled");
        }

        //popping progress indicator
        Navigator.pop(context);

        //showing success snackbar
        CustomSnackBars.instance.showSuccessSnackbar(
            title: 'Success', message: 'Authenticated successfully');

        //fetching user data
        getUserDataStream(userId: userId);

        //navigating user accordingly (if he has not filled any additional info)
        if (isAdditionalInfoFilled) {
          Get.offAll(
            () => BottomNavBar(),
          );
        } else {
          Get.offAll(
            () => LetsStarted(),
          );
        }
      } else {
        //popping progress indicator
        Navigator.pop(context);

        CustomSnackBars.instance.showFailureSnackbar(
            title: "Failure",
            message: "Something went wrong, please try again!");
      }
    } on FirebaseException catch (e) {
      //popping progress indicator
      Navigator.pop(context);

      CustomSnackBars.instance
          .showFailureSnackbar(title: "Failure", message: "$e");
    } catch (e) {
      //popping progress indicator
      Navigator.pop(context);

      CustomSnackBars.instance.showFailureSnackbar(
          title: "Failure", message: "Something went wrong, please try again!");
    }
  }

  @override
  void onClose() {
    // TODO: implement dispose
    super.onClose();

    fullNameCtrlr.dispose();
    userNameCtrlr.dispose();
    emailCtrlr.dispose();
    pwdCtrlr.dispose();
    bikeNameCtrlr.dispose();
    bikeModelCtrlr.dispose();
    bikeColorCtrlr.dispose();
    bikeFrameNoCtrlr.dispose();
    phoneNoCtrlr.dispose();
    bikeIMEICtrlr.dispose();

    log("onClose called");
  }
}
