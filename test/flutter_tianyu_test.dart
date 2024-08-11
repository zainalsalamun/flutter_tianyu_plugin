import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tianyu/flutter_tianyu.dart';
import 'package:flutter_tianyu/flutter_tianyu_platform_interface.dart';
import 'package:flutter_tianyu/flutter_tianyu_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterTianyuPlatform
    with MockPlatformInterfaceMixin
    implements FlutterTianyuPlatform {
      @override
      void Function({required bool isSuccess})? onConnectedDevice;
    
      @override
      void Function({required bool isSuccess})? onDisconnectedDevice;
    
      @override
     void Function({required dynamic data})? onDownGradeTransaction;
    
      @override
      void Function({required dynamic data})? onGetMacWithMKIndex;
    
      @override
      void Function({required dynamic data})? onGetPinBlock;
    
      @override
      void Function({required dynamic data})? onPinBlockEntered;
    
      @override
      void Function({required dynamic data})? onReadCard;
    
      @override
      void Function({required dynamic data})? onReadCardData;
    
      @override
      void Function({required dynamic list})? onSelectICApplication;
    
      @override
      void Function({required dynamic isSuccess})? onUpdateWorkingKey;
    
      @override
      void Function()? onWaitingcard;
    
      @override
      Future<void> cancel() {
    // TODO: implement cancel
    throw UnimplementedError();
      }
    
      @override
      Future<bool> confirmTransaction({String str = "Transaction Approved"}) {
    // TODO: implement confirmTransaction
    throw UnimplementedError();
      }
    
      @override
      Future<void> connectDevice({required String btAddress}) {
    // TODO: implement connectDevice
    throw UnimplementedError();
      }
    
      @override
      Future<void> disconnectDevice() {
    // TODO: implement disconnectDevice
    throw UnimplementedError();
      }
    
      @override
      Future<String?> getPlatformVersion() {
    // TODO: implement getPlatformVersion
    throw UnimplementedError();
      }
    
      @override
      Future<String> getVersion() {
    // TODO: implement getVersion
    throw UnimplementedError();
      }
    
      @override
      Future<bool> initDevice() {
    // TODO: implement initDevice
    throw UnimplementedError();
      }
    
      @override
      Future<bool> isConnected() {
    // TODO: implement isConnected
    throw UnimplementedError();
      }
    
      @override
      Future<Map<String, String>> readCardWithTradeData({required int amount, bool showPinInputStatus=true}) {
    // TODO: implement readCardWithTradeData
    throw UnimplementedError();
      }
     
  
}

void main() {
  final FlutterTianyuPlatform initialPlatform = FlutterTianyuPlatform.instance;

  test('$MethodChannelFlutterTianyu is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterTianyu>());
  });

  test('getPlatformVersion', () async {
    FlutterTianyu flutterTianyuPlugin = FlutterTianyu();
    MockFlutterTianyuPlatform fakePlatform = MockFlutterTianyuPlatform();
    FlutterTianyuPlatform.instance = fakePlatform;

    expect(await flutterTianyuPlugin.getPlatformVersion(), '42');
  });
}
