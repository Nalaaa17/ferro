import 'package:flutter/material.dart';

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
  });

  final String id;
  final String title;
  final String artist;
  final String album;
  final Duration duration;
  final String genre;
  final String format; // FLAC, MP3, WAV, OPUS
  final String quality; // 96kHz/24bit, 320kbps
  final Color accentColor;
  final String? artworkUrl;
  final int playCount;
  final bool isFavorite;

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
    ),
    MockSong(
      id: '6',
      title: 'Come Together',
      artist: 'The Beatles',
      album: 'Abbey Road (2019 Mix)',
      duration: Duration(minutes: 4, seconds: 19),
      genre: 'Classic Rock',
      format: 'WAV',
      quality: '96kHz/24bit',
      accentColor: Color(0xFF3897F0),
      playCount: 88,
    ),
    MockSong(
      id: '7',
      title: 'Here Comes The Sun',
      artist: 'The Beatles',
      album: 'Abbey Road (2019 Mix)',
      duration: Duration(minutes: 3, seconds: 5),
      genre: 'Classic Rock',
      format: 'WAV',
      quality: '96kHz/24bit',
      accentColor: Color(0xFFFF7A1A),
      playCount: 110,
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
    ),
    MockSong(
      id: '9',
      title: 'Starboy',
      artist: 'The Weeknd',
      album: 'Starboy',
      duration: Duration(minutes: 3, seconds: 50),
      genre: 'R&B / Pop',
      format: 'MP3',
      quality: '320kbps',
      accentColor: Color(0xFFFF3D5A),
      playCount: 95,
    ),
    MockSong(
      id: '10',
      title: 'Hotel California',
      artist: 'Eagles',
      album: 'Hotel California',
      duration: Duration(minutes: 6, seconds: 30),
      genre: 'Classic Rock',
      format: 'FLAC',
      quality: '96kHz/24bit',
      accentColor: Color(0xFFFF9447),
      playCount: 160,
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
  ];

  static const List<String> genres = [
    'Electronic',
    'Classic Rock',
    'Disco / Funk',
    'Indie Pop',
    'Progressive Rock',
    'R&B / Pop',
    'Acoustic',
    'Jazz',
  ];

  static const List<String> folders = [
    'Internal Storage/Music/Hi-Res',
    'Internal Storage/Download/FLAC',
    'MicroSD/Audiophile/DSD_WAV',
    'USB-OTG/Music_Backup',
  ];
}
