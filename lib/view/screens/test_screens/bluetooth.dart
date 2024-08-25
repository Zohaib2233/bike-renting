import 'dart:developer';

import 'package:bike_gps/controllers/bluetooth/bluetooth_controller.dart';
import 'package:bike_gps/core/utils/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class BluetoothTestingScreen extends StatelessWidget {
  BluetoothTestingScreen({super.key});

  BLuetoothController bLuetoothController = Get.find<BLuetoothController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: ElevatedButton(
                  onPressed: () {
                    if (bLuetoothController.isBluetoothOn.value) {
                      bLuetoothController.scanBluetoothDevices();
                    } else {
                      CustomSnackBars.instance.showFailureSnackbar(
                          title: "Bluetooth Off",
                          message: "Please turn on the bluetooth!");
                    }
                  },
                  child: Text("Scan devices"))),
          ElevatedButton(
              onPressed: () async {
                await bLuetoothController.stopScanning();
              },
              child: Text("Stop scanning")),
          ElevatedButton(
              onPressed: () async {
                //connecting to device
                await bLuetoothController.connectToDevice();
              },
              child: Text("Connect to device")),
          ElevatedButton(
              onPressed: () {
                bLuetoothController.getBatteryPercentage();
              },
              child: Text("Get Battery percentage")),
        ],
      ),
    );
  }
}
