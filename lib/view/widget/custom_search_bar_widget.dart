import 'package:bike_gps/core/constants/app_fonts.dart';
import 'package:bike_gps/view/widget/my_button_widget.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    this.controller,
    this.validator,
    this.onChanged,
  });
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kTransparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      shadowColor: kBlackColor.withOpacity(0.5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: TextFormField(
          controller: controller,
          onChanged: onChanged,
          validator: validator,
          style: TextStyle(
            fontSize: 12,
            color: kInputBorderColor,
            fontWeight: FontWeight.w500,
            fontFamily: AppFonts.POPPINS,
          ),
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            filled: true,
            fillColor: kPrimaryColor,
            hintText: "Where to go?",
            hintStyle: TextStyle(
              fontSize: 12,
              color: kHintColor,
              fontFamily: AppFonts.POPPINS,
            ),
            suffixIcon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: SizedBox(
                    height: 40,
                    width: 100,
                    child: MyButton(
                      buttonText: 'Search',
                      textSize: 12,
                      weight: FontWeight.w400,
                      onTap: () {},
                    ),
                  ),
                ),
              ],
            ),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
