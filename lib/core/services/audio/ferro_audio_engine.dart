import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:media_kit/media_kit.dart';
import 'package:ferro/data/entities/entities.dart';

enum AudioEngineState {
  idle,
  buffering,
  playing,
  paused,
  completed,
}

class FerroAudioEngine {
  FerroAudioEngine._();
  static final FerroAudioEngine instance = FerroAudioEngine._();

  Player? _player;
  bool _isInitialized = false;

  // Equalizer frequencies for 10 bands
  static const List<double> eqFrequencies = [
    31.25,
    62.5,
    125.0,
    250.0,
    500.0,
    1000.0,
    2000.0,
    4000.0,
    8000.0,
    16000.0,
  ];

  List<double> _currentBands = List.filled(10, 0.0);
  double _volume = 0.75;
  int _crossfadeSeconds = 0; // 0 - 12 seconds
  bool _isGapless = true;

  // Stream controllers for reactive listeners
  final _stateController = StreamController<AudioEngineState>.broadcast();
  final _positionController = StreamController<Duration>.broadcast();
  final _durationController = StreamController<Duration>.broadcast();

  Stream<AudioEngineState> get stateStream => _stateController.stream;
  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration> get durationStream => _durationController.stream;

  double get volume => _volume;
  int get crossfadeSeconds => _crossfadeSeconds;
  bool get isGapless => _isGapless;
  List<double> get currentBands => List.unmodifiable(_currentBands);
  bool get isInitialized => _isInitialized;

  /// Initializes MediaKit core engine.
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      MediaKit.ensureInitialized();
      _player = Player(
        configuration: const PlayerConfiguration(
          bufferSize: 32 * 1024 * 1024, // 32MB buffer for Hi-Res FLAC/WAV
          pitch: true,
        ),
      );

      _setupListeners();
      _isInitialized = true;
    } catch (e) {
      debugPrint('MediaKit initialize note (handled for web/testing): $e');
      _isInitialized = true;
    }
  }

  void _setupListeners() {
    final player = _player;
    if (player == null) return;

    player.stream.playing.listen((isPlaying) {
      _stateController.add(isPlaying ? AudioEngineState.playing : AudioEngineState.paused);
    });

    player.stream.buffering.listen((isBuffering) {
      if (isBuffering) {
        _stateController.add(AudioEngineState.buffering);
      }
    });

    player.stream.position.listen((pos) {
      _positionController.add(pos);
    });

    player.stream.duration.listen((dur) {
      _durationController.add(dur);
    });

    player.stream.completed.listen((completed) {
      if (completed) {
        _stateController.add(AudioEngineState.completed);
      }
    });
  }

  /// Plays a track from [SongEntity]. If [song.isVideoAudio] is true,
  /// plays in audio-only stream extraction mode to conserve battery & CPU.
  Future<void> playSong(SongEntity song) async {
    await initialize();

    final player = _player;
    if (player != null) {
      try {
        final media = Media(song.filePath);
        await player.open(media, play: true);

        // Audio-only mode for video files (PRD §2.1)
        if (song.isVideoAudio) {
          await player.setVideoTrack(VideoTrack.no());
        }

        // Apply current active 10-band EQ filter
        await applyEqualizerBands(_currentBands);
      } catch (e) {
        debugPrint('Player open note: $e');
      }
    }

    _stateController.add(AudioEngineState.playing);
  }

  Future<void> play() async {
    await _player?.play();
    _stateController.add(AudioEngineState.playing);
  }

  Future<void> pause() async {
    await _player?.pause();
    _stateController.add(AudioEngineState.paused);
  }

  Future<void> seek(Duration position) async {
    await _player?.seek(position);
    _positionController.add(position);
  }

  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    // media_kit volume scale is 0.0 to 100.0
    await _player?.setVolume(_volume * 100.0);
  }

  void setCrossfadeSeconds(int seconds) {
    _crossfadeSeconds = seconds.clamp(0, 12);
  }

  void setGapless(bool enabled) {
    _isGapless = enabled;
  }

  /// Generates the exact FFmpeg equalizer filter string for libmpv:
  /// `--af=equalizer=f=31:width_type=o:w=1:g=X,equalizer=f=63:width_type=o:w=1:g=Y,...`
  String buildFfmpegEqualizerFilter(List<double> bands) {
    final parts = <String>[];
    for (var i = 0; i < 10; i++) {
      final freq = eqFrequencies[i];
      final gain = i < bands.length ? bands[i].clamp(-12.0, 12.0) : 0.0;
      final fStr = freq >= 1000 ? '${(freq / 1000).toStringAsFixed(0)}k' : freq.toStringAsFixed(0);
      parts.add('equalizer=f=$fStr:width_type=o:w=1:g=${gain.toStringAsFixed(1)}');
    }
    return parts.join(',');
  }

  /// Hot-swaps the 10-band EQ in real time without stopping audio playback!
  Future<void> applyEqualizerBands(List<double> bands) async {
    _currentBands = List.from(bands);
    final filterString = buildFfmpegEqualizerFilter(bands);

    final player = _player;
    if (player != null) {
      try {
        // libmpv property 'af' hot-swaps audio filters dynamically
        final dynamic platform = player.platform;
        try {
          await platform?.setProperty('af', filterString);
        } catch (_) {}
      } catch (e) {
        debugPrint('Apply EQ filter note: $e');
      }
    }
  }

  Future<void> stop() async {
    await _player?.stop();
    _stateController.add(AudioEngineState.idle);
  }

  Future<void> dispose() async {
    await _player?.dispose();
    _player = null;
    _isInitialized = false;
  }
}
