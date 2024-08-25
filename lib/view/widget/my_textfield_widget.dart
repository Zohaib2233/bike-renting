import 'package:bike_gps/core/constants/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_colors.dart';
import 'my_text_widget.dart';

// ignore: must_be_immutable
class MyTextField extends StatelessWidget {
  MyTextField({
    Key? key,
    this.controller,
    this.keyboardType,
    this.hintText,
    this.marginBottom = 12,
    this.isObSecure = false,
    this.maxLength,
    this.maxLines = 1,
    this.isEnabled = true,
    this.labelText,
    this.suffixIcon,
    this.validator,
    this.onTap,
    this.haveSuffix = false,
    this.onChanged,
    this.suffixIconSize,
    this.onSuffixTap,
    this.focusBorderColor,
    this.radius,
    this.inputFormatters,
  }) : super(key: key);
  String? hintText, labelText, suffixIcon;
  double? marginBottom, suffixIconSize, radius;
  bool? isObSecure, isEnabled, haveSuffix;
  int? maxLength, maxLines;
  VoidCallback? onSuffixTap;
  Color? focusBorderColor;

  TextInputType? keyboardType;
  TextEditingController? controller;
  FormFieldValidator<String>? validator;
  ValueChanged<String>? onChanged;

  List<TextInputFormatter>? inputFormatters;

  VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: marginBottom!,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (labelText != null)
            MyText(
              text: labelText!,
              size: 12,
              weight: FontWeight.w500,
              color: kDarkGreyColor,
              paddingBottom: 3,
            ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius ?? 24),
              boxShadow: [
                BoxShadow(
                  color: kBlackColor.withOpacity(0.03),
                  blurRadius: 47,
                  offset: Offset(-2, 6),
                ),
              ],
            ),
            child: TextFormField(
              cursorColor: kDarkGreyColor,
              onTap: onTap,
              enabled: isEnabled,
              inputFormatters: inputFormatters,
              validator: validator,
              maxLines: maxLines,
              maxLength: maxLength,
              onChanged: onChanged,
              obscureText: isObSecure!,
              obscuringCharacter: '*',
              controller: controller,
              textInputAction: TextInputAction.next,
              textAlignVertical:
                  suffixIcon != null ? TextAlignVertical.center : null,
              keyboardType: keyboardType,
              style: TextStyle(
                fontSize: 12,
                color: kDarkGreyColor,
                fontWeight: FontWeight.w500,
                fontFamily: AppFonts.POPPINS,
              ),
              decoration: InputDecoration(
                fillColor: kPrimaryColor,
                filled: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: maxLines! > 1 ? 15 : 0,
                ),
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: kHintColor,
                  fontFamily: AppFonts.POPPINS,
                ),
                suffixIconConstraints: BoxConstraints(
                  minWidth: haveSuffix! ? 40 : 16,
                ),
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (haveSuffix!)
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 10,
                        ),
                        child: GestureDetector(
                          onTap: onSuffixTap,
                          child: Image.asset(
                            suffixIcon!,
                            height: suffixIconSize ?? 20,
                          ),
                        ),
                      ),
                  ],
                ),
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: kInputBorderColor,
                  ),
                  borderRadius: BorderRadius.circular(radius ?? 24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius ?? 24),
                  borderSide: BorderSide(
                    width: 1,
                    color: focusBorderColor ?? kSecondaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
