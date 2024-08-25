import 'package:bike_gps/controllers/auth/forgot_password_controller.dart';
import 'package:bike_gps/controllers/auth/login_controller.dart';
import 'package:bike_gps/controllers/auth/signup_controller.dart';
import 'package:bike_gps/controllers/bike/find_bike_controller.dart';
import 'package:bike_gps/controllers/bluetooth/bluetooth_controller.dart';
import 'package:bike_gps/controllers/bottom_nav_bar/bottom_nav_bar_controller.dart';
import 'package:bike_gps/controllers/community/community_controller.dart';
import 'package:bike_gps/controllers/community/community_detail_controller.dart';
import 'package:bike_gps/controllers/friends_controller/friends_controller.dart';
import 'package:bike_gps/controllers/home/home_controller.dart';
import 'package:bike_gps/controllers/home/ride_stats_controller.dart';
import 'package:bike_gps/controllers/in_app_purchases/inapp_purchases_controller.dart';
import 'package:bike_gps/controllers/launch/splash_screen_controller.dart';
import 'package:bike_gps/controllers/places/places_controller.dart';
import 'package:bike_gps/controllers/privacy_policy/privacy_policy_controller.dart';
import 'package:bike_gps/controllers/profile/profile_controller.dart';
import 'package:bike_gps/controllers/profile/user_fav_posts_controller.dart';
import 'package:bike_gps/services/firebase/firebase_authentication.dart';
import 'package:get/get.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<SignUpController>(SignUpController());
    Get.put<LoginController>(LoginController());
    Get.put<FirebaseAuthService>(FirebaseAuthService());
    Get.put<SplashScreenController>(SplashScreenController());

    //controllers that should must be initialized throughout the app lifecycle
    Get.put<HomeController>(HomeController());
    Get.put<PlacesController>(PlacesController());

    Get.put<BottomNavBarController>(BottomNavBarController());
    Get.put<CommunityController>(CommunityController());

    Get.put<RideStatsController>(RideStatsController());

    Get.put<InAppPurchasesController>(InAppPurchasesController());
  }
}

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<ProfileController>(ProfileController());
  }
}

class BluetoothBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<BLuetoothController>(BLuetoothController());
  }
}

class FindBikeBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<FindBikeController>(FindBikeController());
  }
}

class FriendsBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<FriendsController>(FriendsController());
  }
}

class CommunityBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<CommunityController>(CommunityController());
  }
}

class CommunityDetailBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<CommunityDetailController>(CommunityDetailController());
  }
}

class UserFavPostBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<UserFavPostsController>(UserFavPostsController());
  }
}

class PrivacyBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<PrivacyPolicyController>(PrivacyPolicyController());
  }
}

class ForgotPasswordBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<ForgotPasswordController>(ForgotPasswordController());
  }
}

class LogoutBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<SignUpController>(SignUpController());
    Get.put<LoginController>(LoginController());
    Get.put<FirebaseAuthService>(FirebaseAuthService());
  }
}
