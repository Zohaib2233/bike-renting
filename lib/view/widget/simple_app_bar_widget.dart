import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_fonts.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

AppBar simpleAppBar({
  String? title = '',
  String? leadingIcon = Assets.imagesArrowBackIos,
  Color? bgColor,
  titleColor,
  List<Widget>? actions,
  VoidCallback? onLeadingTap,
  double? leadingIconSize = 24,
  bool? haveLeading = true,
}) {
  return AppBar(
    backgroundColor: bgColor,
    centerTitle: true,
    automaticallyImplyLeading: false,
    titleSpacing: 0,
    leading: haveLeading!
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: GestureDetector(
                  onTap: onLeadingTap ?? () => Get.back(),
                  child: Image.asset(
                    leadingIcon ?? Assets.imagesArrowBackIos,
                    height: leadingIconSize,
                  ),
                ),
              ),
            ],
          )
        : null,
    title: MyText(
      text: title!,
      size: 18,
      color: titleColor ?? kTextColor4,
      weight: FontWeight.w700,
      fontFamily: AppFonts.NUNITO_SANS,
    ),
    actions: actions,
  );
}
