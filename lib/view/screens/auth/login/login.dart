import 'dart:io' show Platform;
import 'package:bike_gps/controllers/auth/login_controller.dart';
import 'package:bike_gps/controllers/auth/signup_controller.dart';
import 'package:bike_gps/core/bindings/bindings.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/core/utils/validators.dart';
import 'package:bike_gps/services/google_maps/google_maps.dart';
import 'package:bike_gps/view/screens/auth/forgot_password.dart';
import 'package:bike_gps/view/screens/auth/sign_up/create_account.dart';
import 'package:bike_gps/view/widget/custom_check_box_widget.dart';
import 'package:bike_gps/view/widget/headings_widget.dart';
import 'package:bike_gps/view/widget/my_button_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:bike_gps/view/widget/my_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/app_colors.dart';

// ignore: must_be_immutable
class Login extends StatelessWidget {
  Login({super.key});

  //finding LoginController
  LoginController controller = Get.find<LoginController>();

  //creating form key for validation
  final loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: loginFormKey,
        child: ListView(
          padding: AppSizes.DEFAULT,
          physics: const BouncingScrollPhysics(),
          children: [
            AuthHeading(
              title: 'Welcome back',
              subTitle: 'Please login to continue your\njourney with us.',
              paddingTop: 46,
              paddingBottom: 27,
            ),
            MyTextField(
              labelText: 'Your email',
              hintText: 'youremail@gmail.com',
              validator: ValidationService.instance.emailValidator,
              controller: controller.emailCtrlr,
            ),
            Obx(() => MyTextField(
                  labelText: 'Password',
                  hintText: '***************',
                  marginBottom: 22,
                  isObSecure: controller.isShowPwd.value,
                  haveSuffix: true,
                  validator: ValidationService.instance.emptyValidator,
                  controller: controller.pwdCtrlr,
                  suffixIcon: controller.isShowPwd.value
                      ? Assets.imagesShowPwdIcon
                      : Assets.imagesHidePwdIcon,
                  onSuffixTap: () {
                    controller.togglePwdView();
                  },
                )),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 5,
                    children: [
                      Obx(() => CustomCheckBox(
                            isActive: controller.isRememberMe.value,
                            onTap: () {
                              controller.toggleRememberMe();
                            },
                          )),
                      MyText(
                        text: 'Remember me',
                        size: 11,
                        color: kDarkGreyColor,
                        weight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(
                      () => ForgotPassword(),
                      binding: ForgotPasswordBinding(),
                    );
                  },
                  child: MyText(
                    text: 'Forgot Password?',
                    size: 11,
                    color: kDarkGreyColor,
                    weight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            MyButton(
              buttonText: 'Sign In',
              bgColor: kBlueColor,
              onTap: () {
                if (loginFormKey.currentState!.validate()) {
                  controller.loginUserWithEmailAndPassword(context: context);
                }
              },
            ),
            MyText(
              text: 'Or Sign in with',
              size: 12,
              color: kLightGreyColor,
              weight: FontWeight.w600,
              textAlign: TextAlign.center,
              paddingTop: 30,
              paddingBottom: 30,
            ),
            SocialButton(
              buttonText: 'Google',
              icon: Assets.imagesGoogleIcon,
              onTap: () async {
                await Get.find<SignUpController>()
                    .registerUserWithGoogleAuth(context: context);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Visibility(
              visible: Platform.isIOS,
              child: SocialButton(
                buttonText: 'Apple',
                icon: Assets.imagesAppleIcon,
                onTap: () async {
                  // await Get.find<SignUpController>()
                  //     .registerUserWithAppleAuth(context: context);

                  await Get.find<SignUpController>()
                      .registerUserWithAppleAuth(context: context);
                },
              ),
            ),
            SizedBox(
              height: 14,
            ),
            GestureDetector(
              onTap: () => Get.to(
                () => CreateAccount(),
              ),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  MyText(
                    text: 'Don’t have an Account? ',
                    size: 12,
                    color: kDarkGreyColor,
                    weight: FontWeight.w500,
                  ),
                  MyText(
                    text: 'Sign up',
                    size: 12,
                    color: kBlueColor,
                    weight: FontWeight.w700,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String buttonText, icon;
  final VoidCallback onTap;
  const SocialButton({
    required this.buttonText,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: kInputBorderColor,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: kBlackColor.withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          highlightColor: kBlueColor.withOpacity(0.1),
          splashColor: kBlueColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                icon,
                height: 22,
              ),
              MyText(
                paddingLeft: 11.18,
                text: buttonText,
                color: kTextColor2,
                weight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
