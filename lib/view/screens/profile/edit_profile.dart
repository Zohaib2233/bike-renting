import 'package:bike_gps/controllers/profile/profile_controller.dart';
import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_fonts.dart';
import 'package:bike_gps/core/constants/app_images.dart';
import 'package:bike_gps/core/constants/app_sizes.dart';
import 'package:bike_gps/core/constants/instances_constants.dart';
import 'package:bike_gps/core/utils/validators.dart';
import 'package:bike_gps/view/screens/profile/subscriptions/add_card.dart';
import 'package:bike_gps/view/widget/my_button_widget.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:bike_gps/view/widget/my_textfield_widget.dart';
import 'package:country_picker/country_picker.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class EditProfile extends StatelessWidget {
  EditProfile({super.key});

  //finding ProfileController
  ProfileController controller = Get.find<ProfileController>();

  final List<String> languages = [
    'English',
    'German',
    'Portuguese',
    'French',
    'Italian',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: MyText(
          text: 'Profile',
          size: 18,
          weight: FontWeight.w700,
          fontFamily: AppFonts.DM_SANS,
        ),
      ),
      body: ListView(
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        children: [
          Visibility(
            visible: userModelGlobal.value.isSocialSignIn == false,
            child: _CustomExpandable(
              title: 'Change Mail and Phone no',
              child: Column(
                children: [
                  //email and password form (for validating form individually)
                  Form(
                    key: controller.emailFormKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          label: 'Email',
                          hint: 'johndoe@gmail.com',
                          controller: controller.emailCtrlr,
                          validator: ValidationService.instance.emailValidator,
                          onChanged: (val) {
                            controller.handleEmailFieldAction();
                          },
                          marginBottom: 15,
                        ),
                        Obx(() => Visibility(
                              visible: controller.isEmailFilled.value,
                              child: CustomTextField(
                                label: 'Password',
                                hint: 'Enter your current password',
                                isObSecure: true,
                                controller: controller.pwdCtrlr,
                                validator:
                                    ValidationService.instance.emptyValidator,
                                marginBottom: 15,
                              ),
                            )),
                      ],
                    ),
                  ),
                  Obx(() => MyPhoneField(
                        label: 'Phone Number',
                        hint: userModelGlobal.value.phoneNo!,
                        marginBottom: 17,
                        phoneCode: controller.selectedPhoneCode.value,
                        controller: controller.phoneCtrlr,
                        onCountrySelect: (Country country) {
                          controller.selectedPhoneCode.value =
                              "+" + country.phoneCode;
                        },
                      )),
                  Obx(() => MyButton(
                        buttonText: 'Save changes',
                        showLoading: controller.isProfileUpdating.value,
                        onTap: () async {
                          if (controller.phoneCtrlr.text.isNotEmpty &&
                              controller.isProfileUpdating.value == false) {
                            await controller.updateUserPhone();
                          }

                          if (controller.emailFormKey.currentState!
                                  .validate() &&
                              controller.isProfileUpdating.value == false) {
                            await controller.updateUserEmail();
                          }
                        },
                      )),
                ],
              ),
            ),
          ),
          Form(
            key: controller.pwdFormKey,
            child: Visibility(
              visible: userModelGlobal.value.isSocialSignIn == false,
              child: _CustomExpandable(
                title: 'Change Password',
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Current Password',
                      hint: 'Your current password',
                      controller: controller.pwdCtrlr,
                      validator: ValidationService.instance.emptyValidator,
                      isObSecure: true,
                      marginBottom: 10,
                    ),
                    CustomTextField(
                      label: 'New Password',
                      hint: 'Set a password',
                      controller: controller.newPwdCtrlr,
                      validator: ValidationService.instance.validatePassword,
                      isObSecure: true,
                      marginBottom: 10,
                    ),
                    CustomTextField(
                      label: 'Confirm Password',
                      hint: 'Retype your password',
                      validator: (value) => ValidationService.instance
                          .validateMatchPassword(
                              value!, controller.newPwdCtrlr.text),
                      isObSecure: true,
                      marginBottom: 21,
                    ),
                    Obx(() => MyButton(
                          buttonText: 'Save changes',
                          showLoading: controller.isProfileUpdating.value,
                          onTap: () async {
                            if (controller.pwdFormKey.currentState!
                                    .validate() &&
                                controller.isProfileUpdating.value == false) {
                              await controller.updateUserPassword();
                            }
                          },
                        )),
                  ],
                ),
              ),
            ),
          ),
          // _CustomExpandable(
          //   title: 'Change Language',
          //   child: Column(
          //     children: List.generate(
          //       languages.length,
          //       (index) {
          //         return _LanguageTile(
          //           title: languages[index],
          //           isSelected: index == 0 ? true : false,
          //           onTap: () {},
          //         );
          //       },
          //     ),
          //   ),
          // ),
          _CustomExpandable(
            title: 'Notification',
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: MyText(
                        text: 'Show Notification',
                        color: kBlackColor,
                      ),
                    ),
                    Obx(() => FlutterSwitch(
                          height: 20,
                          width: 38,
                          toggleSize: 16,
                          activeColor: kSecondaryColor,
                          padding: 2,
                          value: controller.isShowNotification.value,
                          onToggle: (v) async {
                            await controller.handleShowNotification();
                          },
                        )),
                  ],
                ),
                // SizedBox(
                //   height: 30,
                // ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: MyText(
                //         text: 'Notification xyz',
                //         color: kBlackColor,
                //       ),
                //     ),
                //     FlutterSwitch(
                //       height: 20,
                //       width: 38,
                //       toggleSize: 16,
                //       activeColor: kSecondaryColor,
                //       padding: 2,
                //       value: false,
                //       onToggle: (v) {},
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
          //change device IMEI
          _CustomExpandable(
            title: 'Change IMEI',
            child: Form(
              key: controller.imeiFormKey,
              child: Column(
                children: [
                  MyTextField(
                    labelText: 'IMEI',
                    hintText: 'Scan/Enter IMEI',
                    controller: controller.bikeIMEICtrlr,
                    inputFormatters: [LengthLimitingTextInputFormatter(15)],
                    validator: ValidationService.instance.imeiValidator,
                    keyboardType: TextInputType.number,
                    haveSuffix: true,
                    suffixIcon: Assets.imagesBarcodeScanIcon,
                    onSuffixTap: () {
                      //scanning IMEI
                      controller.scanIMEI();
                    },
                  ),
                  Obx(() => MyButton(
                        buttonText: 'Save changes',
                        showLoading: controller.isProfileUpdating.value,
                        onTap: () async {
                          if (controller.imeiFormKey.currentState!.validate() &&
                              controller.isProfileUpdating.value == false) {
                            controller.updateDeviceIMEI();
                          }
                        },
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class MyPhoneField extends StatefulWidget {
  MyPhoneField({
    Key? key,
    this.controller,
    this.hint,
    this.label,
    this.onChanged,
    this.marginBottom = 14.0,
    this.validator,
    required this.onCountrySelect,
    required this.phoneCode,
  }) : super(key: key);
  String? label, hint;

  TextEditingController? controller;
  ValueChanged<String>? onChanged;
  double? marginBottom;
  FormFieldValidator<String>? validator;
  final String phoneCode;

  void Function(Country) onCountrySelect;

  @override
  State<MyPhoneField> createState() => _MyPhoneFieldState();
}

class _MyPhoneFieldState extends State<MyPhoneField> {
  Color fillColor = kPrimaryColor;

  // String countryFlag = '🇺🇦';
  // String countryFlag = '🇦🇽';
  // String countryCode = '+123';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.marginBottom!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyText(
            text: widget.label!,
            size: 10,
            color: kTertiaryColor,
            paddingBottom: 2,
          ),
          TextFormField(
            validator: widget.validator,
            keyboardType: TextInputType.phone,
            cursorColor: kTertiaryColor,
            controller: widget.controller,
            onChanged: widget.onChanged,
            textInputAction: TextInputAction.next,
            style: TextStyle(
              fontSize: 12,
              color: kTertiaryColor,
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.DM_SANS,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              hintText: widget.hint,
              hintStyle: TextStyle(
                fontSize: 15,
                color: kHintColor,
                fontFamily: AppFonts.DM_SANS,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => showCountryPicker(
                        context: context,
                        exclude: <String>['KN', 'MF'],
                        showPhoneCode: true,
                        onSelect: widget.onCountrySelect,
                        // onSelect: (Country country) {
                        //   print('Select country: ${country.displayName}');
                        //   setState(() {
                        //     log("country.flagEmoji: ${country.flagEmoji}");
                        //     log("country.countryCode: ${country.countryCode}");

                        //     String flagASCII =
                        //         countryCodeToEmoji(country.countryCode);

                        //     log("flagASCII: $flagASCII");

                        //     countryFlag = country.flagEmoji;
                        //     countryCode = country.phoneCode;
                        //   });
                        // },
                        countryListTheme: CountryListThemeData(
                          textStyle: TextStyle(
                            fontSize: 15,
                            color: kTertiaryColor,
                            fontFamily: AppFonts.DM_SANS,
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                          // Optional. Styles the search field.
                          inputDecoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            hintText: 'Search',
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: kHintColor,
                              fontFamily: AppFonts.DM_SANS,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: kInputBorderColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: kInputBorderColor,
                              ),
                            ),
                          ),
                          bottomSheetHeight:
                              MediaQuery.of(context).size.height * 0.7,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MyText(
                            // text: '$countryFlag',
                            text: '${widget.phoneCode}',
                            size: 15,
                            color: kTertiaryColor,
                            weight: FontWeight.w500,
                          ),
                          Image.asset(
                            Assets.imagesArrowDropDown,
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: kInputBorderColor,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: kInputBorderColor,
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

class _LanguageTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  const _LanguageTile({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.58),
        border: Border.all(
          color: kLightGreyColor4,
          width: 0.87,
        ),
      ),
      child: MyRippleEffect(
        onTap: onTap,
        splashColor: kBlackColor.withOpacity(0.1),
        radius: 3.49,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 12,
                  height: 12,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? kBlueColor : kLightGreyColor5,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: AnimatedContainer(
                            width: Get.height,
                            height: Get.width,
                            duration: Duration(
                              microseconds: 200,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kBlueColor,
                            ),
                          ),
                        )
                      : SizedBox(),
                ),
              ),
              Expanded(
                child: MyText(
                  text: title,
                  size: 13.53,
                  color: kBlackColor,
                  weight: FontWeight.w500,
                  paddingLeft: 16,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomExpandable extends StatelessWidget {
  final String title;
  final Widget child;
  const _CustomExpandable({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 21,
      ),
      child: ExpandablePanel(
        theme: ExpandableThemeData(
          headerAlignment: ExpandablePanelHeaderAlignment.center,
          iconColor: kTextColor5,
          iconSize: 18,
        ),
        header: MyText(
          text: title,
          size: 14.62,
          weight: FontWeight.w700,
          fontFamily: AppFonts.DM_SANS,
        ),
        collapsed: SizedBox(),
        expanded: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: child,
        ),
      ),
    );
  }
}

String countryCodeToEmoji(String countryCode) {
  // 0x41 is Letter A
  // 0x1F1E6 is Regional Indicator Symbol Letter A
  // Example :
  // firstLetter U => 20 + 0x1F1E6
  // secondLetter S => 18 + 0x1F1E6
  // See: https://en.wikipedia.org/wiki/Regional_Indicator_Symbol
  final int firstLetter = countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
  final int secondLetter = countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;
  return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
}
