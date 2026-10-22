/// Entity representing hardware audio gear and its auto-preset preferences per PRD §2.5 & §4.12.
class DeviceProfile {
  DeviceProfile({
    required this.id,
    required this.deviceKey,
    required this.displayName,
    required this.connectionType, // 'bluetooth', 'usb', 'wired'
    required this.eqGains, // 10 bands (-12.0 to +12.0 dB)
    required this.presetName,
    this.savedVolume = 70, // 0 - 100
    this.bassBoost = 25.0, // 0 - 100
    this.virtualizer = 15.0, // 0 - 100
    this.loudnessNormalization = false,
    this.isActive = false,
    this.macHash,
  });

  final String id;
  final String deviceKey;
  String displayName;
  String connectionType;
  List<double> eqGains;
  String presetName;
  int savedVolume;
  double bassBoost;
  double virtualizer;
  bool loudnessNormalization;
  bool isActive;
  String? macHash;

  DeviceProfile copyWith({
    String? displayName,
    String? connectionType,
    List<double>? eqGains,
    String? presetName,
    int? savedVolume,
    double? bassBoost,
    double? virtualizer,
    bool? loudnessNormalization,
    bool? isActive,
  }) {
    return DeviceProfile(
      id: id,
      deviceKey: deviceKey,
      displayName: displayName ?? this.displayName,
      connectionType: connectionType ?? this.connectionType,
      eqGains: eqGains ?? List.from(this.eqGains),
      presetName: presetName ?? this.presetName,
      savedVolume: savedVolume ?? this.savedVolume,
      bassBoost: bassBoost ?? this.bassBoost,
      virtualizer: virtualizer ?? this.virtualizer,
      loudnessNormalization: loudnessNormalization ?? this.loudnessNormalization,
      isActive: isActive ?? this.isActive,
      macHash: macHash,
    );
  }
}

class MockDeviceProfiles {
  MockDeviceProfiles._();

  static List<DeviceProfile> get sampleProfiles => [
    DeviceProfile(
      id: 'd1',
      deviceKey: 'BT:Soundcore R50i',
      displayName: 'TWS-Soundcore R50i',
      connectionType: 'bluetooth',
      presetName: 'V-Shape (Pop/Bass)',
      eqGains: [4.0, 3.0, 1.5, 0.0, -1.0, 0.0, 1.5, 3.0, 4.5, 4.0],
      savedVolume: 70,
      bassBoost: 35.0,
      virtualizer: 20.0,
      loudnessNormalization: true,
      isActive: true, // Currently connected gear
    ),
    DeviceProfile(
      id: 'd2',
      deviceKey: 'USB:0x05ac:0x1101',
      displayName: 'Apple USB-C DAC',
      connectionType: 'usb',
      presetName: 'Audiophile Flat (Lossless)',
      eqGains: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
      savedVolume: 45,
      bassBoost: 0.0,
      virtualizer: 0.0,
      loudnessNormalization: false,
      isActive: false,
    ),
    DeviceProfile(
      id: 'd3',
      deviceKey: 'BT:WH-1000XM5',
      displayName: 'Sony WH-1000XM5',
      connectionType: 'bluetooth',
      presetName: 'Warm Acoustic',
      eqGains: [2.0, 1.5, 1.0, 0.5, 0.0, 0.0, 1.0, 2.0, 2.5, 2.0],
      savedVolume: 65,
      bassBoost: 15.0,
      virtualizer: 30.0,
      loudnessNormalization: true,
      isActive: false,
    ),
    DeviceProfile(
      id: 'd4',
      deviceKey: 'WIRED:3.5mm_IEM',
      displayName: 'KZ ZSN Pro (Jack 3.5mm)',
      connectionType: 'wired',
      presetName: 'Harman Target Target',
      eqGains: [3.5, 2.5, 1.0, -0.5, -1.0, 0.5, 2.0, 3.0, 1.5, 0.5],
      savedVolume: 50,
      bassBoost: 20.0,
      virtualizer: 10.0,
      loudnessNormalization: false,
      isActive: false,
    ),
  ];
}
