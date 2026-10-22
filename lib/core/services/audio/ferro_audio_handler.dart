import 'dart:async';
import 'dart:ui';
import 'package:audio_service/audio_service.dart';
import 'package:ferro/data/entities/entities.dart';
import 'package:ferro/core/services/audio/ferro_audio_engine.dart';

/// Background AudioHandler powering Android MediaStyle notification,
/// Lockscreen controls, and Bluetooth headset button clicks per PRD §4.6.
class FerroAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  FerroAudioHandler({FerroAudioEngine? engine})
      : _engine = engine ?? FerroAudioEngine.instance {
    _initEngineListeners();
  }

  final FerroAudioEngine _engine;
  SongEntity? _currentSong;

  static Future<FerroAudioHandler> init() async {
    return AudioService.init(
      builder: () => FerroAudioHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'id.ferro.player.channel.audio',
        androidNotificationChannelName: 'FERRO Audio Playback',
        androidNotificationChannelDescription: 'Universal Offline Audio & Video-Audio Player',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
        notificationColor: Color(0xFFFF7A1A), // Ferro Orange
        androidNotificationIcon: 'mipmap/ic_launcher',
      ),
    );
  }

  void _initEngineListeners() {
    _engine.stateStream.listen((state) {
      final isPlaying = state == AudioEngineState.playing;
      _updatePlaybackState(
        playing: isPlaying,
        processingState: state == AudioEngineState.buffering
            ? AudioProcessingState.buffering
            : AudioProcessingState.ready,
      );
    });

    _engine.positionStream.listen((pos) {
      playbackState.add(
        playbackState.value.copyWith(
          updatePosition: pos,
        ),
      );
    });
  }

  void updateCurrentSong(SongEntity song) {
    _currentSong = song;

    mediaItem.add(
      MediaItem(
        id: song.id.toString(),
        title: song.title,
        artist: song.artist,
        album: song.album,
        duration: Duration(milliseconds: song.durationMs),
        genre: song.genre,
        artUri: song.artworkPath != null ? Uri.file(song.artworkPath!) : null,
        extras: {
          'format': song.format,
          'sampleRate': song.sampleRate,
          'bitDepth': song.bitDepth,
          'isVideoAudio': song.isVideoAudio,
        },
      ),
    );

    _updatePlaybackState(playing: true);
  }

  void _updatePlaybackState({
    required bool playing,
    AudioProcessingState processingState = AudioProcessingState.ready,
  }) {
    playbackState.add(
      PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
          MediaControl.stop,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: processingState,
        playing: playing,
        updatePosition: Duration.zero,
        bufferedPosition: Duration.zero,
        speed: 1.0,
      ),
    );
  }

  @override
  Future<void> play() async {
    await _engine.play();
    _updatePlaybackState(playing: true);
  }

  @override
  Future<void> pause() async {
    await _engine.pause();
    _updatePlaybackState(playing: false);
  }

  @override
  Future<void> seek(Duration position) async {
    await _engine.seek(position);
  }

  @override
  Future<void> stop() async {
    await _engine.stop();
    _updatePlaybackState(playing: false, processingState: AudioProcessingState.idle);
    await super.stop();
  }

  @override
  Future<void> fastForward() async {
    final current = playbackState.value.position;
    await seek(current + const Duration(seconds: 15));
  }

  @override
  Future<void> rewind() async {
    final current = playbackState.value.position;
    final target = current - const Duration(seconds: 15);
    await seek(target < Duration.zero ? Duration.zero : target);
  }

  SongEntity? get currentSong => _currentSong;
}
