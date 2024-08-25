import 'dart:io';

import 'package:bike_gps/config/routes/routes.dart';

import 'package:bike_gps/config/theme/light_theme.dart';

import 'package:bike_gps/core/bindings/bindings.dart';

import 'package:bike_gps/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GetStorage.init();

  //for solving HandshakeException while integrating APIs
  HttpOverrides.global = MyHttpOverrides();

  runApp(MyApp());
}

//DO NOT REMOVE Unless you find their usage.

String dummyImg =
    'https://images.unsplash.com/photo-1558507652-2d9626c4e67a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80';

String dummyPlaceImg =
    "https://firebasestorage.googleapis.com/v0/b/knaap-app.appspot.com/o/map_pin.png?alt=media&token=7975cab9-4042-4f83-a61d-5c3adeb9bcfa";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      title: 'KNAAP',
      theme: lightTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppLinks.splash_screen,
      getPages: AppRoutes.pages,
      defaultTransition: Transition.fadeIn,
      initialBinding: InitialBindings(),
    );
  }
}

//for solving HandshakeException while integrating APIs
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
