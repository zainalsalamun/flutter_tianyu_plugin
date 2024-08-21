import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_tianyu_platform_interface.dart';

/// An implementation of [FlutterTianyuPlatform] that uses method channels.
class MethodChannelFlutterTianyu extends FlutterTianyuPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_tianyu');

  MethodChannelFlutterTianyu() {
    methodChannel.setMethodCallHandler(_methodCallHandler);
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> cancel() {
    return methodChannel.invokeMethod("cancel");
  }

  @override
  Future<bool> confirmTransaction({String str = "Transaction Approved"}) async {
    final result =
        await methodChannel.invokeMethod<bool>('confirmTransaction', str);
    return result ?? false;
  }

  Future<bool> displayTextOnScreen(
      {String str = "Display Text On Screen"}) async {
    final result =
        await methodChannel.invokeMethod<bool>("displayTextOnScreen", str);
    return result ?? false;
  }

  @override
  Future<void> connectDevice({required String btAddress}) {
    return methodChannel.invokeMethod("connectDevice", btAddress);
  }

  @override
  Future<void> disconnectDevice() {
    return methodChannel.invokeMethod("disconnectDevice");
  }

  @override
  Future<String> getVersion() async {
    final result = await methodChannel.invokeMethod<String>("getVersion");
    return result ?? "";
  }

  @override
  Future<String> getDeviceInfo() async {
    final result = await methodChannel.invokeMethod<String>("getDeviceInfo");
    return result ?? "";
  }

  @override
  Future<bool> initDevice() async {
    final result = await methodChannel.invokeMethod<bool?>("initDevice");
    return result ?? false;
  }

  @override
  Future<bool> isConnected() async {
    final result = await methodChannel.invokeMethod<bool?>("isConnected");
    return result ?? false;
  }

  @override
  Future<Map<Object?, Object?>> readCardWithTradeData(
      {required int amount, bool showPinInputStatus = true}) async {
    final result = await methodChannel.invokeMethod<Map<Object?, Object?>?>(
      "readCardWithTradeData",
      {"amount": amount, "showPinInputStatus": showPinInputStatus},
    );
    return result ?? {};
  }

  Future<bool> confirmTradeResponse({required String str}) async {
    final result =
        await methodChannel.invokeMethod<String>("confirmTradeResponse", str);
    return result ?? "";
  }

  Future<dynamic> _methodCallHandler(MethodCall call) async {
    switch (call.method) {
      case "onConnectedDevice":
        {
          // debugPrint("channel onConnectedDevice");
          onConnectedDevice?.call(isSuccess: call.arguments);
          break;
        }
      case "onDisconnectedDevice":
        {
          // debugPrint("channel onDisconnectedDevice");
          onDisconnectedDevice?.call(isSuccess: call.arguments);
          break;
        }
      case "onUpdateWorkingKey":
        {
          onUpdateWorkingKey?.call(isSuccess: call.arguments);
          break;
        }
      case "onReadCard":
        {
          debugPrint("channel onReadCard ${call.arguments}");
          onReadCard?.call(data: call.arguments);
          break;
        }
      case "onReadCardData":
        {
          debugPrint("channel onReadCardData ${call.arguments}");
          onReadCardData?.call(data: call.arguments);
          break;
        }
      case "onDownGradeTransaction":
        {
          onDownGradeTransaction?.call(data: call.arguments);
          break;
        }
      case "onGetMacWithMKIndex":
        {
          onGetMacWithMKIndex?.call(data: call.arguments);
          break;
        }
      case "onSelectICApplication":
        {
          onSelectICApplication?.call(list: call.arguments);
          break;
        }
      case "onPinBlockEntered":
        {
          onPinBlockEntered?.call(data: call.arguments);
          break;
        }
      case "onGetPinBlock":
        {
          onGetPinBlock?.call(data: call.arguments);
          break;
        }

      default:
        break;
    }
  }
}
