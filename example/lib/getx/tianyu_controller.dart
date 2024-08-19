// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter_tianyu/flutter_tianyu.dart';
//
// class TianyuController extends GetxController {
//   var tianyuLogs = "".obs;
//   var isProcessing = false.obs;
//   var platformVersion = 'Unknown'.obs;
//   var initialized = false.obs;
//   var devicesList = <BluetoothDevice>[].obs;
//   late final FlutterTianyu flutterTianyuPlugin;
//
//   @override
//   void onInit() {
//     super.onInit();
//     flutterTianyuPlugin = FlutterTianyu(
//       onDisconnectedDevice: ({required isSuccess}) {
//         debugPrint("onDisconnectedDevice $isSuccess");
//         tianyuLogs.value += "\nonDisconnectedDevice $isSuccess";
//         isProcessing.value = false;
//       },
//       onConnectedDevice: ({required isSuccess}) {
//         debugPrint("onConnectedDevice $isSuccess");
//         tianyuLogs.value += "\nonConnectedDevice $isSuccess";
//         isProcessing.value = false;
//       },
//       onUpdateWorkingKey: ({required isSuccess}) {
//         debugPrint("onUpdateWorkingKey");
//         tianyuLogs.value += "\nonUpdateWorkingKey $isSuccess";
//         isProcessing.value = false;
//       },
//       onSelectICApplication: ({required list}) {
//         debugPrint("onSelectICApplication");
//         tianyuLogs.value += "\nonSelectICApplication $list";
//         isProcessing.value = false;
//       },
//       onReadCard: ({data}) {
//         debugPrint("onReadCard $data");
//         tianyuLogs.value += "\nonReadCard $data";
//         isProcessing.value = false;
//       },
//       onReadCardData: ({required data}) {
//         debugPrint("onReadCardData $data");
//         tianyuLogs.value += "\nonReadCardData $data";
//         isProcessing.value = false;
//       },
//       onDownGradeTransaction: ({required data}) {
//         debugPrint("onDownGradeTransaction");
//         tianyuLogs.value += "\nonDownGradeTransaction $data";
//         isProcessing.value = false;
//       },
//       onGetMacWithMKIndex: ({required data}) {
//         debugPrint("onGetMacWithMKIndex");
//         tianyuLogs.value += "\nonGetMacWithMKIndex $data";
//         isProcessing.value = false;
//       },
//       onPinBlockEntered: ({required data}) {
//         debugPrint("onPinBlockEntered");
//         isProcessing.value = false;
//       },
//       onGetPinBlock: ({required data}) {
//         debugPrint("onGetPinBlock");
//         tianyuLogs.value += "\nonGetPinBlock $data";
//         isProcessing.value = false;
//       },
//       onWaitingcard: () {
//         debugPrint("onWaitingcard");
//         tianyuLogs.value += "\nonGetPinBlock";
//         isProcessing.value = false;
//       },
//     );
//     initPlatformState();
//     startScan();
//   }
//
//   Future<void> initPlatformState() async {
//     String platformVersion;
//
//     try {
//       platformVersion = await flutterTianyuPlugin.getPlatformVersion() ??
//           'Unknown platform version';
//     } on PlatformException {
//       platformVersion = 'Failed to get platform version.';
//     }
//
//     this.platformVersion.value = platformVersion;
//   }
//
//   Future<bool> initTianyuDevice() async {
//     initialized.value = true;
//     final permissionCheck = await checkPermission();
//     if (!permissionCheck) {
//       Get.snackbar("Error", "Not allowed to initialize");
//       return false;
//     }
//     isProcessing.value = true;
//     tianyuLogs.value += "\nInitializing...";
//     initialized.value = await flutterTianyuPlugin.initDevice();
//     isProcessing.value = false;
//     tianyuLogs.value += "\nInitialized ${initialized.value}";
//     return initialized.value;
//   }
//
//   Future<bool> checkPermission() async {
//     final deviceInfo = DeviceInfoPlugin();
//     final androidInfo = await deviceInfo.androidInfo;
//     var bluetoothScanCheck = await Permission.bluetoothScan.isGranted;
//     if (androidInfo.version.sdkInt < 31) {
//       bluetoothScanCheck = true;
//     }
//     if (!bluetoothScanCheck) {
//       await Permission.bluetoothScan.request();
//       bluetoothScanCheck = await Permission.bluetoothScan.isGranted;
//     }
//     var bluetoothConnectCheck = await Permission.bluetoothConnect.isGranted;
//     if (!bluetoothConnectCheck) {
//       await Permission.bluetoothConnect.request();
//       bluetoothConnectCheck = await Permission.bluetoothConnect.isGranted;
//     }
//     var bluetoothAdvertiseCheck = await Permission.bluetoothAdvertise.isGranted;
//     if (androidInfo.version.sdkInt < 31) {
//       bluetoothAdvertiseCheck = true;
//     }
//     if (!bluetoothAdvertiseCheck) {
//       await Permission.bluetoothAdvertise.request();
//       bluetoothAdvertiseCheck = await Permission.bluetoothConnect.isGranted;
//     }
//     var findLocationCheck = await Permission.locationWhenInUse.isGranted;
//     if (!findLocationCheck) {
//       await Permission.locationWhenInUse.request();
//       findLocationCheck = await Permission.locationWhenInUse.isGranted;
//     }
//
//     var writeStorageCheck = true;
//
//     await Permission.phone.request();
//
//     return bluetoothScanCheck &&
//         findLocationCheck &&
//         bluetoothConnectCheck &&
//         bluetoothAdvertiseCheck &&
//         writeStorageCheck;
//   }
//
//   Future<void> connectTianyuDevice() async {
//     if (!initialized.value) {
//       final inited = await initTianyuDevice();
//       if (!inited) {
//         return;
//       }
//     }
//     final connected = await flutterTianyuPlugin.isConnected();
//     if (connected) {
//       return;
//     }
//     isProcessing.value = true;
//     tianyuLogs.value += "\nConnecting...";
//     await flutterTianyuPlugin.connectDevice(btAddress: "A2:E7:5A:BA:80:4C");
//   }
//
//   void disconnectDevice() async {
//     final cek = await flutterTianyuPlugin.isConnected();
//     if (!cek) {
//       isProcessing.value = false;
//       tianyuLogs.value += "\ndisconnected";
//       return;
//     }
//     isProcessing.value = true;
//     tianyuLogs.value += "\ndisconnecting...";
//     await flutterTianyuPlugin.disconnectDevice();
//     isProcessing.value = false;
//   }
//
//   Future<void> readCard() async {
//     bool showPinInput = false;
//     final cek = await flutterTianyuPlugin.isConnected();
//     if (!cek) {
//       await connectTianyuDevice();
//     }
//
//     isProcessing.value = true;
//     tianyuLogs.value += "\nReading...";
//
//     try {
//       await flutterTianyuPlugin.readCardWithTradeData(
//           amount: 10000, showPinInputStatus: showPinInput);
//       tianyuLogs.value += "\nRead Card Success";
//     } catch (e) {
//       tianyuLogs.value += "\nRead Card Failed";
//     }
//
//     isProcessing.value = false;
//   }
//
//   Future<void> confirmTransaction() async {
//     final cek = await flutterTianyuPlugin.isConnected();
//     if (!cek) {
//       await connectTianyuDevice();
//     }
//     isProcessing.value = true;
//     tianyuLogs.value += "\nConfirm";
//     await flutterTianyuPlugin.confirmTransaction();
//     isProcessing.value = false;
//   }
//
//   void clearLogs() {
//     tianyuLogs.value = "";
//   }
//
//   void cancelTransaction() {
//     isProcessing.value = true;
//     tianyuLogs.value += "\nCancel";
//     flutterTianyuPlugin.cancel();
//     isProcessing.value = false;
//   }
//
//   Future<void> searchBluetoothDevice() async {
//     List<BluetoothDevice> devicesList = [];
//     Map<String, BluetoothDevice> devicesMap = {};
//
//     FlutterBluePlus.scanResults.listen((results) {
//       for (ScanResult result in results) {
//         if (!devicesMap.containsKey(result.device.id.toString())) {
//           devicesList.add(result.device);
//           devicesMap[result.device.id.toString()] = result.device;
//         }
//       }
//     });
//
//     FlutterBluePlus.startScan(timeout: Duration(seconds: 10));
//
//     await Future.delayed(Duration(seconds: 10));
//
//     FlutterBluePlus.stopScan();
//
//     print('Devices found:');
//     for (int i = 0; i < devicesList.length; i++) {
//       print('${i + 1}. ${devicesList[i].name} (${devicesList[i].id})');
//     }
//
//     if (devicesList.isNotEmpty) {
//       BluetoothDevice selectedDevice = devicesList[0];
//       String btAddress = selectedDevice.id.toString();
//       print('Selected device: $btAddress');
//
//       await selectedDevice.connect();
//       print('Connected to $btAddress');
//     } else {
//       print('No devices found.');
//     }
//   }
//
//   void startScan() async {
//     FlutterBluePlus.scanResults.listen((results) {
//       for (ScanResult result in results) {
//         if (!devicesList.contains(result.device)) {
//           devicesList.add(result.device);
//         }
//       }
//     });
//
//     FlutterBluePlus.startScan(timeout: Duration(seconds: 10));
//
//     await Future.delayed(Duration(seconds: 10));
//
//     FlutterBluePlus.stopScan();
//   }
// }
