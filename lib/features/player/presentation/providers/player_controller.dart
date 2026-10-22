import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ferro/data/sources/mock_catalog.dart';
import 'package:ferro/core/services/audio/ferro_audio_engine.dart';
import 'package:ferro/core/services/scanner/media_scanner.dart';
import 'package:ferro/domain/repositories/song_repository.dart';

import 'package:ferro/core/services/audio/sample_audio_generator.dart';

enum FerroRepeatMode {
  off,
  all,
  one,
}

/// Global player controller managing reactive playback state and queue.
class PlayerController extends ChangeNotifier {
  PlayerController._() {
    _songs = [];
    _currentSong = MockSong.empty();
    _queue = [];
    _history = [];
    _isPlaying = false;
    _position = Duration.zero;
    _duration = Duration.zero;
    _listenToAudioEngine();
    startTicker();
  }

  static final PlayerController instance = PlayerController._();

  static bool enableTicker = false;
  Timer? _ticker;

  void _listenToAudioEngine() {
    try {
      FerroAudioEngine.instance.positionStream.listen((pos) {
        _position = pos;
        notifyListeners();
      });
      FerroAudioEngine.instance.durationStream.listen((dur) {
        if (dur > Duration.zero) {
          _duration = dur;
          notifyListeners();
        }
      });
      FerroAudioEngine.instance.stateStream.listen((state) {
        if (state == AudioEngineState.playing) {
          _isPlaying = true;
        } else if (state == AudioEngineState.paused || state == AudioEngineState.idle) {
          _isPlaying = false;
        } else if (state == AudioEngineState.completed) {
          next();
        }
        notifyListeners();
      });
    } catch (_) {}
  }

  void startTicker() {
    _ticker?.cancel();
    if (!enableTicker) return;
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_isPlaying) {
        if (_position < _duration) {
          _position += const Duration(seconds: 1);
          notifyListeners();
        } else {
          next();
        }
      }
    });
  }

  void stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  late List<MockSong> _songs;
  late MockSong _currentSong;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  final Duration _bufferedPosition = Duration.zero;
  double _volume = 0.75;
  FerroRepeatMode _repeatMode = FerroRepeatMode.all;
  bool _isShuffle = false;

  late List<MockSong> _queue;
  late List<MockSong> _history;

  bool _isScanning = false;
  String _scanStatus = '';

  // Getters
  List<MockSong> get allSongs => List.unmodifiable(_songs);
  bool get isLibraryEmpty => _songs.isEmpty;
  bool get isScanning => _isScanning;
  String get scanStatus => _scanStatus;

  MockSong get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;
  Duration get bufferedPosition => _bufferedPosition;
  double get volume => _volume;
  FerroRepeatMode get repeatMode => _repeatMode;
  bool get isShuffle => _isShuffle;
  List<MockSong> get queue => List.unmodifiable(_queue);
  List<MockSong> get history => List.unmodifiable(_history);

  void setLibrarySongs(List<MockSong> songs) {
    _songs = List.from(songs);
    _queue = List.from(songs);
    if (songs.isNotEmpty) {
      if (!_songs.any((s) => s.id == _currentSong.id)) {
        _currentSong = songs.first;
        _position = Duration.zero;
        _duration = _currentSong.duration;
      }
    }
    notifyListeners();
  }

  void play(MockSong song) => playSong(song);

  void playSong(MockSong song) {
    if (!_history.contains(_currentSong)) {
      _history.insert(0, _currentSong);
    }
    _currentSong = song;
    _position = Duration.zero;
    _duration = song.duration;
    _isPlaying = true;
    notifyListeners();

    try {
      FerroAudioEngine.instance.playSong(song.toEntity());
    } catch (_) {}
  }

  void togglePlayPause() {
    _isPlaying = !_isPlaying;
    notifyListeners();

    try {
      if (_isPlaying) {
        FerroAudioEngine.instance.play();
      } else {
        FerroAudioEngine.instance.pause();
      }
    } catch (_) {}
  }

  void seek(Duration newPosition) {
    _position = newPosition;
    notifyListeners();

    try {
      FerroAudioEngine.instance.seek(newPosition);
    } catch (_) {}
  }

  void setVolume(double newVolume) {
    _volume = newVolume.clamp(0.0, 1.0);
    notifyListeners();

    try {
      FerroAudioEngine.instance.setVolume(_volume);
    } catch (_) {}
  }

  /// Scans device storage using MediaScanner and populates the player library.
  Future<int> scanDeviceMusic(SongRepository songRepository) async {
    _isScanning = true;
    _scanStatus = 'Memulai pemindaian...';
    notifyListeners();

    try {
      final scanner = MediaScanner(songRepository: songRepository);
      final paths = <String>[];
      if (Platform.isAndroid) {
        paths.addAll([
          '/storage/emulated/0/Music',
          '/storage/emulated/0/Download',
          '/sdcard/Music',
        ]);
      } else if (Platform.isWindows) {
        final userProfile = Platform.environment['USERPROFILE'];
        if (userProfile != null) {
          paths.add('$userProfile\\Music');
          paths.add('$userProfile\\Downloads');
        }
      }

      await for (final progress in scanner.scanDirectories(paths)) {
        _scanStatus = 'Memindai: ${progress.songsDiscovered} lagu ditemukan...';
        notifyListeners();
      }

      final entities = await songRepository.getAllSongs();
      if (entities.isNotEmpty) {
        setLibrarySongs(entities.map(MockSong.fromEntity).toList());
      }
      return entities.length;
    } catch (e) {
      debugPrint('Scan storage error: $e');
      return 0;
    } finally {
      _isScanning = false;
      _scanStatus = '';
      notifyListeners();
    }
  }

  /// Generates real local WAV audio files on device to test genuine physical playback.
  Future<int> generateSamplePlayableTracks(SongRepository songRepository) async {
    _isScanning = true;
    _scanStatus = 'Menyiapkan sample audio stereo PCM nyata...';
    notifyListeners();

    try {
      final samples = await SampleAudioGenerator.generateLocalSampleTracks();
      if (samples.isNotEmpty) {
        await songRepository.insertOrUpdateAll(samples);
        final all = await songRepository.getAllSongs();
        setLibrarySongs(all.map(MockSong.fromEntity).toList());
        return all.length;
      }
      return 0;
    } catch (e) {
      debugPrint('Error generating sample tracks: $e');
      return 0;
    } finally {
      _isScanning = false;
      _scanStatus = '';
      notifyListeners();
    }
  }

  void next() {
    final currentIndex = _queue.indexOf(_currentSong);
    if (currentIndex != -1 && currentIndex < _queue.length - 1) {
      playSong(_queue[currentIndex + 1]);
    } else if (_queue.isNotEmpty) {
      playSong(_queue.first);
    }
  }

  void previous() {
    if (_position.inSeconds > 3) {
      seek(Duration.zero);
      return;
    }
    final currentIndex = _queue.indexOf(_currentSong);
    if (currentIndex > 0) {
      playSong(_queue[currentIndex - 1]);
    } else if (_history.isNotEmpty) {
      playSong(_history.first);
    } else {
      seek(Duration.zero);
    }
  }

  void toggleRepeat() {
    switch (_repeatMode) {
      case FerroRepeatMode.off:
        _repeatMode = FerroRepeatMode.all;
      case FerroRepeatMode.all:
        _repeatMode = FerroRepeatMode.one;
      case FerroRepeatMode.one:
        _repeatMode = FerroRepeatMode.off;
    }
    notifyListeners();
  }

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  void toggleFavorite() {
    final index = _queue.indexWhere((s) => s.id == _currentSong.id);
    final updated = MockSong(
      id: _currentSong.id,
      title: _currentSong.title,
      artist: _currentSong.artist,
      album: _currentSong.album,
      duration: _currentSong.duration,
      genre: _currentSong.genre,
      format: _currentSong.format,
      quality: _currentSong.quality,
      accentColor: _currentSong.accentColor,
      artworkUrl: _currentSong.artworkUrl,
      playCount: _currentSong.playCount,
      isFavorite: !_currentSong.isFavorite,
    );

    _currentSong = updated;
    if (index != -1) {
      _queue[index] = updated;
    }
    notifyListeners();
  }

  void reorderQueueItem(int oldIndex, int newIndex) {
    final item = _queue.removeAt(oldIndex);
    _queue.insert(newIndex, item);
    notifyListeners();
  }

  void reorderQueue(int oldIndex, int newIndex) {
    var targetIndex = newIndex;
    if (oldIndex < targetIndex) {
      targetIndex -= 1;
    }
    final item = _queue.removeAt(oldIndex);
    _queue.insert(targetIndex, item);
    notifyListeners();
  }

  void removeFromQueue(int index) {
    if (index >= 0 && index < _queue.length) {
      _queue.removeAt(index);
      notifyListeners();
    }
  }
}
