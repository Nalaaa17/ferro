import 'package:flutter/material.dart';
import 'package:ferro/features/devices/domain/entities/device_profile.dart';

/// Controller managing 10-band equalizer, audio effects, and device profiles sync per PRD §4.11 & §4.12.
class EqualizerController extends ChangeNotifier {
  EqualizerController._() {
    _profiles = List.from(MockDeviceProfiles.sampleProfiles);
    // Initialize with active profile's EQ curve
    _loadFromActiveProfile();
  }

  static final EqualizerController instance = EqualizerController._();

  static const List<String> frequencyLabels = [
    '31Hz',
    '62Hz',
    '125Hz',
    '250Hz',
    '500Hz',
    '1kHz',
    '2kHz',
    '4kHz',
    '8kHz',
    '16kHz',
  ];

  static const Map<String, List<double>> presets = {
    'Flat': [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
    'Rock': [4.5, 3.0, 1.5, 0.0, -1.0, -0.5, 1.0, 2.5, 4.0, 5.0],
    'Pop': [1.5, 2.5, 3.5, 2.0, 0.0, 1.0, 2.0, 3.0, 3.5, 3.0],
    'Jazz': [3.0, 2.0, 1.0, 1.5, 0.0, 1.0, 2.0, 2.5, 3.0, 3.5],
    'Bass Boost': [6.0, 5.0, 4.0, 2.0, 0.0, 0.0, 0.0, 0.5, 1.0, 1.5],
    'Vokal': [-2.0, -1.0, 0.0, 2.0, 4.0, 4.5, 3.0, 1.5, 0.5, -1.0],
  };

  bool _isEnabled = true;
  String _selectedPreset = 'Pop';
  List<double> _bandGains = [1.5, 2.5, 3.5, 2.0, 0.0, 1.0, 2.0, 3.0, 3.5, 3.0];
  double _bassBoost = 35.0; // 0 - 100
  double _virtualizer = 20.0; // 0 - 100
  bool _loudnessNormalization = true;
  bool _autoSwitchEnabled = true;

  late List<DeviceProfile> _profiles;

  // Getters
  bool get isEnabled => _isEnabled;
  String get selectedPreset => _selectedPreset;
  List<double> get bandGains => List.unmodifiable(_bandGains);
  double get bassBoost => _bassBoost;
  double get virtualizer => _virtualizer;
  bool get loudnessNormalization => _loudnessNormalization;
  bool get autoSwitchEnabled => _autoSwitchEnabled;
  List<DeviceProfile> get profiles => List.unmodifiable(_profiles);

  DeviceProfile get activeProfile => _profiles.firstWhere(
        (p) => p.isActive,
        orElse: () => _profiles.first,
      );

  void toggleEnabled(bool value) {
    _isEnabled = value;
    notifyListeners();
  }

  void toggleAutoSwitch(bool value) {
    _autoSwitchEnabled = value;
    notifyListeners();
  }

  void selectPreset(String presetName) {
    _selectedPreset = presetName;
    if (presets.containsKey(presetName)) {
      _bandGains = List.from(presets[presetName]!);
    }
    notifyListeners();
  }

  void setBandGain(int index, double gain) {
    if (index >= 0 && index < _bandGains.length) {
      _bandGains[index] = gain.clamp(-12.0, 12.0);
      _selectedPreset = 'Custom';
      notifyListeners();
    }
  }

  void setBassBoost(double value) {
    _bassBoost = value.clamp(0.0, 100.0);
    notifyListeners();
  }

  void setVirtualizer(double value) {
    _virtualizer = value.clamp(0.0, 100.0);
    notifyListeners();
  }

  void toggleLoudnessNormalization(bool value) {
    _loudnessNormalization = value;
    notifyListeners();
  }

  void _loadFromActiveProfile() {
    final active = activeProfile;
    _bandGains = List.from(active.eqGains);
    _bassBoost = active.bassBoost;
    _virtualizer = active.virtualizer;
    _loudnessNormalization = active.loudnessNormalization;
    _selectedPreset = active.presetName;
  }

  void saveToActiveProfile() {
    final activeIndex = _profiles.indexWhere((p) => p.isActive);
    if (activeIndex != -1) {
      _profiles[activeIndex] = _profiles[activeIndex].copyWith(
        eqGains: List.from(_bandGains),
        presetName: _selectedPreset,
        bassBoost: _bassBoost,
        virtualizer: _virtualizer,
        loudnessNormalization: _loudnessNormalization,
      );
      notifyListeners();
    }
  }

  void switchActiveDevice(String profileId) {
    for (var i = 0; i < _profiles.length; i++) {
      _profiles[i].isActive = (_profiles[i].id == profileId);
    }
    _loadFromActiveProfile();
    notifyListeners();
  }

  void updateProfile(DeviceProfile updated) {
    final index = _profiles.indexWhere((p) => p.id == updated.id);
    if (index != -1) {
      _profiles[index] = updated;
      if (updated.isActive) {
        _loadFromActiveProfile();
      }
      notifyListeners();
    }
  }

  void addProfile(DeviceProfile newProfile) {
    _profiles.add(newProfile);
    notifyListeners();
  }

  void deleteProfile(String profileId) {
    _profiles.removeWhere((p) => p.id == profileId);
    if (_profiles.isNotEmpty && !_profiles.any((p) => p.isActive)) {
      _profiles.first.isActive = true;
      _loadFromActiveProfile();
    }
    notifyListeners();
  }
}
