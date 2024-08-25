import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

import 'my_text_widget.dart';

class AuthHeading extends StatelessWidget {
  final String title, subTitle;
  final double? paddingTop, paddingBottom;
  final TextAlign? textAlign;

  const AuthHeading({
    super.key,
    required this.title,
    required this.subTitle,
    this.paddingTop = 46,
    this.paddingBottom = 28,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MyText(
          text: title,
          size: 18,
          weight: FontWeight.w600,
          textAlign: textAlign ?? TextAlign.center,
          paddingTop: paddingTop,
          paddingBottom: 14,
        ),
        MyText(
          text: subTitle,
          size: 12,
          color: kLightGreyColor2.withOpacity(0.56),
          weight: FontWeight.w500,
          textAlign: textAlign ?? TextAlign.center,
          paddingBottom: paddingBottom,
        ),
      ],
    );
  }
}
