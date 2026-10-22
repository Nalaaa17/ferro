import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:ferro/data/entities/song_entity.dart';

/// Generates valid 16-bit 44.1kHz stereo PCM WAV audio files on local disk
/// for genuine native playback verification.
class SampleAudioGenerator {
  SampleAudioGenerator._();

  static Uint8List createStereoWavBytes({
    int sampleRate = 44100,
    int durationSeconds = 12,
    double frequencyA = 440.0, // A4
    double frequencyB = 554.37, // C#5
    double frequencyC = 659.25, // E5 (Major chord)
  }) {
    final numSamples = sampleRate * durationSeconds;
    const numChannels = 2;
    const bitsPerSample = 16;
    final byteRate = sampleRate * numChannels * (bitsPerSample ~/ 8);
    const blockAlign = numChannels * (bitsPerSample ~/ 8);
    final subChunk2Size = numSamples * numChannels * (bitsPerSample ~/ 8);
    final chunkSize = 36 + subChunk2Size;

    final data = ByteData(44 + subChunk2Size);

    // RIFF header
    data.setUint8(0, 0x52); // 'R'
    data.setUint8(1, 0x49); // 'I'
    data.setUint8(2, 0x46); // 'F'
    data.setUint8(3, 0x46); // 'F'
    data.setUint32(4, chunkSize, Endian.little);
    data.setUint8(8, 0x57); // 'W'
    data.setUint8(9, 0x41); // 'A'
    data.setUint8(10, 0x56); // 'V'
    data.setUint8(11, 0x45); // 'E'

    // 'fmt ' chunk
    data.setUint8(12, 0x66); // 'f'
    data.setUint8(13, 0x6D); // 'm'
    data.setUint8(14, 0x74); // 't'
    data.setUint8(15, 0x20); // ' '
    data.setUint32(16, 16, Endian.little); // PCM subchunk size
    data.setUint16(20, 1, Endian.little); // Audio format 1 = PCM
    data.setUint16(22, numChannels, Endian.little);
    data.setUint32(24, sampleRate, Endian.little);
    data.setUint32(28, byteRate, Endian.little);
    data.setUint16(32, blockAlign, Endian.little);
    data.setUint16(34, bitsPerSample, Endian.little);

    // 'data' chunk
    data.setUint8(36, 0x64); // 'd'
    data.setUint8(37, 0x61); // 'a'
    data.setUint8(38, 0x74); // 't'
    data.setUint8(39, 0x61); // 'a'
    data.setUint32(40, subChunk2Size, Endian.little);

    // Generate stereo sine waves with smooth ADSR envelope
    var byteOffset = 44;
    for (var i = 0; i < numSamples; i++) {
      final t = i / sampleRate;

      // Soft envelope to prevent clicks
      double env = 1.0;
      if (t < 0.2) {
        env = t / 0.2;
      } else if (t > durationSeconds - 0.5) {
        env = (durationSeconds - t) / 0.5;
      }

      // Left Channel: A4 (440Hz) + harmonics
      final leftAmp = (math.sin(2 * math.pi * frequencyA * t) * 0.4 +
              math.sin(2 * math.pi * frequencyB * t) * 0.3) *
          env *
          24000;

      // Right Channel: E5 (659Hz) + harmonics
      final rightAmp = (math.sin(2 * math.pi * frequencyB * t) * 0.35 +
              math.sin(2 * math.pi * frequencyC * t) * 0.35) *
          env *
          24000;

      data.setInt16(byteOffset, leftAmp.clamp(-32768, 32767).toInt(), Endian.little);
      data.setInt16(byteOffset + 2, rightAmp.clamp(-32768, 32767).toInt(), Endian.little);
      byteOffset += 4;
    }

    return data.buffer.asUint8List();
  }

  /// Writes two genuine sample WAV tracks to the application documents or temp directory
  /// and returns their [SongEntity] representation.
  static Future<List<SongEntity>> generateLocalSampleTracks() async {
    if (kIsWeb) return [];

    try {
      Directory dir;
      try {
        dir = await getApplicationDocumentsDirectory();
      } catch (_) {
        dir = Directory.systemTemp;
      }

      final musicDir = Directory(p.join(dir.path, 'FerroMusic'));
      if (!musicDir.existsSync()) {
        await musicDir.create(recursive: true);
      }

      final track1Path = p.join(musicDir.path, 'Ferro_Acoustic_Master_44k.wav');
      final track2Path = p.join(musicDir.path, 'Ferro_HiRes_Studio_Tone_44k.wav');

      final track1File = File(track1Path);
      if (!await track1File.exists()) {
        final bytes = createStereoWavBytes(
          sampleRate: 44100,
          durationSeconds: 15,
          frequencyA: 440.0, // A Major Chord
          frequencyB: 554.37,
          frequencyC: 659.25,
        );
        await track1File.writeAsBytes(bytes, flush: true);
      }

      final track2File = File(track2Path);
      if (!await track2File.exists()) {
        final bytes = createStereoWavBytes(
          sampleRate: 44100,
          durationSeconds: 20,
          frequencyA: 523.25, // C Major Chord (C5, E5, G5)
          frequencyB: 659.25,
          frequencyC: 783.99,
        );
        await track2File.writeAsBytes(bytes, flush: true);
      }

      final song1 = SongEntity()
        ..id = 1001
        ..filePath = track1Path
        ..title = 'Ferro Acoustic Master'
        ..artist = 'Ferro Studio'
        ..album = 'Lossless Reference Audio'
        ..genre = 'Audiophile Reference'
        ..format = 'WAV'
        ..durationMs = 15000
        ..sampleRate = 44100
        ..bitDepth = 16
        ..bitRate = 1411200
        ..fileSize = await track1File.length()
        ..playCount = 1
        ..isFavorite = true;

      final song2 = SongEntity()
        ..id = 1002
        ..filePath = track2Path
        ..title = 'Hi-Res Studio Harmonic Tone'
        ..artist = 'Ferro Acoustic Labs'
        ..album = 'Lossless Reference Audio'
        ..genre = 'Audiophile Reference'
        ..format = 'WAV'
        ..durationMs = 20000
        ..sampleRate = 44100
        ..bitDepth = 16
        ..bitRate = 1411200
        ..fileSize = await track2File.length()
        ..playCount = 0
        ..isFavorite = false;

      return [song1, song2];
    } catch (e) {
      debugPrint('Failed to generate local sample audio: $e');
      return [];
    }
  }
}
