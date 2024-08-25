import 'package:bike_gps/controllers/auth/signup_controller.dart';
import 'dart:io' show Platform;
import 'package:bike_gps/core/constants/app_colors.dart';

import 'package:bike_gps/core/constants/app_images.dart';

import 'package:bike_gps/core/constants/app_sizes.dart';

import 'package:bike_gps/core/utils/validators.dart';

import 'package:bike_gps/view/screens/auth/login/login.dart';
import 'package:bike_gps/view/screens/profile/edit_profile.dart';

import 'package:bike_gps/view/widget/headings_widget.dart';

import 'package:bike_gps/view/widget/my_button_widget.dart';

import 'package:bike_gps/view/widget/my_text_widget.dart';

import 'package:bike_gps/view/widget/my_textfield_widget.dart';
import 'package:country_picker/country_picker.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

class CreateAccount extends StatefulWidget {
  CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  //finding SignUpController

  SignUpController controller = Get.find<SignUpController>();

  //creating form key

  final signUpFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    //getting user location

    controller.getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: signUpFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              Assets.imagesBikeBg,
              height: 260,
              fit: BoxFit.cover,
            ),
            Expanded(
              child: ListView(
                padding: AppSizes.HORIZONTAL,
                physics: BouncingScrollPhysics(),
                children: [
                  AuthHeading(
                    title: 'Register now to start',
                    subTitle:
                        'Provide us your credentials to start journey\nwith us.',
                    textAlign: TextAlign.start,
                    paddingTop: 22,
                    paddingBottom: 17,
                  ),
                  MyTextField(
                    labelText: 'Your name',
                    hintText: 'e.g. John Doe',
                    controller: controller.fullNameCtrlr,
                    validator: ValidationService.instance.userNameValidator,
                  ),
                  MyTextField(
                    labelText: 'User name',
                    hintText: 'Callmejohn',
                    controller: controller.userNameCtrlr,
                    validator: ValidationService.instance.userNameValidator,
                  ),
                  MyTextField(
                    labelText: 'Your email',
                    hintText: 'youremail@gmail.com',
                    controller: controller.emailCtrlr,
                    validator: ValidationService.instance.emailValidator,
                  ),
                  // MyTextField(
                  //   labelText: 'Phone no',
                  //   hintText: '+123456789',
                  //   controller: controller.phoneNoCtrlr,
                  //   validator: ValidationService.instance.emptyValidator,
                  //   keyboardType: TextInputType.phone,
                  //   marginBottom: 14,
                  // ),
                  Obx(() => MyPhoneField(
                        label: 'Phone Number',
                        hint: '(+371) -26932965',
                        marginBottom: 17,
                        controller: controller.phoneNoCtrlr,
                        validator: ValidationService.instance.emptyValidator,
                        phoneCode: controller.selectedPhoneCode.value,
                        onCountrySelect: (Country country) {
                          controller.selectedPhoneCode.value =
                              "+" + country.phoneCode;
                        },
                      )),
                  Obx(() => MyTextField(
                        labelText: 'Password',
                        hintText: '***************',
                        marginBottom: 22,
                        isObSecure: controller.isShowPwd.value,
                        haveSuffix: true,
                        validator: ValidationService.instance.validatePassword,
                        controller: controller.pwdCtrlr,
                        suffixIcon: controller.isShowPwd.value
                            ? Assets.imagesShowPwdIcon
                            : Assets.imagesHidePwdIcon,
                        onSuffixTap: () {
                          controller.togglePwdView();
                        },
                      )),
                  Obx(() => MyTextField(
                        labelText: 'Confirm Password',
                        hintText: '***************',
                        marginBottom: 22,
                        isObSecure: controller.isShowConfirmPwd.value,
                        haveSuffix: true,
                        validator: (value) => ValidationService.instance
                            .validateMatchPassword(
                                value!, controller.pwdCtrlr.text),
                        suffixIcon: controller.isShowConfirmPwd.value
                            ? Assets.imagesShowPwdIcon
                            : Assets.imagesHidePwdIcon,
                        onSuffixTap: () {
                          controller.toggleConfirmPwdView();
                        },
                      )),
                  MyText(
                    text:
                        'Password must be at least 8 character, uppercase, lowercase, and unique code!',
                    size: 10,
                    color: kTextColor3,
                    paddingLeft: 8,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyButton(
                    buttonText: 'Create Account',
                    bgColor: kBlueColor,
                    onTap: () {
                      if (signUpFormKey.currentState!.validate()) {
                        controller.registerUser(context: context);
                      }
                    },
                  ),
                  MyText(
                    text: 'Or Sign up with',
                    size: 12,
                    color: kLightGreyColor,
                    weight: FontWeight.w600,
                    textAlign: TextAlign.center,
                    paddingTop: 14,
                    paddingBottom: 14,
                  ),
                  SocialButton(
                    buttonText: 'Google',
                    icon: Assets.imagesGoogleIcon,
                    onTap: () async {
                      await controller.registerUserWithGoogleAuth(
                          context: context);
                    },
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Visibility(
                    visible: Platform.isIOS,
                    child: SocialButton(
                      buttonText: 'Apple',
                      icon: Assets.imagesAppleIcon,
                      onTap: () async {
                        // await Get.find<SignUpController>()
                        //     .registerUserWithAppleAuth(context: context);

                        await Get.find<SignUpController>().registerUserWithAppleAuth(context: context);
                      },
                    ),
                  ),
                  const SizedBox(height: 5,),
                  GestureDetector(
                    onTap: () => Get.to(
                      () => Login(),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        MyText(
                          text: 'Already have an account?',
                          size: 12,
                          color: kDarkGreyColor,
                          weight: FontWeight.w500,
                        ),
                        MyText(
                          text: 'Sign in',
                          size: 12,
                          color: kBlueColor,
                          weight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
