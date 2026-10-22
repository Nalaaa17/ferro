import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ArtworkCacheManager {
  ArtworkCacheManager({this.customCacheDir});

  final String? customCacheDir;
  String? _initializedDir;

  Future<String> getCacheDirectory() async {
    if (_initializedDir != null) return _initializedDir!;

    final custom = customCacheDir;
    if (custom != null) {
      _initializedDir = custom;
    } else if (kIsWeb) {
      _initializedDir = 'ferro_artwork_cache';
    } else {
      final base = await getApplicationCacheDirectory();
      _initializedDir = p.join(base.path, 'ferro_artwork');
    }

    if (!kIsWeb) {
      final dir = Directory(_initializedDir!);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
    }

    return _initializedDir!;
  }

  /// Hashes key (e.g. audio file path or album+artist) to MD5 filename.
  String generateCacheKey(String key) {
    final bytes = utf8.encode(key);
    return md5.convert(bytes).toString();
  }

  /// Saves artwork bytes to local cache disk and returns the cached file path.
  Future<String?> saveArtwork(String key, Uint8List imageBytes) async {
    if (imageBytes.isEmpty || kIsWeb) return null;

    try {
      final cacheDir = await getCacheDirectory();
      final hash = generateCacheKey(key);
      final filePath = p.join(cacheDir, '$hash.jpg');

      final file = File(filePath);
      if (await file.exists()) {
        return filePath;
      }

      await file.writeAsBytes(imageBytes, flush: true);
      return filePath;
    } catch (e) {
      debugPrint('Failed to cache artwork for $key: $e');
      return null;
    }
  }

  /// Checks if cached artwork already exists for key.
  Future<String?> getCachedArtworkPath(String key) async {
    if (kIsWeb) return null;

    try {
      final cacheDir = await getCacheDirectory();
      final hash = generateCacheKey(key);
      final filePath = p.join(cacheDir, '$hash.jpg');

      final file = File(filePath);
      if (await file.exists()) {
        return filePath;
      }
    } catch (_) {}
    return null;
  }

  /// Clears all cached artwork images from disk.
  Future<void> clearCache() async {
    if (kIsWeb) return;
    try {
      final cacheDir = await getCacheDirectory();
      final dir = Directory(cacheDir);
      if (await dir.exists()) {
        await dir.delete(recursive: true);
        await dir.create(recursive: true);
      }
    } catch (e) {
      debugPrint('Failed to clear artwork cache: $e');
    }
  }
}
