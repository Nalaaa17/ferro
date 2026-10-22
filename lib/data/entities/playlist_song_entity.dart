import 'package:isar/isar.dart';

part 'playlist_song_entity.g.dart';

@collection
class PlaylistSongEntity {
  Id id = Isar.autoIncrement;

  @Index()
  late int playlistId;

  @Index()
  late int songId;

  late int orderIndex;
}
