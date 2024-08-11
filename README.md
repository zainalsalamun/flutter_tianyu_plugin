# flutter_tianyu

UnOfficial flutter plugin for communicating with Tianyu MPos device

Usage:
```dart
import 'package:flutter_tianyu/flutter_tianyu.dart';
```
Instantiation
```dart
final _flutterTianyuPlugin = FlutterTianyu(
    onDisconnectedDevice: ({required isSuccess}) {
      debugPrint("onDisconnectedDevice $isSuccess");
    },
    onConnectedDevice: ({required isSuccess}) {
      debugPrint("onConnectedDevice $isSuccess");
    },
    onUpdateWorkingKey: ({required isSuccess}) {
      debugPrint("onUpdateWorkingKey");
    },
    onSelectICApplication: ({required list}) {
      debugPrint("onSelectICApplication");
    },
    onReadCard: ({required data}) {
      debugPrint("onReadCard $data");
    },
    onReadCardData: ({required data}) {
      debugPrint("onReadCardData $data");
    },
    onDownGradeTransaction: ({required data}) {
      debugPrint("onDownGradeTransaction");
    },
    onGetMacWithMKIndex: ({required data}) {
      debugPrint("onGetMacWithMKIndex");
    },
    onPinBlockEntered: ({required data}) {
      debugPrint("onPinBlockEntered");
    },
    onGetPinBlock: ({required data}) {
      debugPrint("onGetPinBlock");
    },
    onWaitingcard: () {
      debugPrint("onWaitingcard");
    },
  );
```

Calling plugin methods
```dart
final result = await _flutterTianyuPlugin.initDevice();
final result = await _flutterTianyuPlugin.connectDevice(btAddress:"asd");
```

