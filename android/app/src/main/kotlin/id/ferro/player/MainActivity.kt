package id.ferro.player

import android.bluetooth.BluetoothDevice
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbManager
import android.media.AudioDeviceInfo
import android.media.AudioManager
import android.os.Build
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : AudioServiceActivity() {
    private val CHANNEL = "ferro/audio_devices"
    private var methodChannel: MethodChannel? = null
    private var audioManager: AudioManager? = null
    private var usbManager: UsbManager? = null

    private val deviceReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            val action = intent?.action ?: return
            when (action) {
                BluetoothDevice.ACTION_ACL_CONNECTED,
                BluetoothDevice.ACTION_ACL_DISCONNECTED,
                UsbManager.ACTION_USB_DEVICE_ATTACHED,
                UsbManager.ACTION_USB_DEVICE_DETACHED,
                AudioManager.ACTION_HEADSET_PLUG,
                AudioManager.ACTION_AUDIO_BECOMING_NOISY -> {
                    notifyDeviceChanged()
                }
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        audioManager = getSystemService(Context.AUDIO_SERVICE) as? AudioManager
        usbManager = getSystemService(Context.USB_SERVICE) as? UsbManager

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "getCurrentDevice" -> {
                    result.success(detectCurrentDevice())
                }
                "getVolume" -> {
                    val am = audioManager
                    if (am != null) {
                        val current = am.getStreamVolume(AudioManager.STREAM_MUSIC)
                        val max = am.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
                        result.success(current.toDouble() / max.toDouble())
                    } else {
                        result.success(0.7)
                    }
                }
                "setVolume" -> {
                    val volume = call.argument<Double>("volume") ?: 0.7
                    val am = audioManager
                    if (am != null) {
                        val max = am.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
                        val target = (volume * max).toInt().coerceIn(0, max)
                        am.setStreamVolume(AudioManager.STREAM_MUSIC, target, 0)
                        result.success(true)
                    } else {
                        result.success(false)
                    }
                }
                else -> result.notImplemented()
            }
        }

        registerReceivers()
    }

    private fun registerReceivers() {
        val filter = IntentFilter().apply {
            addAction(BluetoothDevice.ACTION_ACL_CONNECTED)
            addAction(BluetoothDevice.ACTION_ACL_DISCONNECTED)
            addAction(UsbManager.ACTION_USB_DEVICE_ATTACHED)
            addAction(UsbManager.ACTION_USB_DEVICE_DETACHED)
            addAction(AudioManager.ACTION_HEADSET_PLUG)
            addAction(AudioManager.ACTION_AUDIO_BECOMING_NOISY)
        }
        registerReceiver(deviceReceiver, filter)
    }

    private fun notifyDeviceChanged() {
        val deviceMap = detectCurrentDevice()
        runOnUiThread {
            methodChannel?.invokeMethod("onDeviceChanged", deviceMap)
        }
    }

    private fun detectCurrentDevice(): Map<String, Any?> {
        val am = audioManager ?: return mapOf(
            "type" to "speaker",
            "name" to "Internal Speaker",
            "id" to "internal_speaker"
        )

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val devices = am.getDevices(AudioManager.GET_DEVICES_OUTPUTS)
            // 1. Check for USB DAC or USB Audio
            val usbDevice = devices.firstOrNull {
                it.type == AudioDeviceInfo.TYPE_USB_DEVICE ||
                it.type == AudioDeviceInfo.TYPE_USB_HEADSET ||
                it.type == AudioDeviceInfo.TYPE_USB_ACCESSORY
            }
            if (usbDevice != null) {
                val productName = usbDevice.productName?.toString() ?: "USB DAC"
                return mapOf(
                    "type" to "usb_dac",
                    "name" to productName,
                    "id" to "usb_dac_${usbDevice.id}"
                )
            }

            // 2. Check for Bluetooth A2DP
            val btDevice = devices.firstOrNull {
                it.type == AudioDeviceInfo.TYPE_BLUETOOTH_A2DP ||
                it.type == AudioDeviceInfo.TYPE_BLUETOOTH_SCO
            }
            if (btDevice != null) {
                val name = btDevice.productName?.toString() ?: "Bluetooth Audio"
                return mapOf(
                    "type" to "bluetooth",
                    "name" to name,
                    "id" to "bt_${btDevice.address ?: btDevice.id}"
                )
            }

            // 3. Check for 3.5mm Headphone Jack
            val wiredHeadset = devices.firstOrNull {
                it.type == AudioDeviceInfo.TYPE_WIRED_HEADSET ||
                it.type == AudioDeviceInfo.TYPE_WIRED_HEADPHONES
            }
            if (wiredHeadset != null) {
                return mapOf(
                    "type" to "jack",
                    "name" to "3.5mm Headphone Jack",
                    "id" to "jack_3_5mm"
                )
            }
        }

        // Fallback to internal speaker
        return mapOf(
            "type" to "speaker",
            "name" to "Speaker Internal HP",
            "id" to "internal_speaker"
        )
    }

    override fun onDestroy() {
        try {
            unregisterReceiver(deviceReceiver)
        } catch (_: Exception) {}
        super.onDestroy()
    }
}
