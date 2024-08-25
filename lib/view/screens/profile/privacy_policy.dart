import 'dart:developer';
import 'dart:io';

import 'package:bike_gps/controllers/privacy_policy/privacy_policy_controller.dart';
import 'package:bike_gps/core/constants/app_colors.dart';
import 'package:bike_gps/core/constants/app_fonts.dart';
import 'package:bike_gps/view/widget/my_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class PrivacyPolicy extends StatelessWidget {
  PrivacyPolicy({super.key});

  //finding PrivacyPolicyController
  PrivacyPolicyController controller = Get.find<PrivacyPolicyController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: MyText(
          text: 'Privacy Policy',
          size: 18,
          weight: FontWeight.w700,
          fontFamily: AppFonts.DM_SANS,
        ),
      ),
      body: FutureBuilder<File>(
          future: controller.createFileOfPdfUrl(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              //if we got an error
              if (snapshot.hasError) {
                // showSnackbar(title: 'Error', msg: 'Try again');
              }
              //if we got the data
              else if (snapshot.hasData) {
                //getting snapshot data
                File file = snapshot.data!;

                return PDFView(
                  filePath: file.path,
                  enableSwipe: true,
                  swipeHorizontal: true,
                  autoSpacing: false,
                  pageFling: false,
                  onRender: (_pages) {},
                  onError: (error) {
                    log(error.toString());
                  },
                  onPageError: (page, error) {
                    log('$page: ${error.toString()}');
                  },
                  onViewCreated: (PDFViewController pdfViewController) {
                    // _controller.complete(pdfViewController);
                  },
                  // onPageChanged: (int page, int total) {
                  //   // print('page change: $page/$total');
                  // },
                );
              }
            }
            return Center(
                child: const CupertinoActivityIndicator(
              animating: true,
              radius: 20,
              color: kSecondaryColor,
            ));
          }),
    );
  }
}
