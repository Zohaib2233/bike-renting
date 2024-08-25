import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppStyling {
  static const BOTTOM_SHEET_DEC = BoxDecoration(
    color: kPrimaryColor,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(28),
      topRight: Radius.circular(28),
    ),
  );
  static final INDICATOR = BoxDecoration(
    color: kSecondaryColor,
    borderRadius: BorderRadius.circular(50),
  );
}
