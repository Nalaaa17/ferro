import 'package:flutter/material.dart';
import 'package:ferro/data/entities/song_entity.dart';

class MockSong {
  const MockSong({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
    required this.genre,
    required this.format,
    required this.quality,
    required this.accentColor,
    this.artworkUrl,
    this.playCount = 0,
    this.isFavorite = false,
    this.isVideoAudio = false,
    this.fileSizeBytes = '28.4 MB',
    this.filePath,
    this.lrcPath,
  });

  final String id;
  final String title;
  final String artist;
  final String album;
  final Duration duration;
  final String genre;
  final String format; // FLAC, MP3, WAV, OPUS, MP4
  final String quality; // 192kHz/24bit, 96kHz/24bit, 44.1kHz/16bit, 320kbps
  final Color accentColor;
  final String? artworkUrl;
  final int playCount;
  final bool isFavorite;
  final bool isVideoAudio; // MP4 video-audio background playback mode per PRD §2.1
  final String fileSizeBytes;
  final String? filePath;
  final String? lrcPath;

  bool get isEmpty => id.isEmpty;
  bool get isNotEmpty => id.isNotEmpty;

  factory MockSong.empty() {
    return const MockSong(
      id: '',
      title: 'Belum Ada Lagu Diputar',
      artist: 'Ferro Hi-Res Audio',
      album: 'Pustaka Musik',
      duration: Duration.zero,
      genre: 'Semua',
      format: 'OFFLINE',
      quality: 'Ready',
      accentColor: Color(0xFFFF7A1A),
    );
  }

  factory MockSong.fromEntity(SongEntity e) {
    Color color;
    switch (e.format.toUpperCase()) {
      case 'FLAC':
        color = const Color(0xFFFFB800);
        break;
      case 'WAV':
        color = const Color(0xFF3897F0);
        break;
      case 'MP4':
        color = const Color(0xFFFFAA00);
        break;
      case 'OPUS':
        color = const Color(0xFF9E7BFF);
        break;
      default:
        color = const Color(0xFFFF7A1A);
    }

    final qualityStr = e.sampleRate > 0
        ? '${(e.sampleRate / 1000).toStringAsFixed(0)}kHz/${e.bitDepth}bit'
        : e.format;

    final sizeStr = e.fileSize > 0
        ? '${(e.fileSize / (1024 * 1024)).toStringAsFixed(1)} MB'
        : '0 MB';

    return MockSong(
      id: e.id.toString(),
      title: e.title,
      artist: e.artist,
      album: e.album,
      duration: Duration(milliseconds: e.durationMs),
      genre: e.genre,
      format: e.format,
      quality: qualityStr,
      accentColor: color,
      artworkUrl: e.artworkPath,
      playCount: e.playCount,
      isFavorite: e.isFavorite,
      isVideoAudio: e.isVideoAudio,
      fileSizeBytes: sizeStr,
      filePath: e.filePath,
      lrcPath: e.lrcPath,
    );
  }

  SongEntity toEntity() {
    return SongEntity()
      ..id = int.tryParse(id) ?? 0
      ..filePath = filePath ?? ''
      ..title = title
      ..artist = artist
      ..album = album
      ..genre = genre
      ..format = format
      ..durationMs = duration.inMilliseconds
      ..sampleRate = quality.contains('192') ? 192000 : (quality.contains('96') ? 96000 : 44100)
      ..bitDepth = quality.contains('24') ? 24 : 16
      ..bitRate = 320000
      ..fileSize = 35000000
      ..artworkPath = artworkUrl
      ..lrcPath = lrcPath
      ..playCount = playCount
      ..isFavorite = isFavorite
      ..isVideoAudio = isVideoAudio;
  }

  String get durationString {
    final m = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class MockAlbum {
  const MockAlbum({
    required this.id,
    required this.title,
    required this.artist,
    required this.year,
    required this.trackCount,
    required this.songs,
    this.artworkUrl,
  });

  final String id;
  final String title;
  final String artist;
  final int year;
  final int trackCount;
  final List<MockSong> songs;
  final String? artworkUrl;
}

class MockCatalog {
  MockCatalog._();

  static const List<MockSong> songs = [
    MockSong(
      id: '1',
      title: 'One More Time',
      artist: 'Daft Punk',
      album: 'Discovery',
      duration: Duration(minutes: 5, seconds: 20),
      genre: 'Electronic',
      format: 'FLAC',
      quality: '44.1kHz/16bit',
      accentColor: Color(0xFFFF526C),
      playCount: 142,
      fileSizeBytes: '38.6 MB',
    ),
    MockSong(
      id: '2',
      title: 'Harder, Better, Faster, Stronger',
      artist: 'Daft Punk',
      album: 'Discovery',
      duration: Duration(minutes: 3, seconds: 44),
      genre: 'Electronic',
      format: 'FLAC',
      quality: '44.1kHz/16bit',
      accentColor: Color(0xFFFF7A1A),
      playCount: 120,
      fileSizeBytes: '26.2 MB',
    ),
    MockSong(
      id: '3',
      title: 'Something About Us',
      artist: 'Daft Punk',
      album: 'Discovery',
      duration: Duration(minutes: 3, seconds: 51),
      genre: 'Electronic',
      format: 'FLAC',
      quality: '44.1kHz/16bit',
      accentColor: Color(0xFF6B42FF),
      playCount: 98,
      fileSizeBytes: '27.4 MB',
    ),
    MockSong(
      id: '4',
      title: 'Get Lucky (feat. Pharrell Williams)',
      artist: 'Daft Punk',
      album: 'Random Access Memories',
      duration: Duration(minutes: 4, seconds: 8),
      genre: 'Disco / Funk',
      format: 'FLAC',
      quality: '96kHz/24bit Hi-Res',
      accentColor: Color(0xFFFFB800),
      playCount: 215,
      isFavorite: true,
      fileSizeBytes: '94.2 MB',
    ),
    MockSong(
      id: '5',
      title: 'Instant Crush (feat. Julian Casablancas)',
      artist: 'Daft Punk',
      album: 'Random Access Memories',
      duration: Duration(minutes: 5, seconds: 37),
      genre: 'Indie Pop',
      format: 'FLAC',
      quality: '96kHz/24bit Hi-Res',
      accentColor: Color(0xFF2DD4A7),
      playCount: 180,
      isFavorite: true,
      fileSizeBytes: '124.5 MB',
    ),
    MockSong(
      id: '6',
      title: 'Come Together',
      artist: 'The Beatles',
      album: 'Abbey Road (2019 Mix)',
      duration: Duration(minutes: 4, seconds: 19),
      genre: 'Classic Rock',
      format: 'WAV',
      quality: '96kHz/24bit Studio Master',
      accentColor: Color(0xFF3897F0),
      playCount: 88,
      fileSizeBytes: '102.1 MB',
    ),
    MockSong(
      id: '7',
      title: 'Here Comes The Sun',
      artist: 'The Beatles',
      album: 'Abbey Road (2019 Mix)',
      duration: Duration(minutes: 3, seconds: 5),
      genre: 'Classic Rock',
      format: 'WAV',
      quality: '96kHz/24bit Studio Master',
      accentColor: Color(0xFFFF7A1A),
      playCount: 110,
      fileSizeBytes: '72.8 MB',
    ),
    MockSong(
      id: '8',
      title: 'Time',
      artist: 'Pink Floyd',
      album: 'The Dark Side of the Moon',
      duration: Duration(minutes: 6, seconds: 53),
      genre: 'Progressive Rock',
      format: 'FLAC',
      quality: '192kHz/24bit Hi-Res',
      accentColor: Color(0xFF2DD4A7),
      playCount: 76,
      fileSizeBytes: '268.0 MB',
    ),
    MockSong(
      id: '9',
      title: 'Starboy',
      artist: 'The Weeknd',
      album: 'Starboy',
      duration: Duration(minutes: 3, seconds: 50),
      genre: 'R&B / Pop',
      format: 'MP3',
      quality: '320kbps CBR',
      accentColor: Color(0xFFFF3D5A),
      playCount: 95,
      fileSizeBytes: '9.2 MB',
    ),
    MockSong(
      id: '10',
      title: 'Hotel California',
      artist: 'Eagles',
      album: 'Hotel California',
      duration: Duration(minutes: 6, seconds: 30),
      genre: 'Classic Rock',
      format: 'FLAC',
      quality: '96kHz/24bit Hi-Res',
      accentColor: Color(0xFFFF9447),
      playCount: 160,
      fileSizeBytes: '148.6 MB',
    ),
    MockSong(
      id: '11',
      title: 'Nightcall (Synthwave Master)',
      artist: 'Kavinsky',
      album: 'OutRun',
      duration: Duration(minutes: 4, seconds: 19),
      genre: 'Synthwave',
      format: 'WAV',
      quality: '48kHz/24bit Lossless',
      accentColor: Color(0xFFFF0055),
      playCount: 135,
      fileSizeBytes: '76.4 MB',
    ),
    MockSong(
      id: '12',
      title: 'Resonance',
      artist: 'HOME',
      album: 'Odyssey',
      duration: Duration(minutes: 3, seconds: 32),
      genre: 'Lo-Fi / Chill',
      format: 'MP3',
      quality: '320kbps CBR',
      accentColor: Color(0xFF00D4FF),
      playCount: 190,
      fileSizeBytes: '8.4 MB',
    ),
    MockSong(
      id: '13',
      title: 'Live Acoustic Session (Concert Video Audio)',
      artist: 'Ferro Session Band',
      album: 'Studio Unplugged',
      duration: Duration(minutes: 5, seconds: 12),
      genre: 'Acoustic',
      format: 'MP4',
      quality: 'Video-Audio 48kHz/24bit',
      accentColor: Color(0xFFFFAA00),
      playCount: 64,
      isVideoAudio: true,
      fileSizeBytes: '185.0 MB',
    ),
    MockSong(
      id: '14',
      title: 'Midnight Coffee Dialogues (Voice Podcast)',
      artist: 'Audiophile Sessions',
      album: 'Coffee Talks Episode 12',
      duration: Duration(minutes: 8, seconds: 40),
      genre: 'Podcast / Speech',
      format: 'OPUS',
      quality: '128kbps VBR Speech',
      accentColor: Color(0xFF9E7BFF),
      playCount: 42,
      fileSizeBytes: '8.1 MB',
    ),
  ];

  static const List<MockAlbum> albums = [
    MockAlbum(
      id: 'a1',
      title: 'Discovery',
      artist: 'Daft Punk',
      year: 2001,
      trackCount: 14,
      songs: [],
    ),
    MockAlbum(
      id: 'a2',
      title: 'Random Access Memories',
      artist: 'Daft Punk',
      year: 2013,
      trackCount: 13,
      songs: [],
    ),
    MockAlbum(
      id: 'a3',
      title: 'Abbey Road',
      artist: 'The Beatles',
      year: 1969,
      trackCount: 17,
      songs: [],
    ),
    MockAlbum(
      id: 'a4',
      title: 'The Dark Side of the Moon',
      artist: 'Pink Floyd',
      year: 1973,
      trackCount: 10,
      songs: [],
    ),
    MockAlbum(
      id: 'a5',
      title: 'OutRun',
      artist: 'Kavinsky',
      year: 2013,
      trackCount: 13,
      songs: [],
    ),
  ];

  static const List<String> genres = [
    'Electronic',
    'Classic Rock',
    'Disco / Funk',
    'Indie Pop',
    'Progressive Rock',
    'R&B / Pop',
    'Synthwave',
    'Lo-Fi / Chill',
    'Acoustic',
    'Podcast / Speech',
    'Jazz',
  ];

  static const List<String> folders = [
    'Internal Storage/Music/Hi-Res',
    'Internal Storage/Download/FLAC',
    'MicroSD/Audiophile/DSD_WAV',
    'USB-OTG/Music_Backup',
    'Internal Storage/Videos/Concerts_MP4',
  ];
}
