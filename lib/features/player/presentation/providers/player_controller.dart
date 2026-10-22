import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ferro/data/sources/mock_catalog.dart';

enum FerroRepeatMode {
  off,
  all,
  one,
}

/// Global player controller managing reactive playback state and queue for browser testing.
class PlayerController extends ChangeNotifier {
  PlayerController._() {
    _currentSong = MockCatalog.songs.first;
    _queue = List.from(MockCatalog.songs);
    _history = [];
    startTicker();
  }

  static final PlayerController instance = PlayerController._();

  static bool enableTicker = false;
  Timer? _ticker;

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

  late MockSong _currentSong;
  bool _isPlaying = true;
  Duration _position = const Duration(minutes: 1, seconds: 24);
  Duration _duration = const Duration(minutes: 5, seconds: 20);
  final Duration _bufferedPosition = const Duration(minutes: 3, seconds: 10);
  double _volume = 0.75;
  FerroRepeatMode _repeatMode = FerroRepeatMode.all;
  bool _isShuffle = false;

  late List<MockSong> _queue;
  late List<MockSong> _history;

  // Getters
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
  }

  void togglePlayPause() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void seek(Duration newPosition) {
    _position = newPosition;
    notifyListeners();
  }

  void setVolume(double newVolume) {
    _volume = newVolume.clamp(0.0, 1.0);
    notifyListeners();
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
