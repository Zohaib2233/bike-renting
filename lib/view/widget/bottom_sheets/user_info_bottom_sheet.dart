import 'package:bike_gps/constants/app_images.dart';
import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/utils/validators.dart';
import 'package:bike_gps/view/widget/my_button_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:bike_gps/view/widget/my_textfield_widget.dart';
import 'package:flutter/material.dart';

class UserInfoBottomSheet extends StatelessWidget {
  UserInfoBottomSheet({
    super.key,
    required this.nameCtrlr,
    required this.emailCtrlr,
    required this.phoneCtrlr,
    required this.onSubmitTap,
    required this.onCloseTap,
    required this.formKey,
  });

  final TextEditingController nameCtrlr, emailCtrlr, phoneCtrlr;
  final VoidCallback onSubmitTap, onCloseTap;
  final GlobalKey formKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 215,
      child: Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText(text: ""),
                          Image.asset(
                            Assets.imagesBottomSheetHandle,
                            color: kSecondaryColor,
                            height: 5,
                          ),
                          IconButton(
                            onPressed: onCloseTap,
                            icon: Icon(Icons.close),
                            color: kSecondaryColor,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MyText(
                        text:
                            "We haven't found your personal information from our database, please enter the necessary information so that we can contact you!",
                        weight: FontWeight.bold,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //name field
                      MyTextField(
                        labelText: 'Your name',
                        hintText: 'e.g. John Doe',
                        controller: nameCtrlr,
                        validator: ValidationService.instance.emptyValidator,
                      ),
                      //email field
                      MyTextField(
                        labelText: 'Your email',
                        hintText: 'john@gmail.com',
                        controller: emailCtrlr,
                        validator: ValidationService.instance.emailValidator,
                      ),
                      //phone field
                      MyTextField(
                        labelText: 'Your phone',
                        hintText: '+123456789',
                        controller: phoneCtrlr,
                        validator: ValidationService.instance.emptyValidator,
                      ),
                      //submit button
                      MyButton(
                        onTap: onSubmitTap,
                        buttonText: "Submit",
                      )
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
