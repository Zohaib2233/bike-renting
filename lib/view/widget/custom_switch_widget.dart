import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class CustomSwitch extends StatelessWidget {
  final bool switchVal;
  final ValueChanged<bool> onToggle;
  const CustomSwitch({
    super.key,
    required this.switchVal,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      height: 20,
      width: 40,
      padding: 1,
      toggleSize: 16,
      activeColor: kSecondaryColor,
      inactiveColor: kSecondaryColor,
      activeSwitchBorder: Border.all(color: kSecondaryColor),
      inactiveSwitchBorder: Border.all(
        color: kInputBorderColor,
      ),
      value: switchVal,
      onToggle: onToggle,
    );
  }
}
