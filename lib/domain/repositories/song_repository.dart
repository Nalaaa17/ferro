import 'package:ferro/data/entities/song_entity.dart';

abstract class SongRepository {
  Future<List<SongEntity>> getAllSongs();
  Future<SongEntity?> getSongById(int id);
  Future<SongEntity?> getSongByPath(String filePath);
  Future<List<SongEntity>> getSongsByArtist(String artist);
  Future<List<SongEntity>> getSongsByAlbum(String album);
  Future<List<SongEntity>> getSongsByGenre(String genre);
  Future<List<SongEntity>> searchSongs(String query);
  Future<List<SongEntity>> getFavorites();
  Future<List<SongEntity>> getRecentlyAdded({int limit = 20});
  Future<List<SongEntity>> getMostPlayed({int limit = 20});
  Future<int> insertOrUpdateSong(SongEntity song);
  Future<void> insertOrUpdateAll(List<SongEntity> songs);
  Future<bool> deleteSong(int id);
  Future<void> toggleFavorite(int id);
  Future<void> incrementPlayCount(int id);
  Stream<List<SongEntity>> watchAllSongs();
}
