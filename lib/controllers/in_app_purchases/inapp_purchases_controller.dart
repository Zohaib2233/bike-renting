import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/models/offering_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class InAppPurchasesController extends GetxController {
  static const _googleRevenueCatKey = "goog_cFeORXcIlwzpvvIxOmULaVyIzgX";

  static const String _appleRevenueCatKey = "appl_jJAWQbHtowIqsTqtcXhOkgJQNBI";

  //packages list
  RxList<Package> packages = RxList<Package>([]);

  //selected subscription plan index
  RxInt selectedPlanIndex = RxInt(-1);

  //set selected subscription plan index
  set setSubscriptionPlanIndex(int index) {
    selectedPlanIndex.value = index;
  }

  //init purchases and get plans
  void init() async {
    await _initPurchases();

    await _fetchOffers();
  }

  Future _initPurchases() async {
    // await Purchases.setDebugLogsEnabled(true);

    // await Purchases.setup(_apiKey);

    //getting Firebase user Id
    String _userId = FirebaseAuth.instance.currentUser!.uid;

    if (Platform.isAndroid) {
      await Purchases.configure(
        PurchasesConfiguration(_googleRevenueCatKey)
          ..appUserID =
              _userId, //setting user id (for handling app uninstallation scenarios)
      );
    } else if (Platform.isIOS) {
      await Purchases.configure(
        PurchasesConfiguration(_appleRevenueCatKey)
          ..appUserID =
              _userId, //setting user id (for handling app uninstallation scenarios)
      );
    }
  }

  //method to get subscriptions plans
  Future<void> _fetchOffers() async {
    try {
      final offerings = await Purchases.getOfferings();

      final current = offerings.current;

      List<Offering> plans = current == null ? [] : [current];

      //making a list of packages
      packages.value = plans
          .map((offer) => offer.availablePackages)
          .expand((pair) => pair)
          .toList();
    } catch (e) {
      log("This exception occurred while getting offers: $e");
    }
  }

  //method to purchase a plan
  Future<void> purchasePlan({required Package package}) async {
    try {
      //getting Firebase user Id
      String _userId = FirebaseAuth.instance.currentUser!.uid;

      //logging in user with the Firebase user id on Revenuecat
      await Purchases.logIn(_userId);

      await Purchases.purchasePackage(package);

      //resetting selected subscription plan index
      selectedPlanIndex = RxInt(-1);
    } catch (e) {
      log("This exception occurred while purchasing a plan: $e");
    }
  }

  //method to get customer info
  //this will return customer all the entitlements (including inactive entitlements)
  Future<Map> _getCustomerEntitlements() async {
    try {
      //getting Firebase user Id
      String _userId = FirebaseAuth.instance.currentUser!.uid;

      //logging in user with the Firebase user id on Revenuecat
      LogInResult _loginResult = await Purchases.logIn(_userId);

      CustomerInfo customerInfo = _loginResult.customerInfo;

      Map customerEntitlements = customerInfo.entitlements.all;

      return customerEntitlements;
    } catch (e) {
      log("This exception occurred while getting customer info: $e");

      return {};
    }
  }

  //method to get customer active entitlements
  //this will return only active entitlements
  Future<List<EntitlementInfo>> getCustomerActiveEntitlements() async {
    List<EntitlementInfo> _activeEntitlements = [];

    try {
      Map customerEntitlements = await _getCustomerEntitlements();

      //iterating through entitlements
      if (customerEntitlements.isNotEmpty) {
        customerEntitlements.forEach((key, entitlement) {
          //checking if the entitlement is active
          if (entitlement.isActive) {
            _activeEntitlements.add(entitlement);
          }
        });
      }

      return _activeEntitlements;

      // DateTime now = DateTime.now();

      // DateTime? expirationDate = DateFormatters.instance
      //     .convertStringIntoDateTime(
      //         activeEntitlements.first.expirationDate ?? "");

      // int difference = DateFormatters.instance
      //     .getTimeDifferenceInSec(start: expirationDate!, end: now);

      // log("Entitlement expiration date: ${expirationDate}");
      // log("Now date: $now");

      // log("difference: ${expirationDate!.isBefore(now)}");
    } catch (e) {
      log("This exception occurred while getting active entitlements: $e");

      return _activeEntitlements;
    }
  }

  //method to check if the user has purchased a subscription
  Future<bool> hasSubscribed() async {
    try {
      List<EntitlementInfo> _activeEntitlements =
          await getCustomerActiveEntitlements();

      if (_activeEntitlements.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
  }
}
