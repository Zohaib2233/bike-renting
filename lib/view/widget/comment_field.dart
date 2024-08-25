import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CommentField extends StatelessWidget {
  CommentField({
    Key? key,
    this.controller,
    this.onChanged,
    required this.focusnode,
    required this.onSendComment,
  }) : super(key: key);

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FocusNode focusnode;
  final VoidCallback onSendComment;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            focusNode: focusnode,
            controller: controller,
            onChanged: onChanged,
            cursorWidth: 1.0,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: kBlackColor,
            ),
            decoration: InputDecoration(
              hintText: 'Type here...',
              hintStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: kHintColor.withOpacity(0.5),
              ),
              filled: true,
              fillColor: kPrimaryColor,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(
                  width: 1.0,
                  color: kSecondaryColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(
                  width: 1.0,
                  color: kSecondaryColor,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 15,
        ),
        IconButton(
          onPressed: onSendComment,
          icon: Icon(Icons.send),
          color: kSecondaryColor,
        )
        // InkWell(
        //   onTap: onSendComment,
        //   child: Image.asset(
        //     Assets.imagesShare,
        //     height: 20,
        //     color: kSecondaryColor,
        //   ),
        // ),
      ],
    );
  }
}
