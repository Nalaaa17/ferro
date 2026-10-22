import 'package:isar/isar.dart';
import 'package:ferro/data/entities/song_entity.dart';

part 'playlist_entity.g.dart';

@collection
class PlaylistEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String name;

  String? description;

  String? coverImagePath;

  DateTime createdAt = DateTime.now();

  DateTime updatedAt = DateTime.now();

  final songs = IsarLinks<SongEntity>();
}
