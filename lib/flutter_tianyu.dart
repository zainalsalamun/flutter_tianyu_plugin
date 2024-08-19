import 'flutter_tianyu_platform_interface.dart';

class FlutterTianyu {
  final void Function({required bool isSuccess})? onConnectedDevice;
  final void Function({required bool isSuccess})? onDisconnectedDevice;
  final void Function({required dynamic isSuccess})? onUpdateWorkingKey;
  final void Function({required dynamic list})? onSelectICApplication;
  final void Function({required dynamic data})? onReadCard;
  final void Function({required dynamic data})? onReadCardData;
  final void Function({required dynamic data})? onDownGradeTransaction;
  final void Function({required dynamic data})? onGetMacWithMKIndex;
  final void Function({required dynamic data})? onPinBlockEntered;
  final void Function({required dynamic data})? onGetPinBlock;
  final void Function()? onWaitingcard;

  FlutterTianyu({
    this.onDisconnectedDevice,
    this.onConnectedDevice,
    this.onUpdateWorkingKey,
    this.onSelectICApplication,
    this.onReadCard,
    this.onReadCardData,
    this.onDownGradeTransaction,
    this.onGetMacWithMKIndex,
    this.onPinBlockEntered,
    this.onGetPinBlock,
    this.onWaitingcard,
  }) {
    FlutterTianyuPlatform.instance.onDisconnectedDevice = onDisconnectedDevice;
    FlutterTianyuPlatform.instance.onConnectedDevice = onConnectedDevice;
    FlutterTianyuPlatform.instance.onUpdateWorkingKey = onUpdateWorkingKey;
    FlutterTianyuPlatform.instance.onSelectICApplication =
        onSelectICApplication;
    FlutterTianyuPlatform.instance.onReadCard = onReadCard;
    FlutterTianyuPlatform.instance.onReadCardData = onReadCardData;
    FlutterTianyuPlatform.instance.onDownGradeTransaction =
        onDownGradeTransaction;
    FlutterTianyuPlatform.instance.onGetMacWithMKIndex = onGetMacWithMKIndex;
    FlutterTianyuPlatform.instance.onPinBlockEntered = onPinBlockEntered;
    FlutterTianyuPlatform.instance.onGetPinBlock = onGetPinBlock;
    FlutterTianyuPlatform.instance.onWaitingcard = onWaitingcard;
  }

  Future<String?> getPlatformVersion() {
    return FlutterTianyuPlatform.instance.getPlatformVersion();
  }

  Future<bool> initDevice() {
    return FlutterTianyuPlatform.instance.initDevice();
  }

  Future<void> connectDevice({required String btAddress}) {
    return FlutterTianyuPlatform.instance.connectDevice(btAddress: btAddress);
  }

  Future<void> disconnectDevice() {
    return FlutterTianyuPlatform.instance.disconnectDevice();
  }

  Future<bool> isConnected() {
    return FlutterTianyuPlatform.instance.isConnected();
  }

  Future<String> getVersion() {
    return FlutterTianyuPlatform.instance.getVersion();
  }

  Future<String> getDeviceInfo() {
    return FlutterTianyuPlatform.instance.getDeviceInfo();
  }

  Future<void> cancel() {
    return FlutterTianyuPlatform.instance.cancel();
  }

  Future<Map<Object?, Object?>> readCardWithTradeData(
      {required int amount, bool showPinInputStatus = true}) {
    return FlutterTianyuPlatform.instance.readCardWithTradeData(
        amount: amount, showPinInputStatus: showPinInputStatus);
  }

  Future<bool> confirmTransaction({String str = "Transaction Approved"}) {
    return FlutterTianyuPlatform.instance.confirmTransaction(str: str);
  }

  Future<bool> displayTextOnScreen({ String str = "Test Display Text On Screen"}) {
    return FlutterTianyuPlatform.instance.displayTextOnScreen(str: str);
  }
}
