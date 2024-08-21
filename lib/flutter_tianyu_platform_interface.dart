import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_tianyu_method_channel.dart';

abstract class FlutterTianyuPlatform extends PlatformInterface {
  /// Constructs a FlutterTianyuPlatform.
  FlutterTianyuPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterTianyuPlatform _instance = MethodChannelFlutterTianyu();

  /// The default instance of [FlutterTianyuPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterTianyu].
  static FlutterTianyuPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterTianyuPlatform] when
  /// they register themselves.
  static set instance(FlutterTianyuPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  void Function({required bool isSuccess})? onConnectedDevice;
  void Function({required bool isSuccess})? onDisconnectedDevice;
  void Function({required dynamic isSuccess})? onUpdateWorkingKey;
  void Function({required dynamic list})? onSelectICApplication;
  void Function({required dynamic data})? onReadCard;
  void Function({required dynamic data})? onReadCardData;
  void Function({required dynamic data})? onDownGradeTransaction;
  void Function({required dynamic data})? onGetMacWithMKIndex;
  void Function({required dynamic data})? onPinBlockEntered;
  void Function({required dynamic data})? onGetPinBlock;
  void Function()? onWaitingcard;

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> initDevice();
  Future<void> connectDevice({required String btAddress});
  Future<void> disconnectDevice();
  Future<bool> isConnected();
  Future<String> getVersion();
  Future<String> getDeviceInfo();
  Future<void> cancel();
  Future<Map<Object?, Object?>> readCardWithTradeData(
      {required int amount, bool showPinInputStatus});
  Future<bool> confirmTransaction({String str = "Transaction Approved"});
  Future<bool> displayTextOnScreen(
      {String str = "Test Display Text On Screen"});
  Future<bool> confirmTradeResponse({required String str});
}
