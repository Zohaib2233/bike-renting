import 'package:bike_gps/core/constants/app_fonts.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'my_text_widget.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  MyButton({
    this.buttonText,
    required this.onTap,
    this.height = 48,
    this.textSize,
    this.weight,
    this.radius,
    this.child,
    this.bgColor,
    this.showLoading = false,
    this.btnChildPadding = 0.0,
  });

  final String? buttonText;
  final VoidCallback onTap;
  double? height, textSize, radius;
  FontWeight? weight;
  Widget? child;
  Color? bgColor;
  final bool showLoading;

  double btnChildPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: bgColor ?? kSecondaryColor,
        borderRadius: BorderRadius.circular(radius ?? 12),
        boxShadow: [
          BoxShadow(
            color: kBlackColor.withOpacity(0.10),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(btnChildPadding),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: kPrimaryColor.withOpacity(0.1),
            highlightColor: kPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(radius ?? 12),
            child: child ??
                Center(
                  child: showLoading
                      ? const CircularProgressIndicator(
                          color: kWhiteColor2,
                        )
                      : MyText(
                          text: buttonText ?? 'Continue',
                          size: textSize ?? 14,
                          weight: weight ?? FontWeight.w500,
                          color: kPrimaryColor,
                          fontFamily: AppFonts.POPPINS,
                        ),
                ),
          ),
        ),
      ),
    );
  }
}

class MyIconButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  final double? size, iconSize;
  const MyIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size ?? 36,
        width: size ?? 36,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: kBlackColor.withOpacity(0.15),
              blurRadius: 15,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Center(
          child: Image.asset(
            icon,
            height: iconSize ?? 18,
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MyBorderButton extends StatelessWidget {
  MyBorderButton({
    this.buttonText,
    required this.onTap,
    this.height = 48,
    this.textSize,
    this.weight,
    this.child,
    this.borderColor,
    this.radius,
    this.textColor,
    this.bgColor,
  });

  final String? buttonText;
  final VoidCallback onTap;
  double? height, textSize, radius;
  FontWeight? weight;
  Widget? child;
  Color? borderColor, textColor, bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 8),
        color: bgColor ?? Colors.transparent,
        border: Border.all(
          width: 1.0,
          color: borderColor ?? kPrimaryColor,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: kSecondaryColor.withOpacity(0.1),
          highlightColor: kSecondaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(radius ?? 8),
          child: child != null
              ? child
              : Center(
                  child: MyText(
                    text: buttonText!,
                    size: textSize ?? 16,
                    weight: weight ?? FontWeight.w700,
                    color: textColor ?? kPrimaryColor,
                  ),
                ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MyRippleEffect extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  Color? splashColor;
  double? radius;
  MyRippleEffect({
    super.key,
    required this.child,
    required this.onTap,
    this.splashColor,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: splashColor ?? kPrimaryColor.withOpacity(0.1),
        highlightColor: splashColor ?? kPrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(radius ?? 14),
        child: child,
      ),
    );
  }
}
