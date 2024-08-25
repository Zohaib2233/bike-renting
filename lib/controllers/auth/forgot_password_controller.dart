import 'package:bike_gps/core/utils/dialogs.dart';
import 'package:bike_gps/core/utils/snackbars.dart';
import 'package:bike_gps/view/screens/auth/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  //text editing controller
  TextEditingController emailCtrlr = TextEditingController();

  //form key
  final formKey = GlobalKey<FormState>();

  //method to send the password reset link
  Future<void> sendPasswordResetMail({required BuildContext context}) async {
    //showing progress indicator
    DialogService.instance.showProgressDialog(context: context);

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailCtrlr.text);

      //popping progress indicator
      Navigator.pop(context);

      CustomSnackBars.instance.showSuccessSnackbar(
          title: "Success",
          message:
              "We have sent you a password reset email, please reset your password from there.");
      Get.off(() => Login());
    } on FirebaseException catch (e) {
      //popping progress indicator
      Navigator.pop(context);

      CustomSnackBars.instance
          .showFailureSnackbar(title: "Failure", message: e.message.toString());
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();

    emailCtrlr.dispose();
  }
}
