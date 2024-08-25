import 'package:bike_gps/controllers/auth/login_controller.dart';
import 'package:bike_gps/controllers/auth/signup_controller.dart';
import 'package:bike_gps/core/constants/firebase_collection_references.dart';
import 'package:bike_gps/core/constants/instances_constants.dart';
import 'package:bike_gps/core/utils/dialogs.dart';
import 'package:bike_gps/core/utils/snackbars.dart';
import 'package:bike_gps/services/firebase/firebase_authentication.dart';
import 'package:bike_gps/services/firebase/firebase_crud.dart';
import 'package:bike_gps/services/local_storage/local_storage.dart';
import 'package:bike_gps/view/screens/auth/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  //text editing controllers
  TextEditingController emailCtrlr = TextEditingController();
  TextEditingController pwdCtrlr = TextEditingController();
  TextEditingController newPwdCtrlr = TextEditingController();
  TextEditingController phoneCtrlr = TextEditingController();
  TextEditingController bikeIMEICtrlr =
      TextEditingController(text: userModelGlobal.value.bikeIMEINo);

  //booleans
  //flag to check user online status
  RxBool isShowOnline = RxBool(userModelGlobal.value.isShowOnline!);

  //flag to check if the user notifications are on
  RxBool isShowNotification = RxBool(userModelGlobal.value.isShowNotification!);

  //flag to check if the email field is filled or not
  RxBool isEmailFilled = false.obs;

  //flag to check if the email is being updated
  RxBool isProfileUpdating = false.obs;

  //selection variables
  RxString selectedPhoneCode = RxString(userModelGlobal.value.phoneCode!);

  //form keys for validation
  final emailFormKey = GlobalKey<FormState>();
  final pwdFormKey = GlobalKey<FormState>();
  final imeiFormKey = GlobalKey<FormState>();

  //method to handle my online status
  Future<void> handleOnlineStatus() async {
    isShowOnline.value = !isShowOnline.value;

    //updating setting on Firebase
    FirebaseCRUDService.instance.updateDocumentSingleKey(
      collection: usersCollection,
      docId: userModelGlobal.value.userId!,
      key: "isShowOnline",
      value: isShowOnline.value,
    );
  }

  //method to handle show notification
  Future<void> handleShowNotification() async {
    isShowNotification.value = !isShowNotification.value;

    //updating setting on Firebase
    FirebaseCRUDService.instance.updateDocumentSingleKey(
      collection: usersCollection,
      docId: userModelGlobal.value.userId!,
      key: "isShowNotification",
      value: isShowNotification.value,
    );
  }

  //method to handle email field filling action
  void handleEmailFieldAction() {
    if (emailCtrlr.text.isNotEmpty) {
      isEmailFilled.value = true;
    } else if (emailCtrlr.text.isEmpty) {
      isEmailFilled.value = false;
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

  //device IMEI => 866330054287952

  //method to update device IMEI
  Future<void> updateDeviceIMEI() async {
    //indicating that email is being updated
    isProfileUpdating.value = true;

    //checking if the user is changing phone no
    if (bikeIMEICtrlr.text.isNotEmpty) {
      //updating user device IMEI
      await FirebaseCRUDService.instance.updateDocument(
        collection: usersCollection,
        docId: userModelGlobal.value.userId!,
        data: {
          "bikeIMEINo": bikeIMEICtrlr.text,
        },
      );

      //indicating that IMEI is updated
      isProfileUpdating.value = false;

      CustomSnackBars.instance.showSuccessSnackbar(
          title: "IMEI Updated", message: "Device IMEI updated successfully");
    }
  }

  //method to update user phone
  Future<void> updateUserPhone() async {
    //indicating that email is being updated
    isProfileUpdating.value = true;

    //checking if the user is changing phone no
    if (phoneCtrlr.text.isNotEmpty) {
      //updating user phone no
      await FirebaseCRUDService.instance.updateDocument(
        collection: usersCollection,
        docId: userModelGlobal.value.userId!,
        data: {
          "phoneNo": phoneCtrlr.text,
          "phoneCode": selectedPhoneCode.value,
        },
      );

      //indicating that email is updated
      isProfileUpdating.value = false;

      CustomSnackBars.instance.showSuccessSnackbar(
          title: "Phone Updated", message: "Phone updated successfully");
    }
  }

  //method to update user email on firebase
  Future<void> updateUserEmail() async {
    //indicating that email is being updated
    isProfileUpdating.value = true;

    //checking if the user is changing email
    if (emailCtrlr.text.isNotEmpty) {
      //updating user email
      await FirebaseAuthService.instance.changeFirebaseEmail(
        email: userModelGlobal.value.email!,
        password: pwdCtrlr.text,
        newEmail: emailCtrlr.text,
      );
    }

    //indicating that email is updated
    isProfileUpdating.value = false;
  }

  //method to change Firebase password
  Future<void> updateUserPassword() async {
    await FirebaseAuthService.instance.changeFirebasePassword(
      email: userModelGlobal.value.email!,
      oldPassword: pwdCtrlr.text,
      newPassword: newPwdCtrlr.text,
    );
  }

  //method to initiate delete account process
  Future<void> initiateDeleteAccount({required BuildContext context}) async {
    //showing progress indicator
    DialogService.instance.showProgressDialog(context: context);

    bool isAccountDeleted = await deleteUserAccount();

    if (isAccountDeleted) {
      //deleting user data on Firestore
      await FirebaseCRUDService.instance.deleteDocument(
          collection: usersCollection, docId: userModelGlobal.value.userId!);

      //deleting isRemember me key from local storage
      await LocalStorageService.instance.deleteKey(key: "isRememberMe");

      //putting the controllers again
      Get.put<SignUpController>(SignUpController());
      Get.put<LoginController>(LoginController());
      Get.put<FirebaseAuthService>(FirebaseAuthService());

      //popping progress indicator
      Navigator.pop(context);

      //navigating back to Login screen
      Get.offAll(
        () => Login(),
      );
    } else {
      CustomSnackBars.instance.showFailureSnackbar(
          title: "Failure", message: "Something went wrong, please try again!");

      //popping progress indicator
      Navigator.pop(context);
    }
  }

  //method to delete a user account
  Future<bool> deleteUserAccount() async {
    bool isDeleted = false;
    try {
      await FirebaseAuth.instance.currentUser!.delete();

      isDeleted = true;

      return isDeleted;
    } on FirebaseAuthException catch (e) {
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Failure", message: "$e");

      if (e.code == "requires-recent-login") {
        isDeleted = await reauthenticateAndDelete();
      } else {
        // Handle other Firebase exceptions
      }

      return isDeleted;
    } catch (e) {
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Failure", message: "$e");

      return isDeleted;

      // Handle general exception
    }
  }

  //method to re-authenticate user
  Future<bool> reauthenticateAndDelete() async {
    try {
      final providerData =
          FirebaseAuth.instance.currentUser?.providerData.first;

      if (AppleAuthProvider().providerId == providerData!.providerId) {
        await FirebaseAuth.instance.currentUser!
            .reauthenticateWithProvider(AppleAuthProvider());
      } else if (GoogleAuthProvider().providerId == providerData.providerId) {
        await FirebaseAuth.instance.currentUser!
            .reauthenticateWithProvider(GoogleAuthProvider());
      }

      await FirebaseAuth.instance.currentUser?.delete();

      return true;
    } catch (e) {
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Failure", message: "$e");

      return false;
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();

    emailCtrlr.dispose();
    pwdCtrlr.dispose();
    phoneCtrlr.dispose();
    newPwdCtrlr.dispose();
    bikeIMEICtrlr.dispose();
  }
}
