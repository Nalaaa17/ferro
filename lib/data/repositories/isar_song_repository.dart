import 'package:isar/isar.dart';
import 'package:ferro/data/entities/entities.dart';
import 'package:ferro/domain/repositories/song_repository.dart';

class IsarSongRepository implements SongRepository {
  IsarSongRepository(this._isar);

  final Isar _isar;

  @override
  Future<List<SongEntity>> getAllSongs() {
    return _isar.songEntitys.where().sortByTitle().findAll();
  }

  @override
  Future<SongEntity?> getSongById(int id) {
    return _isar.songEntitys.get(id);
  }

  @override
  Future<SongEntity?> getSongByPath(String filePath) {
    return _isar.songEntitys.where().filePathEqualTo(filePath).findFirst();
  }

  @override
  Future<List<SongEntity>> getSongsByArtist(String artist) {
    return _isar.songEntitys.where().artistEqualTo(artist).sortByAlbum().findAll();
  }

  @override
  Future<List<SongEntity>> getSongsByAlbum(String album) {
    return _isar.songEntitys.where().albumEqualTo(album).sortByTrackNumber().findAll();
  }

  @override
  Future<List<SongEntity>> getSongsByGenre(String genre) {
    return _isar.songEntitys.where().genreEqualTo(genre).sortByTitle().findAll();
  }

  @override
  Future<List<SongEntity>> searchSongs(String query) {
    final clean = query.trim().toLowerCase();
    if (clean.isEmpty) {
      return getAllSongs();
    }
    return _isar.songEntitys
        .filter()
        .titleContains(clean, caseSensitive: false)
        .or()
        .artistContains(clean, caseSensitive: false)
        .or()
        .albumContains(clean, caseSensitive: false)
        .sortByTitle()
        .findAll();
  }

  @override
  Future<List<SongEntity>> getFavorites() {
    return _isar.songEntitys.filter().isFavoriteEqualTo(true).sortByTitle().findAll();
  }

  @override
  Future<List<SongEntity>> getRecentlyAdded({int limit = 20}) {
    return _isar.songEntitys.where().sortByDateAddedDesc().limit(limit).findAll();
  }

  @override
  Future<List<SongEntity>> getMostPlayed({int limit = 20}) {
    return _isar.songEntitys.where().sortByPlayCountDesc().limit(limit).findAll();
  }

  @override
  Future<int> insertOrUpdateSong(SongEntity song) async {
    return _isar.writeTxn(() => _isar.songEntitys.put(song));
  }

  @override
  Future<void> insertOrUpdateAll(List<SongEntity> songs) async {
    await _isar.writeTxn(() => _isar.songEntitys.putAll(songs));
  }

  @override
  Future<bool> deleteSong(int id) async {
    return _isar.writeTxn(() => _isar.songEntitys.delete(id));
  }

  @override
  Future<void> toggleFavorite(int id) async {
    await _isar.writeTxn(() async {
      final song = await _isar.songEntitys.get(id);
      if (song != null) {
        song.isFavorite = !song.isFavorite;
        await _isar.songEntitys.put(song);
      }
    });
  }

  @override
  Future<void> incrementPlayCount(int id) async {
    await _isar.writeTxn(() async {
      final song = await _isar.songEntitys.get(id);
      if (song != null) {
        song.playCount += 1;
        song.lastPlayed = DateTime.now();
        await _isar.songEntitys.put(song);
      }
    });
  }

  @override
  Stream<List<SongEntity>> watchAllSongs() {
    return _isar.songEntitys.where().sortByTitle().watch(fireImmediately: true);
  }
}
