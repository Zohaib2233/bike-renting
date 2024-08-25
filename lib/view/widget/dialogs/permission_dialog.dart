import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/view/widget/custom_dialog_widget.dart';
import 'package:bike_gps/view/widget/my_button_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PermissionDialog extends StatelessWidget {
  const PermissionDialog({
    super.key,
    required this.onAllowTap,
    required this.permission,
    required this.icon,
    this.description = "You have not allowed permission for",
  });

  final VoidCallback onAllowTap;
  final String permission, icon, description;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Padding(
        padding: AppSizes.DEFAULT_PADDING_FOR_DIALOG,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
              text: '$description $permission',
              size: 15,
              weight: FontWeight.w700,
              textAlign: TextAlign.center,
              paddingTop: 32,
              paddingBottom: 16,
            ),
            Image.asset(
              icon,
              height: 133,
            ),
            SizedBox(
              height: 18,
            ),
            MyButton(
              buttonText: 'Allow $permission Permission',
              weight: FontWeight.w500,
              onTap: onAllowTap,
            ),
          ],
        ),
      ),
    );
  }
}
