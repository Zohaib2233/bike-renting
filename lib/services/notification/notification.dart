import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  //private constructor
  NotificationService._privateConstructor();

  //singleton instance variable
  static NotificationService? _instance;

  //This code ensures that the singleton instance is created only when it's accessed for the first time.
  //Subsequent calls to NotificationService.instance will return the same instance that was created before.

  //getter to access the singleton instance
  static NotificationService get instance {
    _instance ??= NotificationService._privateConstructor();
    return _instance!;
  }

  //method to get user device token for Firebase push notifications
  Future<String> getDeviceToken() async {
    String? token;
    try {
      token = await FirebaseMessaging.instance.getToken();
    } catch (e) {
      log("This was the exception while getting device token: $e");
    }
    if (token != null) {
      return token;
    }
    return "";
  }
}
