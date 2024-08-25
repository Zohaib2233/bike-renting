import 'package:bike_gps/controllers/auth/signup_controller.dart';

import 'package:bike_gps/core/constants/app_colors.dart';

import 'package:bike_gps/core/constants/app_images.dart';

import 'package:bike_gps/core/constants/app_sizes.dart';

import 'package:bike_gps/core/utils/snackbars.dart';

import 'package:bike_gps/core/utils/validators.dart';

import 'package:bike_gps/view/screens/user_profile/upload_bike_documents.dart';

import 'package:bike_gps/view/widget/drop_downs/my_custom_drop_down.dart';

import 'package:bike_gps/view/widget/headings_widget.dart';

import 'package:bike_gps/view/widget/my_button_widget.dart';

import 'package:bike_gps/view/widget/my_textfield_widget.dart';

import 'package:bike_gps/view/widget/simple_app_bar_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

// ignore: must_be_immutable
class BikeInformation extends StatelessWidget {
  BikeInformation({super.key});

  //finding SignUpController

  SignUpController controller = Get.find<SignUpController>();

  //creating form key

  final bikeFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Bike Setup',
        titleColor: kSecondaryColor,
        leadingIcon: Assets.imagesMenu,
        leadingIconSize: 12,
      ),
      body: Form(
        key: bikeFormKey,
        child: Column(
          children: [
            Padding(
              padding: AppSizes.HORIZONTAL,
              child: AuthHeading(
                title: 'Bike Information',
                subTitle: 'Enter your bike details to start.',
                textAlign: TextAlign.start,
                paddingTop: 15,
                paddingBottom: 0,
              ),
            ),
            Expanded(
              child: ListView(
                padding: AppSizes.DEFAULT,
                physics: BouncingScrollPhysics(),
                children: [
                  MyTextField(
                    labelText: 'Bike name',
                    hintText: 'Bike name',
                    controller: controller.bikeNameCtrlr,
                    validator: ValidationService.instance.emptyValidator,
                  ),
                  Obx(() => MyCustomDropDown(
                      hint: controller.selectedBikeType.value.isEmpty
                          ? 'Select bike'
                          : controller.selectedBikeType.value,
                      isSelected: controller.selectedBikeType.value.isNotEmpty,
                      heading: "Bike Type",
                      items: [
                        'City bike',
                        'Fat bike',
                      ],
                      onChanged: (v) {
                        controller.selectedBikeType.value = v;
                      })),
                  MyTextField(
                    labelText: 'Bike model',
                    hintText: 'Bike model',
                    controller: controller.bikeModelCtrlr,
                    validator: ValidationService.instance.emptyValidator,
                  ),
                  MyTextField(
                    labelText: 'Bike Colour',
                    hintText: 'Bike colour',
                    controller: controller.bikeColorCtrlr,
                    validator: ValidationService.instance.emptyValidator,
                  ),
                  MyTextField(
                    labelText: 'Frame number',
                    hintText: 'Frame number',
                    controller: controller.bikeFrameNoCtrlr,
                    validator: ValidationService.instance.emptyValidator,
                  ),
                  MyTextField(
                    labelText: 'IMEI',
                    hintText: 'Scan/Enter IMEI',
                    controller: controller.bikeIMEICtrlr,
                    validator: ValidationService.instance.imeiValidator,
                    inputFormatters: [LengthLimitingTextInputFormatter(15)],
                    keyboardType: TextInputType.number,
                    haveSuffix: true,
                    suffixIcon: Assets.imagesBarcodeScanIcon,
                    onSuffixTap: () {
                      //scanning IMEI
                      controller.scanIMEI();
                    },
                  ),
                  Obx(() => MyCustomDropDown(
                      hint: controller.isElectricBike.value ? 'Yes' : 'No',
                      heading: 'Electric bike',
                      items: [
                        'Yes',
                        'No',
                      ],
                      isSelected: true,
                      onChanged: (v) {
                        controller.handleBikeTypeSelection(userSelection: v);
                      })),
                ],
              ),
            ),
            Padding(
              padding: AppSizes.DEFAULT,
              child: MyButton(
                buttonText: 'Next',
                onTap: () {
                  if (bikeFormKey.currentState!.validate() &&
                      controller.selectedBikeType.value.isNotEmpty) {
                    Get.to(
                      () => UploadBikeDocuments(),
                    );
                  } else if (controller.selectedBikeType.value.isEmpty) {
                    CustomSnackBars.instance.showFailureSnackbar(
                        title: "Select Bike Type",
                        message: "Please select bike type");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
