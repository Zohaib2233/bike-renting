import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../view/widget/custom_dialog_widget.dart';
import '../../view/widget/my_button_widget.dart';
import '../../view/widget/my_text_widget.dart';
import '../constants/app_colors.dart';

class DialogService {
  // Private constructor
  DialogService._privateConstructor();

  // Singleton instance variable
  static DialogService? _instance;

  //This code ensures that the singleton instance is created only when it's accessed for the first time.
  //Subsequent calls to DialogService.instance will return the same instance that was created before.

  // Getter to access the singleton instance
  static DialogService get instance {
    _instance ??= DialogService._privateConstructor();
    return _instance!;
  }

  void showProgressDialog({required BuildContext context}) {
    //showing progress indicator
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Center(child: CircularProgressIndicator())));
  }

  quitAppDialogue({required VoidCallback onTap}) {
    return CustomDialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyText(
            text: 'Are you sure you want to quit app?',
            size: 15,
            weight: FontWeight.w700,
            textAlign: TextAlign.center,
            paddingTop: 32,
            paddingBottom: 16,
          ),
          SizedBox(
            height: 18,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: MyButton(
                    buttonText: 'No',
                    bgColor: kGreenColor,
                    weight: FontWeight.w500,
                    onTap: () {
                      Get.back();
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: MyButton(
                    buttonText: 'Yes',
                    weight: FontWeight.w500,
                    onTap: onTap,
                    bgColor: kRedColor,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  //confirmation dialog
  Widget confirmationDialog({
    required VoidCallback onConfirm,
    required String title,
    Color yesBtnClr = kRedColor,
    Color noBtnClr = kGreenColor,
  }) {
    return CustomDialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyText(
            text: title,
            size: 15,
            weight: FontWeight.w700,
            textAlign: TextAlign.center,
            paddingTop: 32,
            paddingBottom: 16,
          ),
          SizedBox(
            height: 18,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: MyButton(
                    buttonText: 'No',
                    bgColor: noBtnClr,
                    weight: FontWeight.w500,
                    onTap: () {
                      Get.back();
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: MyButton(
                    buttonText: 'Yes',
                    weight: FontWeight.w500,
                    onTap: onConfirm,
                    bgColor: yesBtnClr,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
