import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/core/utils/validators.dart';
import 'package:bike_gps/view/widget/custom_dialog_widget.dart';
import 'package:bike_gps/view/widget/my_button_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:bike_gps/view/widget/my_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportDialog extends StatelessWidget {
  const ReportDialog({
    super.key,
    required this.onReportTap,
    required this.title,
    required this.reasonCtrlr,
    required this.reportFormKey,
  });

  final VoidCallback onReportTap;
  final String title;

  final TextEditingController reasonCtrlr;

  final GlobalKey<FormState> reportFormKey;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Padding(
        padding: AppSizes.DEFAULT_PADDING_FOR_DIALOG,
        child: Material(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyIconButton(
                    size: 30,
                    iconSize: 35,
                    icon: Assets.imagesCloseIcon,
                    onTap: () {
                      //closing dialog
                      Get.back();
                    },
                  ),
                ],
              ),
              MyText(
                text: title,
                size: 15,
                weight: FontWeight.w700,
                textAlign: TextAlign.center,
                paddingTop: 32,
                paddingBottom: 16,
              ),
              Image.asset(
                "assets/images/exclamation.png",
                height: 70,
              ),
              SizedBox(
                height: 18,
              ),
              Form(
                key: reportFormKey,
                child: MyTextField(
                  labelText: 'Reason',
                  hintText: 'I didn\'t like this post',
                  controller: reasonCtrlr,
                  validator: ValidationService.instance.emptyValidator,
                ),
              ),
              MyButton(
                buttonText: 'Report',
                weight: FontWeight.w500,
                onTap: onReportTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
