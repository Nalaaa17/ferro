import 'package:isar/isar.dart';
import 'package:ferro/data/entities/entities.dart';
import 'package:ferro/domain/repositories/device_profile_repository.dart';

class IsarDeviceProfileRepository implements DeviceProfileRepository {
  IsarDeviceProfileRepository(this._isar);

  final Isar _isar;

  @override
  Future<List<DeviceProfileEntity>> getAllProfiles() {
    return _isar.deviceProfileEntitys.where().sortByLastConnectedDesc().findAll();
  }

  @override
  Future<DeviceProfileEntity?> getProfileById(int id) {
    return _isar.deviceProfileEntitys.get(id);
  }

  @override
  Future<DeviceProfileEntity?> getProfileByIdentifier(String deviceIdentifier) {
    return _isar.deviceProfileEntitys
        .where()
        .deviceIdentifierEqualTo(deviceIdentifier)
        .findFirst();
  }

  @override
  Future<int> saveProfile(DeviceProfileEntity profile) {
    profile.lastConnected = DateTime.now();
    return _isar.writeTxn(() => _isar.deviceProfileEntitys.put(profile));
  }

  @override
  Future<bool> deleteProfile(int id) {
    return _isar.writeTxn(() => _isar.deviceProfileEntitys.delete(id));
  }

  @override
  Stream<List<DeviceProfileEntity>> watchAllProfiles() {
    return _isar.deviceProfileEntitys
        .where()
        .sortByLastConnectedDesc()
        .watch(fireImmediately: true);
  }
}
