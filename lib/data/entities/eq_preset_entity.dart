import 'package:isar/isar.dart';

part 'eq_preset_entity.g.dart';

@collection
class EQPresetEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String name;

  // 10-band gain in dB (-12.0 to +12.0):
  // [31Hz, 63Hz, 125Hz, 250Hz, 500Hz, 1kHz, 2kHz, 4kHz, 8kHz, 16kHz]
  late List<double> bands;

  double bassBoost = 0.0; // 0.0 - 100.0

  double virtualizer = 0.0; // 0.0 - 100.0

  bool loudnessEnhancer = false;

  bool isPresetReadOnly = false;
}
