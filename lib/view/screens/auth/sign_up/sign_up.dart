import 'package:bike_gps/core/constants/app_colors.dart';

import 'package:bike_gps/core/constants/app_images.dart';

import 'package:bike_gps/core/constants/app_sizes.dart';

import 'package:bike_gps/core/utils/validators.dart';

import 'package:bike_gps/view/screens/user_profile/lets_started.dart';

import 'package:bike_gps/view/widget/headings_widget.dart';

import 'package:bike_gps/view/widget/my_button_widget.dart';

import 'package:bike_gps/view/widget/my_text_widget.dart';

import 'package:bike_gps/view/widget/my_textfield_widget.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});

  //finding SignUpController

  // SignUpController controller = Get.find<SignUpController>();

  //creating form key

  final signUpFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: signUpFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: AppSizes.DEFAULT,
                physics: BouncingScrollPhysics(),
                children: [
                  AuthHeading(
                    title: 'SignUp today',
                    subTitle:
                        'Provide us your credentials to start\njourney with us.',
                  ),
                  MyTextField(
                    labelText: 'Your name',

                    hintText: 'e.g. John Doe',

                    // controller: controller.emailCtrlr,

                    validator: ValidationService.instance.emailValidator,
                  ),
                  MyTextField(
                    labelText: 'Your email',
                    hintText: 'youremail@gmail.com',
                  ),
                  MyTextField(
                    labelText: 'Password',
                    hintText: '***************',
                    isObSecure: true,
                    haveSuffix: true,
                    suffixIcon: Assets.imagesEyeIcon,
                    onSuffixTap: () {},
                  ),
                  MyTextField(
                    labelText: 'Confirm password',
                    hintText: '***************',
                    isObSecure: true,
                    haveSuffix: true,
                    suffixIcon: Assets.imagesEyeIcon,
                    onSuffixTap: () {},
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        Assets.imagesCheckCircular,
                        height: 12,
                      ),
                      Expanded(
                        child: MyText(
                          text:
                              'Password must be at least 8 character, uppercase, lowercase, and unique code!',
                          size: 10,
                          color: kTextColor3,
                          paddingLeft: 8,
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
                buttonText: 'Create Account',
                bgColor: kBlueColor,
                onTap: () {
                  Get.to(
                    () => LetsStarted(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
