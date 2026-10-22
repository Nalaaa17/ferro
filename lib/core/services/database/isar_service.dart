import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ferro/data/entities/entities.dart';

class IsarService {
  IsarService._();
  static final IsarService instance = IsarService._();

  Isar? _isar;

  Isar get isar {
    final db = _isar;
    if (db == null) {
      throw StateError('Isar database is not initialized. Call initialize() first.');
    }
    return db;
  }

  bool get isInitialized => _isar != null && _isar!.isOpen;

  Future<Isar> initialize({String? directoryPath, bool inspector = true}) async {
    if (_isar != null && _isar!.isOpen) {
      return _isar!;
    }

    String path;
    if (kIsWeb) {
      path = '';
    } else if (directoryPath != null) {
      path = directoryPath;
    } else {
      final dir = await getApplicationDocumentsDirectory();
      path = dir.path;
    }

    _isar = await Isar.open(
      [
        SongEntitySchema,
        PlaylistEntitySchema,
        PlaylistSongEntitySchema,
        DeviceProfileEntitySchema,
        EQPresetEntitySchema,
      ],
      directory: path,
      inspector: inspector,
      name: 'ferro_music_db',
    );

    await _seedDefaultPresets();
    return _isar!;
  }

  Future<void> _seedDefaultPresets() async {
    final db = _isar;
    if (db == null) return;

    final count = await db.eQPresetEntitys.count();
    if (count > 0) return;

    final defaultPresets = [
      EQPresetEntity()
        ..name = 'Flat'
        ..bands = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        ..bassBoost = 0
        ..virtualizer = 0
        ..isPresetReadOnly = true,
      EQPresetEntity()
        ..name = 'Rock'
        ..bands = [4.5, 3.0, 1.5, 0, -1.0, 0, 2.0, 3.5, 4.0, 4.5]
        ..bassBoost = 25
        ..virtualizer = 15
        ..isPresetReadOnly = true,
      EQPresetEntity()
        ..name = 'Pop'
        ..bands = [-1.0, 1.0, 3.0, 4.5, 4.0, 2.5, 0, 1.0, 2.5, 3.0]
        ..bassBoost = 15
        ..virtualizer = 10
        ..isPresetReadOnly = true,
      EQPresetEntity()
        ..name = 'Jazz'
        ..bands = [3.0, 2.0, 1.0, 2.0, -1.0, -1.0, 0, 1.5, 2.5, 3.0]
        ..bassBoost = 10
        ..virtualizer = 20
        ..isPresetReadOnly = true,
      EQPresetEntity()
        ..name = 'Bass Boost'
        ..bands = [6.0, 5.0, 4.0, 2.0, 0, 0, 0, 0, 0, 0]
        ..bassBoost = 60
        ..virtualizer = 10
        ..isPresetReadOnly = true,
      EQPresetEntity()
        ..name = 'Vokal'
        ..bands = [-2.0, -1.0, 0, 2.0, 4.5, 4.0, 3.0, 1.5, 0, -1.0]
        ..bassBoost = 0
        ..virtualizer = 5
        ..isPresetReadOnly = true,
      EQPresetEntity()
        ..name = 'Electronic'
        ..bands = [5.0, 4.0, 2.0, 0, -1.5, 2.0, 1.0, 3.0, 4.5, 5.0]
        ..bassBoost = 40
        ..virtualizer = 30
        ..isPresetReadOnly = true,
    ];

    await db.writeTxn(() async {
      await db.eQPresetEntitys.putAll(defaultPresets);
    });
  }

  Future<void> close() async {
    if (_isar != null && _isar!.isOpen) {
      await _isar!.close();
      _isar = null;
    }
  }

  Future<void> clearAll() async {
    final db = _isar;
    if (db == null) return;
    await db.writeTxn(() async {
      await db.clear();
    });
  }
}
