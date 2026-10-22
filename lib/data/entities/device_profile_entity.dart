import 'package:isar/isar.dart';

part 'device_profile_entity.g.dart';

@collection
class DeviceProfileEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String deviceIdentifier; // Bluetooth MAC address, USB VID:PID, 'speaker', or 'jack_3_5mm'

  late String name; // e.g. "Soundcore R50i", "Apple USB-C DAC"

  late String connectionType; // bluetooth, usb_dac, jack, speaker

  late int eqPresetId;

  late double targetVolume; // 0.0 - 1.0

  bool autoApply = true;

  DateTime lastConnected = DateTime.now();
}
