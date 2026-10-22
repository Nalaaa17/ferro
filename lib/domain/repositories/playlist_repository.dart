import 'package:ferro/data/entities/playlist_entity.dart';
import 'package:ferro/data/entities/song_entity.dart';

abstract class PlaylistRepository {
  Future<List<PlaylistEntity>> getAllPlaylists();
  Future<PlaylistEntity?> getPlaylistById(int id);
  Future<int> createPlaylist(String name, {String? description, String? coverImagePath});
  Future<void> updatePlaylist(PlaylistEntity playlist);
  Future<bool> deletePlaylist(int id);
  Future<void> addSongToPlaylist(int playlistId, SongEntity song);
  Future<void> removeSongFromPlaylist(int playlistId, int songId);
  Future<List<SongEntity>> getSongsInPlaylist(int playlistId);
  Stream<List<PlaylistEntity>> watchAllPlaylists();
}
