import 'package:isar/isar.dart';
import 'package:ferro/data/entities/entities.dart';
import 'package:ferro/domain/repositories/eq_preset_repository.dart';

class IsarEQPresetRepository implements EQPresetRepository {
  IsarEQPresetRepository(this._isar);

  final Isar _isar;

  @override
  Future<List<EQPresetEntity>> getAllPresets() {
    return _isar.eQPresetEntitys.where().sortByName().findAll();
  }

  @override
  Future<EQPresetEntity?> getPresetById(int id) {
    return _isar.eQPresetEntitys.get(id);
  }

  @override
  Future<EQPresetEntity?> getPresetByName(String name) {
    return _isar.eQPresetEntitys.where().nameEqualTo(name).findFirst();
  }

  @override
  Future<int> savePreset(EQPresetEntity preset) {
    return _isar.writeTxn(() => _isar.eQPresetEntitys.put(preset));
  }

  @override
  Future<bool> deletePreset(int id) async {
    final preset = await _isar.eQPresetEntitys.get(id);
    if (preset != null && preset.isPresetReadOnly) {
      return false; // Cannot delete factory preset
    }
    return _isar.writeTxn(() => _isar.eQPresetEntitys.delete(id));
  }

  @override
  Stream<List<EQPresetEntity>> watchAllPresets() {
    return _isar.eQPresetEntitys.where().sortByName().watch(fireImmediately: true);
  }
}
