package id.im.flutter_tianyu;

import static android.util.Log.println;

import android.os.Handler;

import com.whty.device.delegate.IDeviceDelegate;

import java.util.HashMap;
import java.util.List;
import java.util.Objects;

import io.flutter.plugin.common.MethodChannel;

public class DeviceDelegate implements IDeviceDelegate {

    private MethodChannel channel;
    private Handler handler;

    public DeviceDelegate(MethodChannel channel, Handler handler) {
        super();
        this.channel = channel;
        this.handler = handler;
//        Handler handler = new Handler();
//        new Thread(() -> {
//            try {
//                Thread.sleep(10000);
//                handler.post(() -> {
//                    onConnectedDevice(true);
//                });
//                Thread.sleep(1000);
//                handler.post(() -> {
//                    onDisconnectedDevice(true);
//                });
//                Thread.sleep(1000);
//                handler.post(() -> {
//                    onReadCard(new HashMap<String , Object>());
//                });
//                Thread.sleep(1000);
//                handler.post(() -> {
//                    onReadCardData(new HashMap<String, Object>());
//                });
//
//            } catch (InterruptedException e) {
//                throw new RuntimeException(e);
//            }
//        }).start();
    }

    @Override
    public void onConnectedDevice(boolean isSuccess) {
        handler.post(() -> channel.invokeMethod("onConnectedDevice", isSuccess));

    }

    @Override
    public void onDisconnectedDevice(boolean isSuccess) {
        handler.post(() ->channel.invokeMethod("onDisconnectedDevice", isSuccess));
    }

    @Override
    public void onUpdateWorkingKey(boolean[] isSuccess) {
        handler.post(() ->channel.invokeMethod("onUpdateWorkingKey", isSuccess));
    }

    @Override
    public void onReadCard(HashMap data) {
        handler.post(() ->channel.invokeMethod("onReadCard", data));
    }

    @Override
    public void onReadCardData(HashMap data) {
        handler.post(() ->channel.invokeMethod("onReadCardData", data));
    }

    @Override
    public void onDownGradeTransaction(HashMap data) {
        handler.post(() ->channel.invokeMethod("onDownGradeTransaction", data));
    }

    @Override
    public void onWaitingcard() {
        // TODO Auto-generated method stub

    }

    @Override
    public void onGetMacWithMKIndex(HashMap data) {
        handler.post(() ->channel.invokeMethod("onGetMacWithMKIndex", data));

    }

    @Override
    public void onSelectICApplication(List list) {
        handler.post(() ->channel.invokeMethod("onSelectICApplication", list));

    }

    @Override
    public void onPinBlockEntered(HashMap<String, String> data) {
        handler.post(() ->channel.invokeMethod("onPinBlockEntered", data));
    }


    public void onGetPinBlock(HashMap data) {
        handler.post(() ->channel.invokeMethod("onGetPinBlock", data));
    }


}
