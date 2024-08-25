import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_fonts.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/view/widget/my_button_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

class AddCard extends StatefulWidget {
  const AddCard({super.key});

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  TextEditingController cardNoController = TextEditingController();

  bool isCardNoValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: MyText(
          text: 'Add Card',
          size: 18,
          weight: FontWeight.w700,
          fontFamily: AppFonts.DM_SANS,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: AppSizes.DEFAULT,
              children: [
                CustomTextField(
                  label: 'Name on card',
                  hint: 'John doe',
                  marginBottom: 24,
                ),
                CustomTextField(
                  label: 'Card number',
                  hint: '',
                  keyboardType: TextInputType.number,
                  marginBottom: 24,
                  prefix: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Assets.imagesCreditCard,
                        height: 24,
                      ),
                    ],
                  ),
                  onChanged: (v) {
                    if (v.toString().length >= 16) {
                      setState(() {
                        isCardNoValid = true;
                      });
                    } else {
                      setState(() {
                        isCardNoValid = false;
                      });
                    }
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Exp. Date',
                        hint: 'MM/YY',
                        keyboardType: TextInputType.number,
                        marginBottom: 0,
                      ),
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    Expanded(
                      child: CustomTextField(
                        label: 'CVV',
                        hint: '123',
                        keyboardType: TextInputType.number,
                        marginBottom: 0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: MyButton(
              buttonText: 'Add Card',
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  CustomTextField({
    Key? key,
    this.controller,
    this.hint,
    this.label,
    this.onChanged,
    this.isObSecure = false,
    this.marginBottom = 16.0,
    this.maxLines = 1,
    this.filledColor,
    this.hintColor,
    this.haveLabel = true,
    this.labelSize,
    this.prefix,
    this.suffix,
    this.labelWeight,
    this.keyboardType,
    this.focusColor,
    this.validator,
  }) : super(key: key);
  String? label, hint;

  TextEditingController? controller;
  ValueChanged<String>? onChanged;
  bool? isObSecure, haveLabel;
  double? marginBottom;
  int? maxLines;
  double? labelSize;
  Color? filledColor, hintColor, focusColor;
  Widget? prefix, suffix;
  FontWeight? labelWeight;
  TextInputType? keyboardType;
  FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: marginBottom!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (haveLabel!)
            MyText(
              text: label!,
              size: labelSize ?? 10,
              color: kTextColor7,
              weight: labelWeight ?? FontWeight.w400,
              paddingBottom: 2,
            ),
          TextFormField(
            validator: validator,
            keyboardType: keyboardType,
            textAlignVertical: prefix != null || prefix != null
                ? TextAlignVertical.center
                : null,
            cursorColor: kTertiaryColor,
            maxLines: maxLines,
            controller: controller,
            onChanged: onChanged,
            textInputAction: TextInputAction.next,
            obscureText: isObSecure!,
            // obscuringCharacter: '*',

            style: TextStyle(
              fontSize: 15,
              color: kTextColor7,
              fontFamily: AppFonts.DM_SANS,
            ),
            decoration: InputDecoration(
              prefixIcon: prefix,
              suffixIcon: suffix,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: maxLines! > 1 ? 15 : 0,
              ),
              hintText: hint,
              fillColor: filledColor ?? Colors.transparent,
              filled: true,
              hintStyle: TextStyle(
                fontSize: 15,
                color: kHintColor,
                fontFamily: AppFonts.DM_SANS,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: kInputBorderColor,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: focusColor ?? kSecondaryColor,
                  width: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
