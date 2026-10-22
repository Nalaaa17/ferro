import 'package:isar/isar.dart';
import 'package:ferro/data/entities/entities.dart';
import 'package:ferro/domain/repositories/playlist_repository.dart';

class IsarPlaylistRepository implements PlaylistRepository {
  IsarPlaylistRepository(this._isar);

  final Isar _isar;

  @override
  Future<List<PlaylistEntity>> getAllPlaylists() {
    return _isar.playlistEntitys.where().sortByName().findAll();
  }

  @override
  Future<PlaylistEntity?> getPlaylistById(int id) {
    return _isar.playlistEntitys.get(id);
  }

  @override
  Future<int> createPlaylist(
    String name, {
    String? description,
    String? coverImagePath,
  }) async {
    final playlist = PlaylistEntity()
      ..name = name
      ..description = description
      ..coverImagePath = coverImagePath
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();

    return _isar.writeTxn(() => _isar.playlistEntitys.put(playlist));
  }

  @override
  Future<void> updatePlaylist(PlaylistEntity playlist) async {
    playlist.updatedAt = DateTime.now();
    await _isar.writeTxn(() => _isar.playlistEntitys.put(playlist));
  }

  @override
  Future<bool> deletePlaylist(int id) async {
    return _isar.writeTxn(() async {
      await _isar.playlistSongEntitys.filter().playlistIdEqualTo(id).deleteAll();
      return _isar.playlistEntitys.delete(id);
    });
  }

  @override
  Future<void> addSongToPlaylist(int playlistId, SongEntity song) async {
    await _isar.writeTxn(() async {
      final count = await _isar.playlistSongEntitys
          .filter()
          .playlistIdEqualTo(playlistId)
          .count();

      final link = PlaylistSongEntity()
        ..playlistId = playlistId
        ..songId = song.id
        ..orderIndex = count;

      await _isar.playlistSongEntitys.put(link);

      final playlist = await _isar.playlistEntitys.get(playlistId);
      if (playlist != null) {
        playlist.songs.add(song);
        await playlist.songs.save();
        playlist.updatedAt = DateTime.now();
        await _isar.playlistEntitys.put(playlist);
      }
    });
  }

  @override
  Future<void> removeSongFromPlaylist(int playlistId, int songId) async {
    await _isar.writeTxn(() async {
      await _isar.playlistSongEntitys
          .filter()
          .playlistIdEqualTo(playlistId)
          .and()
          .songIdEqualTo(songId)
          .deleteAll();

      final playlist = await _isar.playlistEntitys.get(playlistId);
      if (playlist != null) {
        final song = await _isar.songEntitys.get(songId);
        if (song != null) {
          playlist.songs.remove(song);
          await playlist.songs.save();
          playlist.updatedAt = DateTime.now();
          await _isar.playlistEntitys.put(playlist);
        }
      }
    });
  }

  @override
  Future<List<SongEntity>> getSongsInPlaylist(int playlistId) async {
    final playlist = await _isar.playlistEntitys.get(playlistId);
    if (playlist == null) return [];
    await playlist.songs.load();
    return playlist.songs.toList();
  }

  @override
  Stream<List<PlaylistEntity>> watchAllPlaylists() {
    return _isar.playlistEntitys.where().sortByName().watch(fireImmediately: true);
  }
}
