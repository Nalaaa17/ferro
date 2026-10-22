import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferro/data/entities/entities.dart';
import 'package:ferro/data/repositories/repositories.dart';
import 'package:ferro/core/services/cache/artwork_cache_manager.dart';
import 'package:ferro/core/services/lyrics/lrc_auto_pairer.dart';
import 'package:ferro/core/services/metadata/metadata_extractor.dart';
import 'package:ferro/core/services/scanner/media_scanner.dart';

void main() {
  group('Fase 6: Isar Entities & Repository Pattern Tests', () {
    test('SongEntity computes durationString and initializes defaults correctly', () {
      final song = SongEntity()
        ..filePath = '/sdcard/Music/test.flac'
        ..title = 'Instant Crush'
        ..artist = 'Daft Punk'
        ..album = 'Random Access Memories'
        ..genre = 'Indie Pop'
        ..format = 'FLAC'
        ..durationMs = 337000
        ..sampleRate = 96000
        ..bitDepth = 24
        ..bitRate = 3200000
        ..fileSize = 124500000;

      expect(song.durationString, '05:37');
      expect(song.isFavorite, isFalse);
      expect(song.playCount, 0);
      expect(song.isVideoAudio, isFalse);
    });

    test('PlaylistEntity, DeviceProfileEntity, and EQPresetEntity hold complete properties', () {
      final playlist = PlaylistEntity()
        ..name = 'Night Cruising'
        ..description = 'Synthwave and chill';
      expect(playlist.name, 'Night Cruising');

      final profile = DeviceProfileEntity()
        ..deviceIdentifier = 'AA:BB:CC:DD:EE:FF'
        ..name = 'Soundcore R50i'
        ..connectionType = 'bluetooth'
        ..eqPresetId = 2
        ..targetVolume = 0.8;
      expect(profile.deviceIdentifier, 'AA:BB:CC:DD:EE:FF');
      expect(profile.targetVolume, 0.8);

      final eq = EQPresetEntity()
        ..name = 'Rock'
        ..bands = [4.5, 3.0, 1.5, 0, -1.0, 0, 2.0, 3.5, 4.0, 4.5]
        ..bassBoost = 25.0
        ..virtualizer = 15.0;
      expect(eq.bands.length, 10);
      expect(eq.bassBoost, 25.0);
    });

    test('SongRepository performs full CRUD, search, and reactive sorting', () async {
      final repo = MockSongRepository();

      final allSongs = await repo.getAllSongs();
      expect(allSongs.isNotEmpty, isTrue);

      // Search by title or artist
      final searchResults = await repo.searchSongs('Beatles');
      expect(searchResults.length, 2);
      expect(searchResults.every((s) => s.artist.contains('Beatles')), isTrue);

      // Filter by genre
      final electronic = await repo.getSongsByGenre('Electronic');
      expect(electronic.isNotEmpty, isTrue);

      // Favorite toggle
      final firstSong = allSongs.first;
      final initialFav = firstSong.isFavorite;
      await repo.toggleFavorite(firstSong.id);
      final updated = await repo.getSongById(firstSong.id);
      expect(updated?.isFavorite, !initialFav);

      // Increment play count
      final initialPlays = updated?.playCount ?? 0;
      await repo.incrementPlayCount(firstSong.id);
      final played = await repo.getSongById(firstSong.id);
      expect(played?.playCount, initialPlays + 1);

      // Insert new custom song
      final custom = SongEntity()
        ..filePath = '/storage/emulated/0/Music/CustomTrack.wav'
        ..title = 'Audiophile Master Test'
        ..artist = 'Studio Ferro'
        ..album = 'Benchmark 2026'
        ..genre = 'Test Tone'
        ..format = 'WAV'
        ..durationMs = 120000
        ..sampleRate = 192000
        ..bitDepth = 24
        ..bitRate = 4608000
        ..fileSize = 55000000;

      final newId = await repo.insertOrUpdateSong(custom);
      expect(newId, greaterThan(0));

      final retrieved = await repo.getSongByPath('/storage/emulated/0/Music/CustomTrack.wav');
      expect(retrieved?.title, 'Audiophile Master Test');

      // Delete song
      final deleted = await repo.deleteSong(newId);
      expect(deleted, isTrue);
      expect(await repo.getSongById(newId), isNull);
    });

    test('PlaylistRepository performs creation, track linkage, and removal', () async {
      final repo = MockPlaylistRepository();

      final pId = await repo.createPlaylist('Favorites Hi-Res', description: 'FLAC only');
      expect(pId, greaterThan(0));

      final playlist = await repo.getPlaylistById(pId);
      expect(playlist?.name, 'Favorites Hi-Res');

      final dummySong = SongEntity()
        ..id = 101
        ..filePath = '/path/song.flac'
        ..title = 'One More Time'
        ..artist = 'Daft Punk'
        ..album = 'Discovery'
        ..genre = 'Electronic'
        ..format = 'FLAC'
        ..durationMs = 320000
        ..sampleRate = 44100
        ..bitDepth = 16
        ..bitRate = 320000
        ..fileSize = 35000000;

      await repo.addSongToPlaylist(pId, dummySong);
      var songs = await repo.getSongsInPlaylist(pId);
      expect(songs.length, 1);
      expect(songs.first.title, 'One More Time');

      await repo.removeSongFromPlaylist(pId, 101);
      songs = await repo.getSongsInPlaylist(pId);
      expect(songs, isEmpty);

      final deleted = await repo.deletePlaylist(pId);
      expect(deleted, isTrue);
      expect(await repo.getPlaylistById(pId), isNull);
    });
  });

  group('Fase 7: Media Scanner & Metadata Extraction Tests', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('ferro_scanner_test_');
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('LrcAutoPairer discovers matching .lrc file in the same folder', () async {
      final audioFile = File('${tempDir.path}/01 - Discovery - Aerodynamic.flac');
      await audioFile.writeAsString('dummy audio data');

      final lrcFile = File('${tempDir.path}/01 - Discovery - Aerodynamic.lrc');
      await lrcFile.writeAsString('''[00:00.00]Guitars begin
[00:15.50]Solo kicks in
[00:30.00]Electronic groove''');

      final pairer = LrcAutoPairer();
      final pairedPath = await pairer.findMatchingLrc(audioFile.path);

      expect(pairedPath, isNotNull);
      expect(pairedPath, lrcFile.path);

      final lyrics = await pairer.readLrcFile(pairedPath!);
      expect(lyrics.length, 3);
      expect(lyrics.first.text, 'Guitars begin');
      expect(lyrics[1].timestamp, const Duration(seconds: 15, milliseconds: 500));
    });

    test('ArtworkCacheManager saves and retrieves artwork thumbnails', () async {
      final cacheDir = '${tempDir.path}/cache';
      final manager = ArtworkCacheManager(customCacheDir: cacheDir);

      final dummyBytes = Uint8List.fromList([0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10]);
      const key = 'Daft_Punk_Discovery_Cover';

      final savedPath = await manager.saveArtwork(key, dummyBytes);
      expect(savedPath, isNotNull);
      expect(File(savedPath!).existsSync(), isTrue);

      final cachedPath = await manager.getCachedArtworkPath(key);
      expect(cachedPath, savedPath);

      await manager.clearCache();
      expect(File(savedPath).existsSync(), isFalse);
    });

    test('MetadataExtractor heuristics parse filename and formats properly', () async {
      final extractor = MetadataExtractor();

      final meta1 = await extractor.extractMetadata('/storage/Music/Kavinsky - Nightcall.flac');
      expect(meta1.title, 'Nightcall');
      expect(meta1.artist, 'Kavinsky');
      expect(meta1.format, 'FLAC');
      expect(meta1.bitDepth, 24);
      expect(meta1.isVideoAudio, isFalse);

      final meta2 = await extractor.extractMetadata('/storage/Videos/Concert Live Session.mp4');
      expect(meta2.title, 'Concert Live Session');
      expect(meta2.format, 'MP4');
      expect(meta2.isVideoAudio, isTrue);
    });

    test('MediaScanner traverses directory, identifies valid formats, and ignores excluded folders', () async {
      // 1. Create supported audio files
      final musicDir = Directory('${tempDir.path}/Music');
      await musicDir.create();
      await File('${musicDir.path}/Daft Punk - One More Time.flac').writeAsString('flac content');
      await File('${musicDir.path}/The Beatles - Come Together.wav').writeAsString('wav content');

      // 2. Create excluded folder (.nomedia)
      final excludedDir = Directory('${tempDir.path}/HiddenAssets');
      await excludedDir.create();
      await File('${excludedDir.path}/.nomedia').writeAsString('');
      await File('${excludedDir.path}/Secret Audio.mp3').writeAsString('ignore me');

      // 3. Create non-audio file
      await File('${musicDir.path}/notes.txt').writeAsString('text file');

      final repo = MockSongRepository();
      final scanner = MediaScanner(songRepository: repo);

      final progressEvents = await scanner.scanDirectories([tempDir.path]).toList();

      expect(progressEvents.isNotEmpty, isTrue);
      final last = progressEvents.last;
      expect(last.isCompleted, isTrue);
      expect(last.songsDiscovered, 2);

      final scannedSongs = await repo.getAllSongs();
      final titles = scannedSongs.map((s) => s.title).toList();
      expect(titles.contains('One More Time'), isTrue);
      expect(titles.contains('Come Together'), isTrue);
      expect(titles.contains('Secret Audio'), isFalse);
    });
  });
}
