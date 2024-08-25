import 'dart:async';
import 'dart:io';

import 'package:bike_gps/core/utils/snackbars.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class PrivacyPolicyController extends GetxController {
  //get file from pdf url
  Future<File> createFileOfPdfUrl() async {
    //privacy policy pdf url (hosted on Firebase)
    String pdfUrl =
        "https://firebasestorage.googleapis.com/v0/b/knaap-app.appspot.com/o/privacy_policy%2F20240201%20-%20Knaap%20-%20Privacy%20Statement%20(external)%20(final)%20(clean).pdf?alt=media&token=9f070fae-961a-49be-9028-7bce818ca78a";

    Completer<File> completer = Completer();
    try {
      final url = pdfUrl;

      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();

      // log("Download files");
      // log("${dir.path}/$filename");

      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);

      completer.complete(file);
    } catch (e) {
      CustomSnackBars.instance.showFailureSnackbar(
          title: "Parsing Error", message: "Error parsing pdf file!");
    }

    return completer.future;
  }
}
