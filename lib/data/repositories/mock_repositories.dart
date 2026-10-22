import 'dart:async';
import 'package:ferro/data/entities/entities.dart';
import 'package:ferro/domain/repositories/repositories.dart';
import 'package:ferro/data/sources/mock_catalog.dart';

class MockSongRepository implements SongRepository {
  MockSongRepository() {
    _initFromMockCatalog();
  }

  final Map<int, SongEntity> _storage = {};
  final _controller = StreamController<List<SongEntity>>.broadcast();
  int _nextId = 1;

  void _initFromMockCatalog() {
    for (final song in MockCatalog.songs) {
      final id = _nextId++;
      _storage[id] = SongEntity()
        ..id = id
        ..filePath = '/storage/emulated/0/Music/${song.artist} - ${song.title}.${song.format.toLowerCase()}'
        ..title = song.title
        ..artist = song.artist
        ..album = song.album
        ..genre = song.genre
        ..format = song.format
        ..durationMs = song.duration.inMilliseconds
        ..sampleRate = song.quality.contains('192') ? 192000 : (song.quality.contains('96') ? 96000 : 44100)
        ..bitDepth = song.quality.contains('24') ? 24 : 16
        ..bitRate = 320000
        ..fileSize = 35000000
        ..isFavorite = song.isFavorite
        ..playCount = song.playCount
        ..isVideoAudio = song.isVideoAudio
        ..dateAdded = DateTime.now();
    }
  }

  void _notify() {
    if (!_controller.isClosed) {
      _controller.add(_storage.values.toList()..sort((a, b) => a.title.compareTo(b.title)));
    }
  }

  @override
  Future<List<SongEntity>> getAllSongs() async {
    final list = _storage.values.toList();
    list.sort((a, b) => a.title.compareTo(b.title));
    return list;
  }

  @override
  Future<SongEntity?> getSongById(int id) async => _storage[id];

  @override
  Future<SongEntity?> getSongByPath(String filePath) async {
    for (final song in _storage.values) {
      if (song.filePath == filePath) return song;
    }
    return null;
  }

  @override
  Future<List<SongEntity>> getSongsByArtist(String artist) async {
    return _storage.values
        .where((s) => s.artist.toLowerCase() == artist.toLowerCase())
        .toList()
      ..sort((a, b) => a.album.compareTo(b.album));
  }

  @override
  Future<List<SongEntity>> getSongsByAlbum(String album) async {
    return _storage.values
        .where((s) => s.album.toLowerCase() == album.toLowerCase())
        .toList()
      ..sort((a, b) => (a.trackNumber ?? 0).compareTo(b.trackNumber ?? 0));
  }

  @override
  Future<List<SongEntity>> getSongsByGenre(String genre) async {
    return _storage.values
        .where((s) => s.genre.toLowerCase() == genre.toLowerCase())
        .toList()
      ..sort((a, b) => a.title.compareTo(b.title));
  }

  @override
  Future<List<SongEntity>> searchSongs(String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return getAllSongs();
    return _storage.values.where((s) {
      return s.title.toLowerCase().contains(q) ||
          s.artist.toLowerCase().contains(q) ||
          s.album.toLowerCase().contains(q);
    }).toList()
      ..sort((a, b) => a.title.compareTo(b.title));
  }

  @override
  Future<List<SongEntity>> getFavorites() async {
    return _storage.values.where((s) => s.isFavorite).toList()
      ..sort((a, b) => a.title.compareTo(b.title));
  }

  @override
  Future<List<SongEntity>> getRecentlyAdded({int limit = 20}) async {
    final list = _storage.values.toList()
      ..sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
    return list.take(limit).toList();
  }

  @override
  Future<List<SongEntity>> getMostPlayed({int limit = 20}) async {
    final list = _storage.values.toList()
      ..sort((a, b) => b.playCount.compareTo(a.playCount));
    return list.take(limit).toList();
  }

  @override
  Future<int> insertOrUpdateSong(SongEntity song) async {
    if (song.id == 0 || song.id == -9223372036854775808) {
      song.id = _nextId++;
    }
    _storage[song.id] = song;
    _notify();
    return song.id;
  }

  @override
  Future<void> insertOrUpdateAll(List<SongEntity> songs) async {
    for (final song in songs) {
      await insertOrUpdateSong(song);
    }
  }

  @override
  Future<bool> deleteSong(int id) async {
    final removed = _storage.remove(id) != null;
    if (removed) _notify();
    return removed;
  }

  @override
  Future<void> toggleFavorite(int id) async {
    final song = _storage[id];
    if (song != null) {
      song.isFavorite = !song.isFavorite;
      _notify();
    }
  }

  @override
  Future<void> incrementPlayCount(int id) async {
    final song = _storage[id];
    if (song != null) {
      song.playCount += 1;
      song.lastPlayed = DateTime.now();
      _notify();
    }
  }

  @override
  Stream<List<SongEntity>> watchAllSongs() {
    return _controller.stream;
  }

  void dispose() {
    _controller.close();
  }
}

class MockPlaylistRepository implements PlaylistRepository {
  final Map<int, PlaylistEntity> _playlists = {};
  final Map<int, List<SongEntity>> _playlistSongs = {};
  int _nextId = 1;

  @override
  Future<List<PlaylistEntity>> getAllPlaylists() async {
    return _playlists.values.toList()..sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Future<PlaylistEntity?> getPlaylistById(int id) async => _playlists[id];

  @override
  Future<int> createPlaylist(
    String name, {
    String? description,
    String? coverImagePath,
  }) async {
    final id = _nextId++;
    final p = PlaylistEntity()
      ..id = id
      ..name = name
      ..description = description
      ..coverImagePath = coverImagePath
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();
    _playlists[id] = p;
    _playlistSongs[id] = [];
    return id;
  }

  @override
  Future<void> updatePlaylist(PlaylistEntity playlist) async {
    _playlists[playlist.id] = playlist;
  }

  @override
  Future<bool> deletePlaylist(int id) async {
    _playlistSongs.remove(id);
    return _playlists.remove(id) != null;
  }

  @override
  Future<void> addSongToPlaylist(int playlistId, SongEntity song) async {
    _playlistSongs[playlistId] ??= [];
    _playlistSongs[playlistId]!.add(song);
  }

  @override
  Future<void> removeSongFromPlaylist(int playlistId, int songId) async {
    _playlistSongs[playlistId]?.removeWhere((s) => s.id == songId);
  }

  @override
  Future<List<SongEntity>> getSongsInPlaylist(int playlistId) async {
    return _playlistSongs[playlistId] ?? [];
  }

  @override
  Stream<List<PlaylistEntity>> watchAllPlaylists() {
    return Stream.value(_playlists.values.toList());
  }
}
