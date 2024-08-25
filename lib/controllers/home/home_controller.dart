import 'dart:developer';
import 'dart:io';

import 'package:bike_gps/core/bindings/bindings.dart';
import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/base_urls.dart';
import 'package:bike_gps/core/constants/firebase_collection_references.dart';
import 'package:bike_gps/core/constants/instances_constants.dart';
import 'package:bike_gps/core/env/keys.dart';
import 'package:bike_gps/core/utils/dialogs.dart';
import 'package:bike_gps/core/utils/google_maps/flutter_google_maps_utils.dart';
import 'package:bike_gps/core/utils/snackbars.dart';
import 'package:bike_gps/services/api/api.dart';
import 'package:bike_gps/services/firebase/firebase_crud.dart';
import 'package:bike_gps/services/google_maps/google_maps.dart';
import 'package:bike_gps/services/knaap/knaap.dart';
import 'package:bike_gps/view/screens/bike/find_my_bike.dart';
import 'package:bike_gps/view/widget/bottom_sheets/user_info_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeController extends GetxController {
  //handling last location map response
  Future<bool> _handleLastLocResponse(
      {required Map responseMap,
      bool shouldNavigate = true,
      BuildContext? context}) async {
    bool isSuccessful = false;

    try {
      if (responseMap['code'] == 0) {
        isSuccessful = true;

        //address of last known location of bike
        String lastKnownLocation = responseMap['address'];

        //latLng of last known location of bike
        LatLng lastKnownLocLatLng = LatLng(
            double.parse(responseMap['lat']), double.parse(responseMap['lng']));

        //creating geohash of the bike location
        Map bikeLastLocGeohash = await GoogleMapsService.instance
            .createGeoHash(latLng: lastKnownLocLatLng);

        //getting firebase user id
        String userId = FirebaseAuth.instance.currentUser!.uid;

        //creating payload for updating user bike last location
        Map<String, dynamic> userBikeLastLocMap = {
          "bikeLastKnownLocGeohash": bikeLastLocGeohash,
          "bikeLastKnownLocation": lastKnownLocation,
          "lastKnownLocFetchedOn": DateTime.now(),
        };

        //updating lastKnown location of the bike
        await FirebaseCRUDService.instance.updateDocument(
            collection: usersCollection,
            docId: userId,
            data: userBikeLastLocMap);

        if (shouldNavigate) {
          //popping progress indicator as the user will be navigating to FindMyBike screen
          Navigator.pop(context!);

          //navigating to FindMyBike screen
          Get.to(
            () => FindMyBike(),
            binding: FindBikeBinding(),
          );
        }

        return isSuccessful;
      } else if (responseMap.containsKey("result")) {
        if (shouldNavigate) {
          //popping progress indicator
          Navigator.pop(context!);
        }

        if (responseMap['code'] == 21002) {
          CustomSnackBars.instance.showFailureSnackbar(
              title: "Incorrect IMEI",
              message:
                  "Please update your device's IMEI with the correct format, as the current format is incorrect.");
        } else {
          CustomSnackBars.instance.showFailureSnackbar(
              title: "Failure", message: "${responseMap['result']}");
        }

        return isSuccessful;
      }
    } catch (e) {
      if (shouldNavigate) {
        //popping progress indicator
        Navigator.pop(context!);
      }
      CustomSnackBars.instance.showFailureSnackbar(
          title: "Failure", message: "Something went wrong, please try again");

      return isSuccessful;
    }

    return isSuccessful;
  }

  //method to get last known location of the device
  Future<bool> getLastKnownLocation(
      {bool shouldNavigate = true, BuildContext? context}) async {
    bool isSuccessful = false;

    //access token for API authentication
    String? accessToken = await KnaapServices.instance.getAccessToken();

    //imei of the device
    //TODO: replace this IMEI with the user device imei registered on Firebase
    String deviceImei = userModelGlobal.value.bikeIMEINo!;

    if (accessToken != null) {
      //creating url for last known location
      String locationUrl = knaapBaseUrl +
          "/device/location?accessToken=$accessToken&imei=$deviceImei";

      Map? lastLocationMap = await APIService.instance.get(locationUrl, true);

      //handling lastLocationMapResponse
      if (lastLocationMap != null) {
        isSuccessful = await _handleLastLocResponse(
          responseMap: lastLocationMap,
          shouldNavigate: shouldNavigate,
          context: context,
        );

        return isSuccessful;
      } else {
        if (shouldNavigate) {
          //popping progress indicator
          Navigator.pop(context!);
        }
        CustomSnackBars.instance.showFailureSnackbar(
            title: "Failure",
            message: "Something went wrong, please try again");

        return isSuccessful;
      }
    } else {
      if (shouldNavigate) {
        //popping progress indicator
        Navigator.pop(context!);
      }

      return isSuccessful;
    }
  }

  //handling bike lock response
  Future<bool> _handleBikeLockResp(
      {required Map responseMap, required bool isLock}) async {
    if (responseMap['code'] == 0) {
      //getting user id
      String userId = FirebaseAuth.instance.currentUser!.uid;

      if (isLock) {
        //updating bike lock status on user account
        await FirebaseCRUDService.instance.updateDocumentSingleKey(
          collection: usersCollection,
          docId: userId,
          key: "isBikeLocked",
          value: true,
        );
      } else {
        //updating bike unlock status on user account
        await FirebaseCRUDService.instance.updateDocumentSingleKey(
          collection: usersCollection,
          docId: userId,
          key: "isBikeLocked",
          value: false,
        );
      }

      CustomSnackBars.instance.showSuccessSnackbar(
          title: "Success",
          message: isLock
              ? "Your bike has been locked successfully"
              : "Your bike has been unlocked successfully");

      return true;
    } else if (responseMap.containsKey("result")) {
      if (responseMap['code'] == 23004) {
        CustomSnackBars.instance.showFailureSnackbar(
            title: "Incorrect IMEI",
            message:
                "Please update your device's IMEI with the correct format, as the current format is incorrect.");
      } else {
        CustomSnackBars.instance.showFailureSnackbar(
            title: "Failure", message: "${responseMap['result']}");
      }

      return false;
    }

    return false;
  }

  //method to lock the bike
  //this API will lock the bike by cutting off the electricity command
  //the bike will not be able to turn on until you turn on the electricity of the bike
  Future<bool> lockOrUnlockTheBike({required bool isLock}) async {
    bool isSuccessful = false;

    //access token for API authentication
    String? accessToken = await KnaapServices.instance.getAccessToken();

    //imei of the device
    //TODO: replace this IMEI with the user device imei registered on Firebase
    String deviceImei = userModelGlobal.value.bikeIMEINo!;

    //creating payload
    Map<String, dynamic> payload = {
      "parameter":
          isLock ? "2" : "1", //2 for locking and 1 for unlocking the bike
      "imeis": [deviceImei]
    };

    if (accessToken != null) {
      String bikeLockUrl =
          knaapBaseUrl + "/instruction/relay?accessToken=$accessToken";

      Map? bikeLockResp =
          await APIService.instance.post(bikeLockUrl, payload, true);

      if (bikeLockResp != null) {
        //handling bike lock response
        isSuccessful = await _handleBikeLockResp(
            responseMap: bikeLockResp, isLock: isLock);

        return isSuccessful;
      } else {
        CustomSnackBars.instance.showFailureSnackbar(
            title: "Failure",
            message: "Something went wrong, please try again");

        return isSuccessful;
      }
    } else {
      CustomSnackBars.instance.showFailureSnackbar(
          title: "Failure", message: "Something went wrong, please try again");

      return isSuccessful;
    }
  }

  //method to send bike stolen email  (using EmailJs server)
  Future<bool> _sendBikeStolenEmail({
    required String toEmail,
    required String senderName,
    required String senderMail,
    required String senderPhone,
  }) async {
    //creating headers
    Map<String, String> emailJsHeaders = {
      'origin':
          'http://localhost', //must be used in order to send email from Android/IOS devices
      HttpHeaders.contentTypeHeader: "application/json",
    };

    //bike last known location
    String bikeLastKnownLocation = userModelGlobal.value.bikeLastKnownLocation!;

    //bike last known location latLng
    LatLng bikeLastKnownLocationLatLng = FlutterGoogleMapsUtils.instance
        .getLatLngFromGeohash(
            geoHash: userModelGlobal.value.bikeLastKnownLocGeohash!);

    //bike stolen info
    String bikeStolenInfo =
        "To whom it may concern, \n I hope this message finds you well. I am writing to report the unfortunate incident of my bike being stolen, and I am seeking your assistance in addressing this matter promptly. Please find below the essential details related to the incident: \n\n1.  Frame Number: ${userModelGlobal.value.bikeFrameNo} \n2.  IMEI Number: ${userModelGlobal.value.bikeIMEINo} \n3.  Name: $senderName \n4.  Phone Number: $senderPhone \n5. Last Known Location: $bikeLastKnownLocation \n6.  Latitude and Longitude of the Last Known Location: $bikeLastKnownLocationLatLng \n\nI kindly request your immediate attention to this matter and appreciate any support or guidance you can provide in the investigation of this incident. Your expertise and assistance in locating and recovering my stolen bike would be invaluable. \n\nIf you require any further information or documentation, please do not hesitate to contact me at $senderPhone or $senderMail. \nThank you for your prompt attention to this matter, and I look forward to a swift resolution. \n\nSincerely, \n\n$senderName\n$senderPhone";

    // log("bikeStolenInfo: $bikeStolenInfo");

    //creating payload
    Map<String, dynamic> body = {
      'service_id': emailJsServiceId,
      'template_id': emailJsTemplateId,
      'user_id': emailJsUserId,
      'template_params': {
        'user_name': senderName,
        'user_email': senderMail,
        'user_subject': "Urgent: Bike Theft Report - Assistance Needed",
        'user_message': bikeStolenInfo,
        'to_email': toEmail
      }
    };

    //sending email by using EmailJs server
    String? resp = await APIService.instance.postWithStringResponse(
      emailJsBaseUrl,
      body,
      true,
      headers: emailJsHeaders,
      showResult: true,
    );

    if (resp != null && resp == "OK") {
      return true;
    } else {
      return false;
    }
  }

  //method to open modal bottom sheet for getting apple user info
  void _openUserInfoBottomSheet({
    required BuildContext context,
    required TextEditingController nameCtrlr,
    required TextEditingController emailCtrlr,
    required TextEditingController phoneCtrlr,
    required VoidCallback onSubmitTap,
    required GlobalKey formKey,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      elevation: 0,
      builder: (_) {
        return Padding(
            padding: MediaQuery.of(context).systemGestureInsets,
            child: UserInfoBottomSheet(
              nameCtrlr: nameCtrlr,
              emailCtrlr: emailCtrlr,
              phoneCtrlr: phoneCtrlr,
              onSubmitTap: onSubmitTap,
              formKey: formKey,
              onCloseTap: () {
                //closing bottom sheet
                Get.back();
              },
            ));
      },
    );
  }

  //method to mark bike as stolen
  Future<void> markBikeAsStolen({
    required String name,
    required String mail,
    required String phone,
  }) async {
    //updting last known location of the bike
    bool isLastKnownLocGot = await getLastKnownLocation(shouldNavigate: false);

    //locking the bike
    bool isBikeLocked = await lockOrUnlockTheBike(isLock: true);

    //flag to detect if the emails were sent successfully
    bool isStolenMailSent = false;

    //sending bike stolen email to concerned authorities
    isStolenMailSent = await _sendBikeStolenEmail(
      toEmail: "stolen@knaapbikes.com",
      senderMail: mail,
      senderName: name,
      senderPhone: phone,
    );
    isStolenMailSent = await _sendBikeStolenEmail(
      toEmail: "Control@bhdnederland.nl",
      senderMail: mail,
      senderName: name,
      senderPhone: phone,
    );

    if (isBikeLocked) {
      //updating the bike locked status on user account
      await FirebaseCRUDService.instance.updateDocument(
          collection: usersCollection,
          docId: userModelGlobal.value.userId!,
          data: {
            'isBikeLocked': true,
          });
    }

    //updating the bike stolen status on user account
    await FirebaseCRUDService.instance.updateDocument(
        collection: usersCollection,
        docId: userModelGlobal.value.userId!,
        data: {
          'isBikeStolen': true,
        });

    if (isStolenMailSent) {
      CustomSnackBars.instance.showSuccessSnackbar(
        title: "Mails Sent",
        message:
            "An email regarding your stole bike has been sent to the relevant authorities. You will be notified about the resolution of the issue!",
        duration: 7,
      );
    }
  }

  //method to mark bike as not stolen
  Future<void> markBikeAsNotStolen() async {
    //updating the bike stolen status on user account
    await FirebaseCRUDService.instance.updateDocument(
        collection: usersCollection,
        docId: userModelGlobal.value.userId!,
        data: {
          'isBikeStolen': false,
        });
  }

  //method to handle bike stolen tap
  void handleBikeStolenTap({required BuildContext context}) {
    //checking if the user bike is marked as stolen or not
    bool isStolen = userModelGlobal.value.isBikeStolen!;

    Get.defaultDialog(
        title: isStolen ? "Have you got your bike?" : "Confirm",
        backgroundColor: kPrimaryColor,
        contentPadding: EdgeInsets.all(10),
        titleStyle: TextStyle(
            color: kBlackColor, fontSize: 20, fontWeight: FontWeight.w600),
        content: DialogService.instance.confirmationDialog(
          onConfirm: () async {
            //popping confirmation dialog
            Get.back();

            if (userModelGlobal.value.isBikeStolen != true) {
              //initializing text editing controllers for name, phone and email (in case if the user is apple user and he has not allowed permissions)
              TextEditingController nameCtrlr = TextEditingController();

              TextEditingController emailCtrlr = TextEditingController();

              TextEditingController phoneCtrlr = TextEditingController(
                  text: userModelGlobal.value.phoneCode! +
                      userModelGlobal.value.phoneNo!);

              //form key for validation
              var userInfoFormKey = GlobalKey<FormState>();

              if (userModelGlobal.value.fullName == "Apple User") {
                //opening user info bottom sheet to get apple user information
                _openUserInfoBottomSheet(
                  context: context,
                  nameCtrlr: nameCtrlr,
                  emailCtrlr: emailCtrlr,
                  phoneCtrlr: phoneCtrlr,
                  formKey: userInfoFormKey,
                  onSubmitTap: () async {
                    if (userInfoFormKey.currentState!.validate()) {
                      //showing progress dialog
                      DialogService.instance
                          .showProgressDialog(context: context);
                      //marking the bike as stolen
                      await markBikeAsStolen(
                        name: nameCtrlr.text,
                        mail: emailCtrlr.text,
                        phone: phoneCtrlr.text,
                      );
                      //popping progress dialog
                      Navigator.pop(context);

                      //popping bottom sheet
                      Navigator.pop(context);
                    }
                  },
                );
              } else {
                //showing progress dialog
                DialogService.instance.showProgressDialog(context: context);
                //marking the bike as stolen
                await markBikeAsStolen(
                  name: nameCtrlr.text,
                  mail: emailCtrlr.text,
                  phone: phoneCtrlr.text,
                );
                //popping progress dialog
                Navigator.pop(context);

                //popping bottom sheet
                Navigator.pop(context);
              }
            } else {
              //showing progress dialog
              DialogService.instance.showProgressDialog(context: context);
              //marking the bike as stolen
              await markBikeAsNotStolen();
              //popping progress dialog
              Navigator.pop(context);
            }
          },
          title: isStolen
              ? "Do you want to mark your bike as not stolen?"
              : "Are you sure you want to mark your bike as stolen?",
          yesBtnClr: isStolen ? kGreenColor : kRedColor,
          noBtnClr: isStolen ? kRedColor : kGreenColor,
        ));
  }
}
