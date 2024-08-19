//
//
// import 'dart:ffi';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_tianyu_example/tianyu_controller.dart';
// import 'package:get/get.dart';
//
// class TianyuHomePage extends GetView<TianyuController> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Tianyu Plugin app'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Obx(() =>
//                       Text('Running on: ${controller.platformVersion}\n')),
//                 ],
//               ),
//               ElevatedButton(
//                   onPressed: controller.searchBluetoothDevice,
//                   child: const Text("Scan Device")),
//               ElevatedButton(
//                   onPressed: controller.connectTianyuDevice,
//                   child: const Text("Connect Tianyu device")),
//               ElevatedButton(
//                   onPressed: controller.disconnectDevice,
//                   child: const Text("Disconnect Tianyu device")),
//               ElevatedButton(
//                   onPressed: controller.readCard,
//                   child: const Text("Read card")),
//               ElevatedButton(
//                   onPressed: controller.cancelTransaction,
//                   child: const Text('Cancel Transaction')),
//               ElevatedButton(
//                   onPressed: controller.confirmTransaction,
//                   child: const Text('Confirm Transaction')),
//               ElevatedButton(
//                   onPressed: controller.clearLogs,
//                   child: const Text('Clear logs')),
//               Obx(() =>
//                   Visibility(
//                       visible: controller.isProcessing,
//                       child: const LinearProgressIndicator())),
//             ],
//           ),
//           Expanded(
//             child: Obx(() =>
//                 SingleChildScrollView(
//                   padding: const EdgeInsets.all(16),
//                   child: Text(controller.tianyuLogs),
//                 )),
//           ),
//         ],
//       ),
//     );
//   }
// }