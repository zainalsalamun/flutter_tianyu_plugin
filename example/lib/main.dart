// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:flutter_tianyu/flutter_tianyu.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _tianyuLogs = "";
  bool _isProcessing = false;
  String btAddress = "";

  late final FlutterTianyu _flutterTianyuPlugin;

  String _platformVersion = 'Unknown';

  bool _innitialized = false;

  bool _initialized = false;

  bool get isProcessing => _isProcessing;
  String get tianyuLogs => _tianyuLogs;

  List<BluetoothDevice> _devicesList = [];

  @override
  void initState() {
    super.initState();
    _flutterTianyuPlugin = FlutterTianyu(
      onDisconnectedDevice: ({required isSuccess}) {
        debugPrint("onDisconnectedDevice $isSuccess");
        setState(() {
          _tianyuLogs += "\nonDisconnectedDevice $isSuccess";
          _isProcessing = false;
        });
      },
      onConnectedDevice: ({required isSuccess}) {
        debugPrint("onConnectedDevice $isSuccess");

        setState(() {
          _tianyuLogs += "\nonConnectedDevice $isSuccess";
          _isProcessing = false;
        });
      },
      onUpdateWorkingKey: ({required isSuccess}) {
        debugPrint("onUpdateWorkingKey");
        setState(() {
          _tianyuLogs += "\nonUpdateWorkingKey $isSuccess";
          _isProcessing = false;
        });
      },
      onSelectICApplication: ({required list}) {
        debugPrint("onSelectICApplication");
        setState(() {
          _tianyuLogs += "\nonSelectICApplication $list";
          _isProcessing = false;
        });
      },
      onReadCard: ({data}) {
        debugPrint("onReadCard $data");
        setState(() {
          _tianyuLogs += "\nonReadCard $data";
          _isProcessing = false;
        });
      },
      onReadCardData: ({required data}) {
        debugPrint("onReadCardData $data");
        setState(() {
          _tianyuLogs += "\nonReadCardData $data";
          _isProcessing = false;
        });
      },
      onDownGradeTransaction: ({required data}) {
        debugPrint("onDownGradeTransaction");
        setState(() {
          _tianyuLogs += "\nonDownGradeTransaction $data";
          _isProcessing = false;
        });
      },
      onGetMacWithMKIndex: ({required data}) {
        debugPrint("onGetMacWithMKIndex");
        setState(() {
          _tianyuLogs += "\nonGetMacWithMKIndex $data";
          _isProcessing = false;
        });
      },
      onPinBlockEntered: ({required data}) {
        setState(() {
          debugPrint("onPinBlockEntered");
          _isProcessing = false;
        });
      },
      onGetPinBlock: ({required data}) {
        debugPrint("onGetPinBlock");
        setState(() {
          _tianyuLogs += "\nonGetPinBlock $data";
          _isProcessing = false;
        });
      },
      onWaitingcard: () {
        debugPrint("onWaitingcard");
        setState(() {
          _tianyuLogs += "\nonGetPinBlock";
          _isProcessing = false;
        });
      },
    );
    initPlatformState();
    _startScan();
  }

  Future<void> initPlatformState() async {
    String platformVersion;

    try {
      platformVersion = await _flutterTianyuPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  late final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Tianyu Plugin app'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Running on: $_platformVersion\n'),
                  ],
                ),
                ElevatedButton(
                    onPressed: _searchBluetoothDevice,
                    child: const Text("Scan Device")),
                ElevatedButton(
                    onPressed: _connectTianyuDevice,
                    child: const Text("Connect Tianyu device")),
                ElevatedButton(
                    onPressed: _disconnectDevice,
                    child: const Text("Disconnect Tianyu device")),
                ElevatedButton(
                    onPressed: _readCard, child: const Text("Read card")),
                ElevatedButton(
                    onPressed: _cancelTransaction,
                    child: const Text('Cancel Transaction')),
                ElevatedButton(
                    onPressed: _confirmTransaction,
                    child: const Text('Confirm Transaction')),
                ElevatedButton(
                    onPressed: _clearLogs, child: const Text('Clear logs')),
                ElevatedButton(onPressed: _displayTextOnScreen, child: const Text('Display text on screen')),
                ElevatedButton(onPressed: _getDeviceInfo, child: const Text('GetDeviceVerion')),
                Visibility(
                    visible: _isProcessing,
                    child: const LinearProgressIndicator()),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Text(_tianyuLogs),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _initTianyuDevice() async {
    _initialized = true;
    final permissionCheck = await _checkPermission();
    if (!permissionCheck) {
      if (!mounted) return false;
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
        const SnackBar(
          content: Text("Not allowed to initialize"),
        ),
      );
      return false;
    }
    if (mounted) {
      setState(() {
        _isProcessing = true;
        _tianyuLogs += "\nInitializing...";
      });
    }
    _innitialized = await _flutterTianyuPlugin.initDevice();
    if (mounted) {
      setState(() {
        _isProcessing = false;
        _tianyuLogs += "\nInitialized $_innitialized";
      });
    }

    if (!mounted) return _innitialized;

    return _innitialized;
  }

  Future<bool> _checkPermission() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    var bluetoothScanCheck = await Permission.bluetoothScan.isGranted;
    if (androidInfo.version.sdkInt < 31) {
      bluetoothScanCheck = true;
    }
    if (!bluetoothScanCheck) {
      await Permission.bluetoothScan.request();
      bluetoothScanCheck = await Permission.bluetoothScan.isGranted;
    }
    var bluetoothConnectCheck = await Permission.bluetoothConnect.isGranted;
    if (!bluetoothConnectCheck) {
      await Permission.bluetoothConnect.request();
      bluetoothConnectCheck = await Permission.bluetoothConnect.isGranted;
    }
    var bluetoothAdvertiseCheck = await Permission.bluetoothAdvertise.isGranted;
    if (androidInfo.version.sdkInt < 31) {
      bluetoothAdvertiseCheck = true;
    }
    if (!bluetoothAdvertiseCheck) {
      await Permission.bluetoothAdvertise.request();
      bluetoothAdvertiseCheck = await Permission.bluetoothConnect.isGranted;
    }
    var findLocationCheck = await Permission.locationWhenInUse.isGranted;
    if (!findLocationCheck) {
      await Permission.locationWhenInUse.request();
      findLocationCheck = await Permission.locationWhenInUse.isGranted;
    }

    var writeStorageCheck = true;
    // if (androidInfo.version.sdkInt >= 30) {
    //   writeStorageCheck = await Permission.manageExternalStorage.isGranted;
    //   if (!writeStorageCheck) {
    //     await Permission.manageExternalStorage.request();
    //     writeStorageCheck = await Permission.manageExternalStorage.isGranted;
    //   }
    // } else {
    //   writeStorageCheck = await Permission.storage.isGranted;
    //   if (!writeStorageCheck) {
    //     await Permission.storage.request();
    //     writeStorageCheck = await Permission.storage.isGranted;
    //   }
    // }

    await Permission.phone.request();

    return bluetoothScanCheck &&
        findLocationCheck &&
        bluetoothConnectCheck &&
        bluetoothAdvertiseCheck &&
        writeStorageCheck;
  }

  Future<void> _connectTianyuDevice() async {
    if (!_innitialized) {
      final inited = await _initTianyuDevice();
      if (!inited) {
        return;
      }
    }
    final connected = await _flutterTianyuPlugin.isConnected();
    if (connected) {
      return;
    }
    if (mounted) {
      setState(() {
        _isProcessing = true;
        _tianyuLogs += "\nConnecting...";
      });
    }
    await _flutterTianyuPlugin.connectDevice(btAddress: "A2:E7:5A:BA:80:4C");
    //await _flutterTianyuPlugin.connectDevice(btAddress: btAddress);
  }

  void _disconnectDevice() async {
    final cek = await _flutterTianyuPlugin.isConnected();
    if (!cek) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _tianyuLogs += "\ndisconnected";
        });
      }
      return;
    }
    setState(() {
      _isProcessing = true;
      _tianyuLogs += "\ndisconnecting...";
    });
    await _flutterTianyuPlugin.disconnectDevice();
    if (mounted) {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future _readCard() async {
    bool showPinInput = false;
    final cek = await _flutterTianyuPlugin.isConnected();
    if (!cek) {
      await _connectTianyuDevice();
    }

    if (mounted) {
      setState(() {
        _isProcessing = true;
        _tianyuLogs += "\nReading...";
      });
    }

    try {
      await _flutterTianyuPlugin.readCardWithTradeData(
          amount: 5, showPinInputStatus: showPinInput);

      if (mounted) {
        setState(() {
          _tianyuLogs += "\nRead Card Success";
          print(_tianyuLogs);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _tianyuLogs += "\nRead Card Failed";
          print(_tianyuLogs);
        });
      }
    }

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future _confirmTransaction() async {
    final cek = await _flutterTianyuPlugin.isConnected();
    if (!cek) {
      await _connectTianyuDevice();
    }
    if (mounted) {
      setState(() {
        _isProcessing = true;
        _tianyuLogs += "\nConfirm";
      });
    }
    await _flutterTianyuPlugin.confirmTransaction();
    if (mounted) {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _clearLogs() {
    setState(() {
      _tianyuLogs = "";
    });
  }

  void _cancelTransaction() async {
    final cek = await _flutterTianyuPlugin.isConnected();
    if (!cek) {
      await _connectTianyuDevice();
    }

    if (mounted) {
      setState(() {
        _isProcessing = true;
        _tianyuLogs += "\nCancel";
      });
    }
    _flutterTianyuPlugin.cancel();
    if (mounted) {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _searchBluetoothDevice() async {
    List<BluetoothDevice> devicesList = [];
    Map<String, BluetoothDevice> devicesMap = {};

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devicesMap.containsKey(result.device.id.toString())) {
          devicesList.add(result.device);
          devicesMap[result.device.id.toString()] = result.device;
        }
      }
      setState(() {
        _devicesList = devicesList;
      });
    });

    await FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

    await FlutterBluePlus.stopScan();

    print('Devices found:');
    for (int i = 0; i < devicesList.length; i++) {
      print('${i + 1}. ${devicesList[i].name} (${devicesList[i].id})');
    }

    if (devicesList.isNotEmpty) {
      BluetoothDevice selectedDevice = devicesList[0];
      String btAddress = selectedDevice.id.toString();
      print('Selected device: $btAddress');

      await selectedDevice.connect();
      print('Connected to $btAddress');
    } else {
      print('No devices found.');
    }
  }

  void _startScan() async {
    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        for (ScanResult result in results) {
          if (!_devicesList.contains(result.device)) {
            _devicesList.add(result.device);
          }
        }
      });
    });

    FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

    await Future.delayed(Duration(seconds: 10));

    FlutterBluePlus.stopScan();
  }

  void _displayTextOnScreen() async{
    final cek = await _flutterTianyuPlugin.isConnected();
    if (!cek) {
      await _connectTianyuDevice();
    }

    if (mounted) {
      setState(() {
        _isProcessing = true;
        _tianyuLogs += "\nTest Display Text On Screen";
      });
    }
    await _flutterTianyuPlugin.displayTextOnScreen(str: "hello");
    if (mounted) {
      setState(() {
        _isProcessing = false;
      });

      return;
    }
  }

  void _getDeviceInfo() async  {

    String version = await _flutterTianyuPlugin.getDeviceInfo();
    print(version);
    if (mounted) {
      setState(() {
        _isProcessing = false;
        _tianyuLogs += "\nVersion: $version";
      });
    }
  }
}
