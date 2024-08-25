import 'package:bike_gps/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LicenseAgreement extends StatefulWidget {
  const LicenseAgreement({super.key});

  @override
  State<LicenseAgreement> createState() => _LicenseAgreementState();
}

class _LicenseAgreementState extends State<LicenseAgreement> {
  late WebViewController webController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(title: "Licese Agreement", haveLeading: true),
      body: WebViewWidget(controller: webController),
    );
  }
}
