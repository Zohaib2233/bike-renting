import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomRadio extends StatelessWidget {
  CustomRadio({
    Key? key,
    required this.isActive,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  final bool isActive;
  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          AnimatedContainer(
            duration: Duration(
              milliseconds: 230,
            ),
            curve: Curves.easeInOut,
            height: 18,
            width: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive ? kSecondaryColor : kTertiaryColor,
                width: isActive ? 4 : 2,
              ),
            ),
          ),
          MyText(
            text: text,
            size: 10,
            color: isActive ? kSecondaryColor : kTertiaryColor,
            weight: isActive ? FontWeight.w500 : FontWeight.w400,
            paddingLeft: 10,
          ),
        ],
      ),
    );
  }
}
