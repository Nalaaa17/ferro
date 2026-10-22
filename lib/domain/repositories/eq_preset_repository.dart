import 'package:ferro/data/entities/eq_preset_entity.dart';

abstract class EQPresetRepository {
  Future<List<EQPresetEntity>> getAllPresets();
  Future<EQPresetEntity?> getPresetById(int id);
  Future<EQPresetEntity?> getPresetByName(String name);
  Future<int> savePreset(EQPresetEntity preset);
  Future<bool> deletePreset(int id);
  Stream<List<EQPresetEntity>> watchAllPresets();
}
