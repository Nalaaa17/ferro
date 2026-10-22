import 'package:flutter_test/flutter_test.dart';
import 'package:ferro/data/entities/entities.dart';
import 'package:ferro/core/services/audio/audio_services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Fase 8: Core Audio Engine & Background Playback Tests', () {
    test('FerroAudioEngine builds correct 10-band FFmpeg equalizer filter string', () {
      final engine = FerroAudioEngine.instance;

      final flatBands = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
      final flatFilter = engine.buildFfmpegEqualizerFilter(flatBands);

      expect(flatFilter, contains('equalizer=f=31:width_type=o:w=1:g=0.0'));
      expect(flatFilter, contains('equalizer=f=1k:width_type=o:w=1:g=0.0'));
      expect(flatFilter, contains('equalizer=f=16k:width_type=o:w=1:g=0.0'));

      // Test Rock preset bands
      final rockBands = [4.5, 3.0, 1.5, 0.0, -1.0, 0.0, 2.0, 3.5, 4.0, 4.5];
      final rockFilter = engine.buildFfmpegEqualizerFilter(rockBands);
      expect(rockFilter, contains('equalizer=f=31:width_type=o:w=1:g=4.5'));
      expect(rockFilter, contains('equalizer=f=500:width_type=o:w=1:g=-1.0'));
      expect(rockFilter, contains('equalizer=f=16k:width_type=o:w=1:g=4.5'));

      // Test gain clamping to [-12, +12]
      final extremeBands = [20.0, -25.0, 0.0];
      final clampedFilter = engine.buildFfmpegEqualizerFilter(extremeBands);
      expect(clampedFilter, contains('equalizer=f=31:width_type=o:w=1:g=12.0'));
      expect(clampedFilter, contains('equalizer=f=63:width_type=o:w=1:g=-12.0'));
    });

    test('FerroAudioEngine clamps crossfade duration and toggles gapless', () {
      final engine = FerroAudioEngine.instance;

      engine.setCrossfadeSeconds(5);
      expect(engine.crossfadeSeconds, 5);

      engine.setCrossfadeSeconds(20);
      expect(engine.crossfadeSeconds, 12); // Clamped to 12s max per PRD §4.6

      engine.setCrossfadeSeconds(-3);
      expect(engine.crossfadeSeconds, 0); // Clamped to 0s min

      engine.setGapless(true);
      expect(engine.isGapless, isTrue);
      engine.setGapless(false);
      expect(engine.isGapless, isFalse);
    });

    test('FerroAudioHandler updates MediaItem and PlaybackState', () async {
      final handler = FerroAudioHandler();

      final song = SongEntity()
        ..id = 42
        ..filePath = '/sdcard/Music/Daft Punk - Instant Crush.flac'
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

      handler.updateCurrentSong(song);

      expect(handler.currentSong?.title, 'Instant Crush');
      final media = await handler.mediaItem.first;
      expect(media?.title, 'Instant Crush');
      expect(media?.artist, 'Daft Punk');
      expect(media?.duration, const Duration(milliseconds: 337000));
      expect(media?.extras?['format'], 'FLAC');
      expect(media?.extras?['sampleRate'], 96000);

      // Playback controls
      await handler.play();
      var state = await handler.playbackState.first;
      expect(state.playing, isTrue);

      await handler.pause();
      state = await handler.playbackState.first;
      expect(state.playing, isFalse);
    });
  });

  group('Fase 9: Native Hardware Detection & Real EQ Filters Tests', () {
    test('AudioDeviceManager simulates device connection and volume adjustments', () async {
      final manager = AudioDeviceManager();

      // Initial state is internal speaker
      expect(manager.currentDevice.type, 'speaker');

      // Simulate plugging in USB DAC
      await manager.simulateDeviceConnection(
        type: 'usb_dac',
        name: 'Apple USB-C DAC',
        deviceIdentifier: 'apple_usb_dac_001',
        customEqBands: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        volume: 0.9,
      );

      expect(manager.currentDevice.type, 'usb_dac');
      expect(manager.currentDevice.name, 'Apple USB-C DAC');
      expect(manager.currentDevice.appliedVolume, 0.9);

      // Simulate connecting Soundcore R50i TWS
      await manager.simulateDeviceConnection(
        type: 'bluetooth',
        name: 'Soundcore R50i',
        deviceIdentifier: 'bt_soundcore_r50i',
        customEqBands: [4.5, 3.0, 1.5, 0, -1.0, 0, 2.0, 3.5, 4.0, 4.5],
        volume: 0.8,
      );

      expect(manager.currentDevice.type, 'bluetooth');
      expect(manager.currentDevice.name, 'Soundcore R50i');
      expect(manager.currentDevice.appliedVolume, 0.8);

      // Verify EQ bands applied to engine
      final currentBands = FerroAudioEngine.instance.currentBands;
      expect(currentBands.length, 10);
      expect(currentBands[0], 4.5);
      expect(currentBands[4], -1.0);
    });
  });
}
