import 'package:bike_gps/controllers/auth/forgot_password_controller.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/core/utils/validators.dart';
import 'package:bike_gps/view/widget/my_button_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:bike_gps/view/widget/my_textfield_widget.dart';
import 'package:bike_gps/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  //finding ForgotPasswordController
  ForgotPasswordController controller = Get.find<ForgotPasswordController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(title: "Enter Email"),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: AppSizes.DEFAULT,
          physics: const BouncingScrollPhysics(),
          children: [
            MyText(
              text: "Please enter the email\nto get password reset link.",
              textAlign: TextAlign.center,
            ),
            MyTextField(
              labelText: '',
              hintText: 'youremail@gmail.com',
              validator: ValidationService.instance.emailValidator,
              controller: controller.emailCtrlr,
            ),
            const SizedBox(
              height: 10,
            ),
            MyButton(
              onTap: () {
                if (controller.formKey.currentState!.validate()) {
                  controller.sendPasswordResetMail(context: context);
                }
              },
              buttonText: "Send Link",
            )
          ],
        ),
      ),
    );
  }
}
