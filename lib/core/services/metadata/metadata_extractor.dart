import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:audio_metadata_reader/audio_metadata_reader.dart' as amr;
import 'package:ferro/data/entities/song_entity.dart';
import 'package:ferro/core/services/cache/artwork_cache_manager.dart';
import 'package:ferro/core/services/lyrics/lrc_auto_pairer.dart';

class ExtractedSongMetadata {
  const ExtractedSongMetadata({
    required this.title,
    required this.artist,
    required this.album,
    required this.genre,
    required this.format,
    required this.durationMs,
    required this.sampleRate,
    required this.bitDepth,
    required this.bitRate,
    required this.fileSizeBytes,
    this.year,
    this.trackNumber,
    this.discNumber,
    this.artworkBytes,
    this.isVideoAudio = false,
  });

  final String title;
  final String artist;
  final String album;
  final String genre;
  final String format;
  final int durationMs;
  final int sampleRate;
  final int bitDepth;
  final int bitRate;
  final int fileSizeBytes;
  final int? year;
  final int? trackNumber;
  final int? discNumber;
  final Uint8List? artworkBytes;
  final bool isVideoAudio;
}

class MetadataExtractor {
  MetadataExtractor({
    ArtworkCacheManager? cacheManager,
    LrcAutoPairer? lrcPairer,
  })  : _cacheManager = cacheManager ?? ArtworkCacheManager(),
        _lrcPairer = lrcPairer ?? LrcAutoPairer();

  final ArtworkCacheManager _cacheManager;
  final LrcAutoPairer _lrcPairer;

  /// Extracts full metadata from audio file at [filePath] and maps to [SongEntity].
  Future<SongEntity> extractSongEntity(String filePath) async {
    final meta = await extractMetadata(filePath);
    final song = SongEntity()
      ..filePath = filePath
      ..title = meta.title
      ..artist = meta.artist
      ..album = meta.album
      ..genre = meta.genre
      ..format = meta.format
      ..durationMs = meta.durationMs
      ..sampleRate = meta.sampleRate
      ..bitDepth = meta.bitDepth
      ..bitRate = meta.bitRate
      ..fileSize = meta.fileSizeBytes
      ..year = meta.year
      ..trackNumber = meta.trackNumber
      ..discNumber = meta.discNumber
      ..isVideoAudio = meta.isVideoAudio
      ..dateAdded = DateTime.now();

    // 1. Cache artwork if available
    if (meta.artworkBytes != null && meta.artworkBytes!.isNotEmpty) {
      final cacheKey = '${meta.artist}_${meta.album}_${meta.title}';
      song.artworkPath = await _cacheManager.saveArtwork(cacheKey, meta.artworkBytes!);
    }

    // 2. Auto-pair with .lrc lyrics in the same folder
    song.lrcPath = await _lrcPairer.findMatchingLrc(filePath);

    return song;
  }

  /// Low-level metadata extraction using audio_metadata_reader with fallback heuristic parsing.
  Future<ExtractedSongMetadata> extractMetadata(String filePath) async {
    final ext = p.extension(filePath).toLowerCase();
    final formatName = _detectFormat(ext);
    final isVideo = ext == '.mp4' || ext == '.mkv' || ext == '.webm';

    int fileSizeBytes = 0;
    if (!kIsWeb) {
      try {
        final f = File(filePath);
        if (await f.exists()) {
          fileSizeBytes = await f.length();
        }
      } catch (_) {}
    }

    if (!kIsWeb) {
      try {
        final f = File(filePath);
        if (await f.exists()) {
          final metadata = amr.readMetadata(f, getImage: true);

          final title = (metadata.title != null && metadata.title!.trim().isNotEmpty)
              ? metadata.title!.trim()
              : _parseTitleFromFilename(filePath);

          final artist = (metadata.artist != null && metadata.artist!.trim().isNotEmpty)
              ? metadata.artist!.trim()
              : _parseArtistFromFilename(filePath);

          final album = (metadata.album != null && metadata.album!.trim().isNotEmpty)
              ? metadata.album!.trim()
              : 'Unknown Album';

          final genre = (metadata.genres.isNotEmpty)
              ? metadata.genres.first.trim()
              : 'Audio';

          final durationMs = metadata.duration?.inMilliseconds ?? 0;
          final sampleRate = metadata.sampleRate ?? (formatName == 'FLAC' ? 96000 : 44100);
          final bitRate = metadata.bitrate ?? 320000;
          final bitDepth = (formatName == 'FLAC' || formatName == 'WAV') ? 24 : 16;

          Uint8List? artworkBytes;
          if (metadata.pictures.isNotEmpty) {
            artworkBytes = metadata.pictures.first.bytes;
          }

          return ExtractedSongMetadata(
            title: title,
            artist: artist,
            album: album,
            genre: genre,
            format: formatName,
            durationMs: durationMs > 0 ? durationMs : 180000,
            sampleRate: sampleRate,
            bitDepth: bitDepth,
            bitRate: bitRate,
            fileSizeBytes: fileSizeBytes,
            year: metadata.year?.year,
            trackNumber: metadata.trackNumber,
            discNumber: metadata.discNumber,
            artworkBytes: artworkBytes,
            isVideoAudio: isVideo,
          );
        }
      } catch (e) {
        debugPrint('audio_metadata_reader failed for $filePath ($e), applying fallback heuristic parser');
      }
    }

    // Fallback heuristic extraction from filename
    return ExtractedSongMetadata(
      title: _parseTitleFromFilename(filePath),
      artist: _parseArtistFromFilename(filePath),
      album: _parseAlbumFromDirectory(filePath),
      genre: isVideo ? 'Video' : 'Audio',
      format: formatName,
      durationMs: 210000,
      sampleRate: formatName == 'FLAC' ? 96000 : 44100,
      bitDepth: (formatName == 'FLAC' || formatName == 'WAV') ? 24 : 16,
      bitRate: 320000,
      fileSizeBytes: fileSizeBytes,
      isVideoAudio: isVideo,
    );
  }

  String _detectFormat(String extension) {
    switch (extension) {
      case '.flac':
        return 'FLAC';
      case '.wav':
        return 'WAV';
      case '.mp3':
        return 'MP3';
      case '.opus':
        return 'OPUS';
      case '.m4a':
        return 'M4A';
      case '.aac':
        return 'AAC';
      case '.ogg':
        return 'OGG';
      case '.mp4':
        return 'MP4';
      default:
        return extension.replaceAll('.', '').toUpperCase();
    }
  }

  String _parseTitleFromFilename(String filePath) {
    final base = p.basenameWithoutExtension(filePath);
    if (base.contains(' - ')) {
      final parts = base.split(' - ');
      if (parts.length >= 2) {
        return parts.last.trim();
      }
    }
    // Remove track number prefixes like "01. " or "01 - "
    return base.replaceAll(RegExp(r'^\d+[\s.-]+'), '').trim();
  }

  String _parseArtistFromFilename(String filePath) {
    final base = p.basenameWithoutExtension(filePath);
    if (base.contains(' - ')) {
      final parts = base.split(' - ');
      if (parts.length >= 2) {
        return parts.first.replaceAll(RegExp(r'^\d+[\s.-]+'), '').trim();
      }
    }
    return 'Unknown Artist';
  }

  String _parseAlbumFromDirectory(String filePath) {
    try {
      final parentName = p.basename(p.dirname(filePath));
      if (parentName.isNotEmpty && parentName != '/' && parentName != '.') {
        return parentName;
      }
    } catch (_) {}
    return 'Unknown Album';
  }
}
