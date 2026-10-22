import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ferro/domain/repositories/repositories.dart';
import 'package:ferro/core/services/audio/ferro_audio_engine.dart';

class ConnectedDeviceEvent {
  const ConnectedDeviceEvent({
    required this.type,
    required this.name,
    required this.deviceIdentifier,
    this.activePresetName,
    this.appliedVolume,
  });

  final String type; // 'bluetooth', 'usb_dac', 'jack', 'speaker'
  final String name; // e.g. "Soundcore R50i", "Apple USB-C DAC"
  final String deviceIdentifier;
  final String? activePresetName;
  final double? appliedVolume;
}

class AudioDeviceManager {
  AudioDeviceManager({
    DeviceProfileRepository? deviceProfileRepository,
    EQPresetRepository? eqPresetRepository,
    FerroAudioEngine? audioEngine,
  })  : _deviceRepo = deviceProfileRepository,
        _eqRepo = eqPresetRepository,
        _audioEngine = audioEngine ?? FerroAudioEngine.instance {
    _initChannel();
  }

  static const MethodChannel _channel = MethodChannel('ferro/audio_devices');

  final DeviceProfileRepository? _deviceRepo;
  final EQPresetRepository? _eqRepo;
  final FerroAudioEngine _audioEngine;

  ConnectedDeviceEvent _currentDevice = const ConnectedDeviceEvent(
    type: 'speaker',
    name: 'Speaker Internal HP',
    deviceIdentifier: 'internal_speaker',
  );

  final _deviceController = StreamController<ConnectedDeviceEvent>.broadcast();

  ConnectedDeviceEvent get currentDevice => _currentDevice;
  Stream<ConnectedDeviceEvent> get deviceStream => _deviceController.stream;

  void _initChannel() {
    if (kIsWeb) return;

    try {
      _channel.setMethodCallHandler((call) async {
        if (call.method == 'onDeviceChanged') {
          final Map<dynamic, dynamic>? args = call.arguments as Map<dynamic, dynamic>?;
          if (args != null) {
            final type = args['type']?.toString() ?? 'speaker';
            final name = args['name']?.toString() ?? 'Unknown Device';
            final id = args['id']?.toString() ?? 'device';
            await handleDeviceConnected(type: type, name: name, deviceIdentifier: id);
          }
        }
      });

      // Initial check
      fetchCurrentDevice();
    } catch (_) {}
  }

  Future<void> fetchCurrentDevice() async {
    if (kIsWeb) return;
    try {
      final res = await _channel.invokeMethod<Map<dynamic, dynamic>>('getCurrentDevice');
      if (res != null) {
        final type = res['type']?.toString() ?? 'speaker';
        final name = res['name']?.toString() ?? 'Speaker Internal HP';
        final id = res['id']?.toString() ?? 'internal_speaker';
        await handleDeviceConnected(type: type, name: name, deviceIdentifier: id);
      }
    } catch (e) {
      debugPrint('fetchCurrentDevice note: $e');
    }
  }

  /// Automatically triggers per-gear EQ filter hot-swap and target volume adjustment.
  Future<void> handleDeviceConnected({
    required String type,
    required String name,
    required String deviceIdentifier,
  }) async {
    String? appliedPresetName;
    double? appliedVolume;

    final deviceRepo = _deviceRepo;
    final eqRepo = _eqRepo;

    if (deviceRepo != null) {
      final profile = await deviceRepo.getProfileByIdentifier(deviceIdentifier);
      if (profile != null && profile.autoApply) {
        appliedVolume = profile.targetVolume;
        await setSystemVolume(profile.targetVolume);

        if (eqRepo != null) {
          final preset = await eqRepo.getPresetById(profile.eqPresetId);
          if (preset != null) {
            appliedPresetName = preset.name;
            await _audioEngine.applyEqualizerBands(preset.bands);
          }
        }
      }
    }

    _currentDevice = ConnectedDeviceEvent(
      type: type,
      name: name,
      deviceIdentifier: deviceIdentifier,
      activePresetName: appliedPresetName,
      appliedVolume: appliedVolume,
    );

    _deviceController.add(_currentDevice);
  }

  Future<void> setSystemVolume(double volume) async {
    final clamped = volume.clamp(0.0, 1.0);
    await _audioEngine.setVolume(clamped);

    if (!kIsWeb) {
      try {
        await _channel.invokeMethod('setVolume', {'volume': clamped});
      } catch (_) {}
    }
  }

  /// Simulates hardware plug/unplug event for browser testing or UI preview.
  Future<void> simulateDeviceConnection({
    required String type,
    required String name,
    required String deviceIdentifier,
    List<double>? customEqBands,
    double? volume,
  }) async {
    if (customEqBands != null) {
      await _audioEngine.applyEqualizerBands(customEqBands);
    }
    if (volume != null) {
      await setSystemVolume(volume);
    }

    _currentDevice = ConnectedDeviceEvent(
      type: type,
      name: name,
      deviceIdentifier: deviceIdentifier,
      appliedVolume: volume,
    );

    _deviceController.add(_currentDevice);
  }

  void dispose() {
    _deviceController.close();
  }
}
