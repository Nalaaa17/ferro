import 'package:ferro/data/entities/device_profile_entity.dart';

abstract class DeviceProfileRepository {
  Future<List<DeviceProfileEntity>> getAllProfiles();
  Future<DeviceProfileEntity?> getProfileById(int id);
  Future<DeviceProfileEntity?> getProfileByIdentifier(String deviceIdentifier);
  Future<int> saveProfile(DeviceProfileEntity profile);
  Future<bool> deleteProfile(int id);
  Stream<List<DeviceProfileEntity>> watchAllProfiles();
}
