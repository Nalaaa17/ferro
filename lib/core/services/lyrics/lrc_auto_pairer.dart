import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:ferro/features/lyrics/domain/entities/lyric_line.dart';

class LrcAutoPairer {
  LrcAutoPairer();

  /// Looks for a matching `.lrc` file in the same directory as [audioFilePath].
  /// Matches case-insensitively (e.g. `Song.flac` -> `Song.lrc`, `song.lrc`, `Song.LRC`).
  Future<String?> findMatchingLrc(String audioFilePath) async {
    if (kIsWeb) return null;

    try {
      final audioFile = File(audioFilePath);
      final dir = audioFile.parent;
      if (!await dir.exists()) return null;

      final baseNameWithoutExt = p.basenameWithoutExtension(audioFilePath).toLowerCase().trim();

      // Check direct candidate paths first for speed
      final directCandidate = p.setExtension(audioFilePath, '.lrc');
      if (await File(directCandidate).exists()) {
        return directCandidate;
      }

      final directCandidateUpper = p.setExtension(audioFilePath, '.LRC');
      if (await File(directCandidateUpper).exists()) {
        return directCandidateUpper;
      }

      // Check siblings in the same directory
      final entities = await dir.list(followLinks: false).toList();
      for (final entity in entities) {
        if (entity is File) {
          final ext = p.extension(entity.path).toLowerCase();
          if (ext == '.lrc') {
            final siblingName = p.basenameWithoutExtension(entity.path).toLowerCase().trim();
            if (siblingName == baseNameWithoutExt) {
              return entity.path;
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error finding LRC for $audioFilePath: $e');
    }

    return null;
  }

  /// Reads and parses an LRC file from disk, returning validated [LyricLine]s.
  Future<List<LyricLine>> readLrcFile(String lrcFilePath) async {
    if (kIsWeb) return [];

    try {
      final file = File(lrcFilePath);
      if (!await file.exists()) return [];

      final content = await file.readAsString();
      return MockLyricsData.parseLrc(content);
    } catch (e) {
      debugPrint('Failed to read LRC file at $lrcFilePath: $e');
      return [];
    }
  }
}
