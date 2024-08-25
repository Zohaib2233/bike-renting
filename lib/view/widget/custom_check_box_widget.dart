import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class CustomCheckBox extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;
  const CustomCheckBox({
    super.key,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(
          microseconds: 280,
        ),
        height: 14,
        width: 14,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: isActive ? kSecondaryColor : kTransparent,
          border: Border.all(
            width: 1.0,
            color: isActive ? kTransparent : kInputBorderColor,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.check,
            size: 12,
            color: isActive ? kPrimaryColor : kTransparent,
          ),
        ),
      ),
    );
  }
}
