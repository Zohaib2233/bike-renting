import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:bike_gps/core/enums/bluetooth_permission.dart';
import 'package:bike_gps/core/utils/permissions/permissions.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class BLuetoothController extends GetxController {
  //bluetooth permission status
  BluetoothPermissionStatus _bluetoothPermissionStatus =
      BluetoothPermissionStatus.unknown;

  //bluetooth adapter stream subscription
  StreamSubscription<BluetoothAdapterState>? _bluetoothAdapterStream;

  //scanned bluetooth devices list
  StreamSubscription<List<ScanResult>>? _scannedDevicesStream;

  //flag to check if the bluetooth is on/off
  RxBool isBluetoothOn = false.obs;

  //method to get bluetooth permission status
  Future<void> getBluetoothPermission() async {
    //getting bluetooth permission status
    _bluetoothPermissionStatus =
        await PermissionService.instance.getBluetoothPermissionStatus();
  }

  //method to get bluetooth state
  void bluetoothStateListener() {
    _bluetoothAdapterStream =
        FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      log("state: $state");
      if (state == BluetoothAdapterState.on) {
        // usually start scanning, connecting, etc
        log("BLuetooth is turned on");
        isBluetoothOn.value = true;
      } else {
        // show an error to the user, etc
        log("BLuetooth is turned off");
        isBluetoothOn.value = false;
      }
    });
  }

  int calculateCRC16(List<int> data) {
    var crc = 0xFFFF;

    for (var b in data) {
      crc ^= b;

      for (var i = 0; i < 8; i++) {
        if ((crc & 0x0001) != 0) {
          crc >>= 1;
          crc ^= 0xA001;
        } else {
          crc >>= 1;
        }
      }
    }

    return crc;
  }

  List<int> constructCommandWithCrc() {
    List<int> commandWithoutCrc = [0x5A, 0x00, 0x3F, 0x01, 0x00];
    int crc = calculateCRC16(commandWithoutCrc);

    // Split CRC into two bytes and use Big-Endian format
    Uint8List crcBytes = Uint8List(2);

    crcBytes[0] = (crc >> 8) & 0xFF;
    crcBytes[1] = crc & 0xFF;

    List<int> fullCommand = List.from(commandWithoutCrc)
      ..addAll(crcBytes)
      ..add(0xA5);
    return fullCommand;
  }

  List<ScanResult> scannedDevices = [];

  List<BluetoothCharacteristic> availableCharacteristics = [];

  //required device to connect (this will be the bike display device)
  BluetoothDevice deviceToConnect =
      BluetoothDevice(remoteId: DeviceIdentifier(""));

  //method to connect to the device
  Future<void> connectToDevice() async {
    try {
      for (ScanResult dev in scannedDevices) {
        // log("scannedDevice: ${dev.device.platformName}");
        if (dev.device.platformName == "ANBLE4738") {
          // await dev.device.connect();
          deviceToConnect = dev.device;
        }
      }

      await deviceToConnect.connect();
    } catch (e) {
      log("This was the exception while connecting to device: $e");
    }
  }

  //method to get device services
  Future<List<BluetoothService>> getDeviceServices() async {
    List<BluetoothService> services = [];

    try {
      services = await deviceToConnect.discoverServices();

      return services;
    } catch (e) {
      return services;
    }
  }

  //method to get device required characteristics
  List<BluetoothCharacteristic> getDeviceReqCharacteristics(
      {required List<BluetoothService> deviceServices}) {
    List<BluetoothCharacteristic> characteristics = [];

    for (BluetoothService service in deviceServices) {
      // BluetoothService requiredService = service;

      // characteristics = requiredService.characteristics;

      // availableCharacteristics.add(requiredService.characteristics);
      if (service.serviceUuid == Guid("4e300001-a2bb-dc65-33c2-e43536bccb9e")) {
        // availableCharacteristics = [];

        // BluetoothService requiredService = service;

        characteristics = service.characteristics;
      }
    }

    return characteristics;
  }

  //method to get characteristics
  void getCharacteristics() async {
    try {
      List<BluetoothService> services =
          await deviceToConnect.discoverServices();

      // Reads all characteristics
      List<BluetoothCharacteristic> characteristics = [];

      // services.forEach((element) {
      //   log("service uuid: ${element.serviceUuid}");
      // });

      for (BluetoothService service in services) {
        availableCharacteristics = [];

        BluetoothService requiredService = service;

        availableCharacteristics = requiredService.characteristics;

        // availableCharacteristics.add(requiredService.characteristics);
        if (service.serviceUuid ==
            Guid("4e300001-a2bb-dc65-33c2-e43536bccb9e")) {
          availableCharacteristics = [];

          BluetoothService requiredService = service;

          availableCharacteristics = requiredService.characteristics;
        }
      }

      log("availableCharacteristics length: ${availableCharacteristics.length}");

      // log("availableCharacteristics: $availableCharacteristics");

      for (BluetoothCharacteristic characteristic in availableCharacteristics) {
        log("Properties: ${characteristic.properties}");
      }

      // Convert the hex values to bytes
      List<int> command = [0x60]; // Command
      List<int> data = [0x00]; // Data

      // Combine command and data into one List<int>
      // List<int> combinedData = [...command, ...data];

      // log("availableCharacteristics.first: ${availableCharacteristics.first}");

      // // Construct your command with CRC
      // List<int> formattedCommand = constructCommandWithCrc();

      // log("formattedCommand: $formattedCommand");

      // Write the value to the characteristic
      List<int> combinedData = [...command, ...data];
      await availableCharacteristics.first.write(combinedData);
      availableCharacteristics.first.setNotifyValue(true);
      availableCharacteristics.first.lastValueStream.listen((value) {
        log('Received data: $value');
        // Process the received data here
      });
      // List availableRead = await availableCharacteristics.first.read();

      // log("availableRead: $availableRead");
      // await availableCharacteristics.first.write([0x21, 0x01]);
      // log('Command sent: $combinedData');

      // Listen for notifications from the notify characteristic
      // availableCharacteristics.first.setNotifyValue(true);
      // availableCharacteristics.first.lastValueStream.listen((value) {
      //   log('Received data: $value');
      //   // Process the received data here
      // });

      // for (BluetoothService service in services) {
      //   characteristics = [];

      //   characteristics.addAll(service.characteristics);

      //   log("service uuid: ${service.uuid}");

      //   for (BluetoothCharacteristic c in characteristics) {
      //     if (c.properties.read) {
      //       log("characteristic properties: ${c.properties}");
      //       List<int> value = await c.read();
      //       log("read property: $value");
      //     }
      //   }
      // }

      // services.forEach((service) {
      //   // do something with service
      //   log("service: $service");
      // });
    } catch (e) {
      log("This exception occurred while discovering services: $e");
    }
  }

  //method to convert hex list into int list
  List<int> hexListToIntList(List<int> hexList) {
    return hexList.map((hex) => hex).toList();
  }

  //method to calculate checksum
  int createChecksum(List<int> command) {
    int checksum = command.fold(0, (sum, element) => sum + element);

    return checksum;
  }

  //method to get battery percentage
  void getBatteryPercentage() async {
    try {
      //list of characteristics that support read properties
      List<BluetoothCharacteristic> readSupportedCharacteristics = [];
      // //connecting to device
      // await connectToDevice();

      //getting device services
      List<BluetoothService> deviceServices = await getDeviceServices();

      // log("deviceServices: $deviceServices");

      // for (BluetoothService service in deviceServices) {
      //   List<BluetoothCharacteristic> _characteristics =
      //       service.characteristics;

      //   for (BluetoothCharacteristic characteristic in _characteristics) {
      //     log("characteristic: $characteristic");
      //     if (characteristic.properties.read) {
      //       readSupportedCharacteristics.add(characteristic);
      //     }
      //   }
      // }

      // log("readSupportedCharacteristics: ${readSupportedCharacteristics.length}");

      //getting service characteristics
      List<BluetoothCharacteristic> deviceReqCharacteristics =
          getDeviceReqCharacteristics(deviceServices: deviceServices);

      //required characteristic for sending commands
      BluetoothCharacteristic? requiredCharacteristic;

      int i = 1;
      for (BluetoothCharacteristic char in deviceReqCharacteristics) {
        // log("--------------------------------------------------------");
        // log("Characteristic $i: $char");
        // log("--------------------------------------------------------");
        // i++;
        if (char.characteristicUuid ==
            Guid("4e3000a1-a2bb-dc65-33c2-e43536bccb9e")) {
          requiredCharacteristic = char;
        }
      }

      // // Replace the following UUID with the service and characteristic UUIDs of your Bluetooth device
      // // BluetoothCharacteristic characteristic = await targetDevice!
      // //     .writeCharacteristic(
      // //       Guid('0000fff0-0000-1000-8000-00805f9b34fb'), // Service UUID
      // //       Guid('0000fff1-0000-1000-8000-00805f9b34fb'), // Characteristic UUID
      // //       [0x5A, 0x00, 0x01, 0xf0, 0x01, 0x00, 0x5B, 0x4C, 0xA5], // Command bytes
      // //     );

      // log("requiredCharacteristic: ${requiredCharacteristic}");
      // List<int> command = [0x1f]; // Command
      // List<int> data = [0x00]; // Data

      // List<int> combinedData = [...command, ...data];
      // // List<int> combinedData = [5A001f01005B4CA5];
      // // await requiredCharacteristic!.write(combinedData);
      // List<int> commandToSend = [0x1f, 0x00];
      // log("commandToSend: $commandToSend");
      // // await requiredCharacteristic!.write(commandToSend);

      // log("characteristic UUID: ${readSupportedCharacteristics.first}");

      // await readSupportedCharacteristics.first.setNotifyValue(true);

      // await readSupportedCharacteristics.first.write(
      //   commandToSend,
      // );

      // // await readSupportedCharacteristics.first.read();

      // await readSupportedCharacteristics.first.onValueReceived.listen((event) {
      //   log("value received: $event");
      // });

      // await readSupportedCharacteristics.first.lastValueStream.listen((val) {
      //   log("received data: $val");
      // });

      // await requiredCharacteristic!.read();
      // await requiredCharacteristic!
      //     .write([0x5A, 0x00, 0x01, 0xf0, 0x01, 0x00, 0x5B, 0x4C, 0xA5]);

      // await requiredCharacteristic!.write([0x1f, 0x00]);

      log("--------------------------------------------------------");

      log("requiredCharacteristic uuid: ${requiredCharacteristic!.uuid}");

      log("--------------------------------------------------------");

      List<int> commandData = [0x1f, 0x00];

      List<int> partialCmd = [0x5A, 0x00, 0x1f, 21, 08];

      int checksum = createChecksum(partialCmd);

      log("command without checksum: $partialCmd");

      log("checksum: $checksum");

      //adding checksum in partialCmd
      partialCmd.add(checksum);

      //adding end field in partialCmd
      partialCmd.add(0xA5);

      log("command with checksum: $partialCmd");

      List<int> cmd = [01, 0xA5];

      List intCmd = hexListToIntList(cmd);

      log("hex command: $cmd");

      log("int command: $intCmd");

      await requiredCharacteristic.write(partialCmd);
      requiredCharacteristic.setNotifyValue(true);
      requiredCharacteristic.onValueReceived.listen((event) {
        log("value received: $event");
      });

      requiredCharacteristic.lastValueStream.listen((value) {
        log('Received data: $value');
      });
    } catch (e) {
      log("This was the exception while getting battery percentage: $e");
    }
  }

  //method to scan for bluetooth devices
  void scanBluetoothDevices() async {
    log("scanning bluetooth devices");

    scannedDevices = [];

    await FlutterBluePlus.startScan(
        withServices: [Guid("4e300001-a2bb-dc65-33c2-e43536bccb9e")]);

    _scannedDevicesStream = FlutterBluePlus.scanResults.listen(
      (results) {
        if (results.isNotEmpty) {
          for (ScanResult scanResult in results) {
            log("scanResult: ${scanResult.device}");

            scannedDevices.add(scanResult);
          }
          // ScanResult r = results.last; // the most recently found device
          // log('remote id: ${r.device.remoteId}: advertisementData: "${r.advertisementData.advName}" found!');
        }
      },
      onError: (e) => log(e),
    );
  }

  //method to stop scanning
  Future<void> stopScanning() async {
    await FlutterBluePlus.stopScan();
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();

    //getting bluetooth permission status
    await getBluetoothPermission();

    //bluetooth adapter state listener
    bluetoothStateListener();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();

    if (_bluetoothAdapterStream != null) {
      _bluetoothAdapterStream!.cancel();
    }

    if (_scannedDevicesStream != null) {
      _scannedDevicesStream!.cancel();
    }
  }
}
