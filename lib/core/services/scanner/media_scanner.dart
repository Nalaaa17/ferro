import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:ferro/data/entities/song_entity.dart';
import 'package:ferro/domain/repositories/song_repository.dart';
import 'package:ferro/core/services/metadata/metadata_extractor.dart';

class MediaScanProgress {
  const MediaScanProgress({
    required this.totalFilesScanned,
    required this.songsDiscovered,
    required this.currentFilePath,
    this.isCompleted = false,
  });

  final int totalFilesScanned;
  final int songsDiscovered;
  final String currentFilePath;
  final bool isCompleted;
}

class MediaScanner {
  MediaScanner({
    required this.songRepository,
    MetadataExtractor? metadataExtractor,
  }) : _metadataExtractor = metadataExtractor ?? MetadataExtractor();

  final SongRepository songRepository;
  final MetadataExtractor _metadataExtractor;

  static const Set<String> supportedExtensions = {
    '.flac',
    '.wav',
    '.mp3',
    '.opus',
    '.m4a',
    '.aac',
    '.ogg',
    '.mp4',
  };

  static const Set<String> excludedFolders = {
    'android/data',
    'android/obb',
    'ringtones',
    'notifications',
    'alarms',
    '.thumbnails',
  };

  /// Recursively scans one or more directories [roots] and updates the database.
  Stream<MediaScanProgress> scanDirectories(List<String> roots) async* {
    if (kIsWeb) {
      yield const MediaScanProgress(
        totalFilesScanned: 0,
        songsDiscovered: 0,
        currentFilePath: 'Browser environment: local filesystem scanning not available',
        isCompleted: true,
      );
      return;
    }

    int filesScanned = 0;
    int songsFound = 0;
    final List<SongEntity> batch = [];

    for (final root in roots) {
      final dir = Directory(root);
      if (!await dir.exists()) continue;

      try {
        final stream = dir.list(recursive: true, followLinks: false);
        await for (final entity in stream) {
          if (entity is! File) continue;

          filesScanned++;
          final path = entity.path;
          final ext = p.extension(path).toLowerCase();

          // Check if excluded folder or hidden file
          if (_isExcludedPath(path)) continue;

          if (supportedExtensions.contains(ext)) {
            songsFound++;
            yield MediaScanProgress(
              totalFilesScanned: filesScanned,
              songsDiscovered: songsFound,
              currentFilePath: path,
              isCompleted: false,
            );

            // Check if already in DB
            final existing = await songRepository.getSongByPath(path);
            if (existing == null) {
              final song = await _metadataExtractor.extractSongEntity(path);
              batch.add(song);

              if (batch.length >= 25) {
                await songRepository.insertOrUpdateAll(List.from(batch));
                batch.clear();
              }
            }
          }
        }
      } catch (e) {
        debugPrint('Error scanning directory $root: $e');
      }
    }

    if (batch.isNotEmpty) {
      await songRepository.insertOrUpdateAll(batch);
      batch.clear();
    }

    yield MediaScanProgress(
      totalFilesScanned: filesScanned,
      songsDiscovered: songsFound,
      currentFilePath: 'Scan selesai',
      isCompleted: true,
    );
  }

  bool _isExcludedPath(String filePath) {
    final normalized = filePath.replaceAll('\\', '/').toLowerCase();

    // Check hidden segments
    final segments = normalized.split('/');
    for (final segment in segments) {
      if (segment.startsWith('.') && segment.length > 1) {
        return true;
      }
    }

    for (final excluded in excludedFolders) {
      if (normalized.contains('/$excluded/')) {
        return true;
      }
    }

    // Check .nomedia in parent
    try {
      final parent = p.dirname(filePath);
      final nomedia = File(p.join(parent, '.nomedia'));
      if (nomedia.existsSync()) {
        return true;
      }
    } catch (_) {}

    return false;
  }
}
