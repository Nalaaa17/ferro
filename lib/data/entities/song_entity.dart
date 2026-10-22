import 'package:isar/isar.dart';

part 'song_entity.g.dart';

@collection
class SongEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String filePath;

  @Index()
  late String title;

  @Index()
  late String artist;

  @Index()
  late String album;

  late int durationMs;

  late String format; // FLAC, WAV, MP3, OPUS, MP4, AAC, M4A

  late int sampleRate; // e.g. 192000, 96000, 48000, 44100

  late int bitDepth; // e.g. 24, 16, 32

  late int bitRate; // in bps, e.g. 320000

  late int fileSize; // in bytes

  String? artworkPath; // Local cached thumbnail path

  String? lrcPath; // Auto-paired .lrc file path

  @Index()
  late String genre;

  int? year;

  int? trackNumber;

  int? discNumber;

  bool isFavorite = false;

  int playCount = 0;

  DateTime? lastPlayed;

  DateTime dateAdded = DateTime.now();

  bool isVideoAudio = false; // Video-Audio extraction mode per PRD §2.1

  String get durationString {
    final dur = Duration(milliseconds: durationMs);
    final m = dur.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = dur.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
