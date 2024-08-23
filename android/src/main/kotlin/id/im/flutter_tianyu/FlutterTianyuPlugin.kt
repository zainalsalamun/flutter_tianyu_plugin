package id.im.flutter_tianyu

import android.app.Activity
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.whty.tymposapi.DeviceApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.cancel
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/** FlutterTianyuPlugin */
class FlutterTianyuPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    /// test edit
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var deviceApi: DeviceApi
    private var activity: Activity? = null
    private var coroutineScope: CoroutineScope? = null

    //  private var methodChannelResult: MethodChannel.Result? = null
    private val handler = Handler(Looper.getMainLooper())

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_tianyu")
        channel.setMethodCallHandler(this)

    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        coroutineScope?.cancel()
        coroutineScope = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = binding.activity
        try {
            deviceApi = DeviceApi(binding.activity.applicationContext)
            deviceApi.setDelegate(DeviceDelegate(channel, handler))
        } catch (e: Exception) {
            Log.e("FlutterTianyuPlugin", e.toString())
            throw e
        }
        coroutineScope = CoroutineScope(Dispatchers.Main)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this.activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        this.activity = null
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
//    methodChannelResult = result
        when (call.method) {
            "connectDevice" -> {
                if (deviceApi.isConnected) {
                    result.success(true)
                } else {
                    coroutineScope?.launch {
                        val b = withContext(Dispatchers.IO) {
                            try {
                                return@withContext deviceApi.connectDevice("${call.arguments}")
                            } catch (e: Exception) {
                                return@withContext false;
                            }

                        }
                        result.success(b)
                    } ?: run {
                        result.success(false)
                    }


                }
            }

            "initDevice" -> {
                val b = deviceApi.initDevice("BlueToothDevice")
                result.success(b)
            }

            "disconnectDevice" -> {
                if (!deviceApi.isConnected) {
                    result.success(true)
                } else {
                    coroutineScope?.launch {
                        val b = withContext(Dispatchers.IO) {
                            try {
                                return@withContext deviceApi.disconnectDevice()
                            } catch (e: Exception) {
                                return@withContext false;
                            }
                        }
                        result.success(b)
                    } ?: run {
                        result.success(false)
                    }
                }

            }

            "isConnected" -> {
                result.success(deviceApi.isConnected)
            }

            "readCardWithTradeData" -> {

                val args = call.arguments as Map<*, *>
                val showPinInputStatus: Boolean =
                    (args["showPinInputStatus"] as Boolean?) ?: true
                val amount: Int = (args["amount"] as Int?) ?: 0
                val format = SimpleDateFormat(
                    "yyyyMMddHHmmss", Locale.getDefault()
                )
                val terminalTime = format.format(Date())
                val r: Map<String, String> = deviceApi.readCardWithTradeData(
                    "$amount",
                    terminalTime.substring(2),
                    0x00.toByte(),
                    0x10.toByte(),
                    true,
                    showPinInputStatus,
                    null,
                    0x07.toByte()
                )
                result.success(r)
            }

            "readCard" -> {

                val args = call.arguments as Map<*, *>
                val amount: Int = (args["amount"] as Int?) ?: 0
                val format = SimpleDateFormat(
                    "yyyyMMddHHmmss", Locale.getDefault()
                )

                val terminalTime = format.format(Date())
                val r: Map<String, String> = deviceApi.readCard(
                    "$amount",
                    terminalTime.substring(2),
                    0x00.toByte(),
                    0x10.toByte(),
                )
                result.success(r)
            }



            "confirmTransaction" -> {
                val b = deviceApi.confirmTransaction(call.arguments as String)
                result.success(b)
            }

            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }

            "displayTextOnScreen" -> {
                val display = deviceApi.displayTextOnScreen(call.arguments as String, 20);
                result.success(display)
            }

            "getDeviceInfo" -> {
                val deviceInfo = deviceApi.getDeviceVersion()
                result.success(deviceInfo)
            }

            "cancel" -> {
                deviceApi.cancel()
                result.success(true)
            }

            "confirmTradeResponse" -> {
                deviceApi.confirmTradeResponse(call.arguments as String)
                result.success(true)
            }

            "setUpdateType" -> {
                deviceApi.setUpdateType(call.arguments as Byte)
                result.success(true)
            }



            else -> {
                result.notImplemented()
            }




        }

    }


}
