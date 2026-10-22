import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/widgets.dart';
import 'package:ferro/data/sources/mock_catalog.dart';
import 'package:ferro/data/repositories/mock_repositories.dart';
import 'package:ferro/features/library/presentation/screens/album_detail_screen.dart';
import 'package:ferro/features/library/presentation/screens/artist_detail_screen.dart';
import 'package:ferro/features/library/presentation/screens/folder_browser_screen.dart';
import 'package:ferro/features/library/presentation/screens/playlist_detail_screen.dart';
import 'package:ferro/features/player/presentation/providers/player_controller.dart';

enum SortOption {
  titleAZ('Judul (A-Z)'),
  titleZA('Judul (Z-A)'),
  artist('Artis'),
  duration('Durasi'),
  dateAdded('Terakhir Ditambahkan');

  const SortOption(this.label);
  final String label;
}

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final List<String> _tabs = ['Lagu', 'Album', 'Artis', 'Genre', 'Folder', 'Playlist'];

  bool _isGridView = false;
  SortOption _selectedSort = SortOption.titleAZ;

  // Multi-select State
  bool _isSelectMode = false;
  final Set<String> _selectedSongIds = {};

  final ScrollController _songScrollController = ScrollController();
  final List<String> _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ#'.split('');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    PlayerController.instance.addListener(_onPlayerUpdate);
  }

  @override
  void dispose() {
    PlayerController.instance.removeListener(_onPlayerUpdate);
    _tabController.dispose();
    _songScrollController.dispose();
    super.dispose();
  }

  void _onPlayerUpdate() {
    if (mounted) setState(() {});
  }

  void _enterSelectMode(String initialId) {
    setState(() {
      _isSelectMode = true;
      _selectedSongIds.add(initialId);
    });
  }

  void _exitSelectMode() {
    setState(() {
      _isSelectMode = false;
      _selectedSongIds.clear();
    });
  }

  void _toggleSongSelection(String songId) {
    setState(() {
      if (_selectedSongIds.contains(songId)) {
        _selectedSongIds.remove(songId);
        if (_selectedSongIds.isEmpty) {
          _isSelectMode = false;
        }
      } else {
        _selectedSongIds.add(songId);
      }
    });
  }

  void _selectAll() {
    final allSongs = PlayerController.instance.allSongs;
    setState(() {
      if (_selectedSongIds.length == allSongs.length) {
        _selectedSongIds.clear();
        _isSelectMode = false;
      } else {
        _selectedSongIds.addAll(allSongs.map((s) => s.id));
      }
    });
  }

  void _showSortDialog() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: FerroColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: FerroDimensions.radiusSheetTop,
        side: BorderSide(color: FerroColors.divider, width: 1.0),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: FerroDimensions.space16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: FerroDimensions.space20),
                  child: Text('Urutkan Menurut', style: FerroTypography.headline),
                ),
                const SizedBox(height: FerroDimensions.space12),
                ...SortOption.values.map((option) {
                  final isSelected = _selectedSort == option;
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: FerroDimensions.space20),
                    title: Text(
                      option.label,
                      style: FerroTypography.title.copyWith(
                        color: isSelected ? FerroColors.primary : FerroColors.onSurface,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_rounded, color: FerroColors.primary)
                        : null,
                    onTap: () {
                      setState(() => _selectedSort = option);
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FerroColors.background,
      appBar: _isSelectMode ? _buildMultiSelectAppBar() : _buildStandardAppBar(),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. Tab Lagu (List / Grid + Alphabet Fast-Scroller)
          _buildSongsTab(),

          // 2. Tab Album (2-Column Grid)
          _buildAlbumsTab(),

          // 3. Tab Artis (Circle Avatars Grid)
          _buildArtistsTab(),

          // 4. Tab Genre (Vibrant Cards)
          _buildGenresTab(),

          // 5. Tab Folder (Directory Tree)
          _buildFoldersTab(),

          // 6. Tab Playlist
          _buildPlaylistsTab(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildStandardAppBar() {
    return AppBar(
      title: Text('Pustaka', style: FerroTypography.display.copyWith(fontSize: 22.0)),
      actions: [
        IconButton(
          icon: Icon(_isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
          tooltip: _isGridView ? 'Tampilan List' : 'Tampilan Grid',
          onPressed: () => setState(() => _isGridView = !_isGridView),
        ),
        IconButton(
          icon: const Icon(Icons.sort_rounded),
          tooltip: 'Urutkan',
          onPressed: _showSortDialog,
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicatorColor: FerroColors.primary,
        indicatorWeight: 2.5,
        labelColor: FerroColors.primary,
        unselectedLabelColor: FerroColors.onSurfaceMuted,
        labelStyle: FerroTypography.title.copyWith(fontSize: 14.0),
        padding: const EdgeInsets.symmetric(horizontal: FerroDimensions.space12),
        tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }

  PreferredSizeWidget _buildMultiSelectAppBar() {
    return AppBar(
      backgroundColor: FerroColors.surfaceHigh,
      leading: IconButton(
        icon: const Icon(Icons.close_rounded),
        onPressed: _exitSelectMode,
      ),
      title: Text(
        '${_selectedSongIds.length} Dipilih',
        style: FerroTypography.headline.copyWith(fontSize: 18.0),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _selectedSongIds.length == PlayerController.instance.allSongs.length
                ? Icons.deselect_rounded
                : Icons.select_all_rounded,
          ),
          tooltip: 'Pilih Semua',
          onPressed: _selectAll,
        ),
        IconButton(
          icon: const Icon(Icons.playlist_add_rounded),
          tooltip: 'Tambah ke Playlist',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${_selectedSongIds.length} lagu ditambahkan ke playlist')),
            );
            _exitSelectMode();
          },
        ),
        IconButton(
          icon: const Icon(Icons.favorite_border_rounded),
          tooltip: 'Favoritkan',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${_selectedSongIds.length} lagu ditambahkan ke favorit')),
            );
            _exitSelectMode();
          },
        ),
      ],
    );
  }

  Widget _buildSongsTab() {
    final allSongs = PlayerController.instance.allSongs;

    if (allSongs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(FerroDimensions.space24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.library_music_rounded, size: 56.0, color: FerroColors.primaryLight),
              const SizedBox(height: FerroDimensions.space16),
              Text('Pustaka Belum Ada Lagu', style: FerroTypography.headline.copyWith(fontSize: 18.0)),
              const SizedBox(height: FerroDimensions.space8),
              Text(
                'Pindai perangkat Anda untuk menambahkan file musik FLAC, WAV, MP3 secara otomatis.',
                textAlign: TextAlign.center,
                style: FerroTypography.caption,
              ),
              const SizedBox(height: FerroDimensions.space20),
              FerroButton(
                label: 'Pindai Penyimpanan',
                icon: Icons.sync_rounded,
                onPressed: () => PlayerController.instance.scanDeviceMusic(MockSongRepository()),
              ),
            ],
          ),
        ),
      );
    }

    final songs = List<MockSong>.from(allSongs);
    switch (_selectedSort) {
      case SortOption.titleAZ:
        songs.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case SortOption.titleZA:
        songs.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        break;
      case SortOption.artist:
        songs.sort((a, b) => a.artist.toLowerCase().compareTo(b.artist.toLowerCase()));
        break;
      case SortOption.duration:
        songs.sort((a, b) => b.duration.compareTo(a.duration));
        break;
      case SortOption.dateAdded:
        break;
    }

    if (_isGridView) {
      return GridView.builder(
        padding: const EdgeInsets.all(FerroDimensions.space16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: FerroDimensions.space16,
          crossAxisSpacing: FerroDimensions.space16,
          childAspectRatio: 0.75,
        ),
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return AlbumCard(
            title: song.title,
            subtitle: '${song.artist} • ${song.format}',
            width: double.infinity,
            onTap: () {
              if (_isSelectMode) {
                _toggleSongSelection(song.id);
              } else {
                PlayerController.instance.playSong(song);
              }
            },
          );
        },
      );
    }

    return Stack(
      children: [
        ListView.separated(
          controller: _songScrollController,
          padding: const EdgeInsets.only(
            left: FerroDimensions.space16,
            right: 40.0, // Space for alphabet fast scroller
            top: FerroDimensions.space8,
            bottom: FerroDimensions.space32,
          ),
          itemCount: songs.length,
          separatorBuilder: (_, _) => const Divider(height: 1, indent: 72),
          itemBuilder: (context, index) {
            final song = songs[index];
            final isSelected = _selectedSongIds.contains(song.id);

            return SongTile(
              title: song.title,
              artist: '${song.artist} • ${song.quality}',
              durationText: song.durationString,
              isSelectMode: _isSelectMode,
              isSelected: isSelected,
              onTap: () {
                if (_isSelectMode) {
                  _toggleSongSelection(song.id);
                } else {
                  PlayerController.instance.playSong(song);
                }
              },
              onLongPress: () {
                if (!_isSelectMode) {
                  _enterSelectMode(song.id);
                }
              },
              onMoreTap: () {},
            );
          },
        ),

        // Fast-scroller alfabetis sisi kanan
        if (!_isSelectMode)
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 32.0,
              padding: const EdgeInsets.symmetric(vertical: FerroDimensions.space8),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _alphabet.length,
                itemBuilder: (context, index) {
                  final letter = _alphabet[index];
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.5),
                      child: Text(
                        letter,
                        style: FerroTypography.captionBold.copyWith(
                          fontSize: 10.0,
                          color: FerroColors.primary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAlbumsTab() {
    final allSongs = PlayerController.instance.allSongs;
    final albumsMap = <String, List<MockSong>>{};
    for (final song in allSongs) {
      albumsMap.putIfAbsent(song.album, () => []).add(song);
    }
    final albums = albumsMap.entries.map((e) {
      return MockAlbum(
        id: e.key,
        title: e.key,
        artist: e.value.first.artist,
        year: 2024,
        trackCount: e.value.length,
        songs: e.value,
        artworkUrl: e.value.first.artworkUrl,
      );
    }).toList();

    if (albums.isEmpty) {
      return const Center(child: Text('Belum ada album ditemukan'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(FerroDimensions.space16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: FerroDimensions.space16,
        crossAxisSpacing: FerroDimensions.space16,
        childAspectRatio: 0.75,
      ),
      itemCount: albums.length,
      itemBuilder: (context, index) {
        final album = albums[index];
        return AlbumCard(
          title: album.title,
          subtitle: '${album.artist} • ${album.trackCount} Lagu',
          width: double.infinity,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => AlbumDetailScreen(album: album)),
            );
          },
        );
      },
    );
  }

  Widget _buildArtistsTab() {
    final allSongs = PlayerController.instance.allSongs;
    final artistsMap = <String, int>{};
    for (final song in allSongs) {
      artistsMap[song.artist] = (artistsMap[song.artist] ?? 0) + 1;
    }

    final artists = artistsMap.entries.toList();
    if (artists.isEmpty) {
      return const Center(child: Text('Belum ada artis ditemukan'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(FerroDimensions.space16),
      itemCount: artists.length,
      itemBuilder: (context, index) {
        final entry = artists[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: FerroDimensions.space4),
          leading: Container(
            width: 52.0,
            height: 52.0,
            decoration: const BoxDecoration(
              gradient: FerroColors.artworkPlaceholderGradient,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.person_rounded, color: FerroColors.primaryLight, size: 28.0),
            ),
          ),
          title: Text(entry.key, style: FerroTypography.title),
          subtitle: Text('${entry.value} Lagu', style: FerroTypography.caption),
          trailing: const Icon(Icons.chevron_right_rounded, color: FerroColors.onSurfaceMuted),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ArtistDetailScreen(artistName: entry.key),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGenresTab() {
    final allSongs = PlayerController.instance.allSongs;
    final genresMap = <String, int>{};
    for (final song in allSongs) {
      if (song.genre.isNotEmpty) {
        genresMap[song.genre] = (genresMap[song.genre] ?? 0) + 1;
      }
    }
    final genres = genresMap.entries.toList();
    if (genres.isEmpty) {
      return const Center(child: Text('Belum ada genre ditemukan'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(FerroDimensions.space16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: FerroDimensions.space12,
        crossAxisSpacing: FerroDimensions.space12,
        childAspectRatio: 1.8,
      ),
      itemCount: genres.length,
      itemBuilder: (context, index) {
        final entry = genres[index];
        return Container(
          padding: const EdgeInsets.all(FerroDimensions.space16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                FerroColors.surfaceHigh,
                FerroColors.surface,
              ],
            ),
            borderRadius: FerroDimensions.radiusCardAll,
            border: Border.all(color: FerroColors.divider, width: 1.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(entry.key, style: FerroTypography.headline.copyWith(fontSize: 16.0)),
              Text('${entry.value} Lagu', style: FerroTypography.caption),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFoldersTab() {
    final allSongs = PlayerController.instance.allSongs;
    final folders = allSongs
        .map((s) => s.filePath != null ? p.dirname(s.filePath!) : '')
        .where((f) => f.isNotEmpty)
        .toSet()
        .toList();

    if (folders.isEmpty) {
      return const Center(child: Text('Belum ada folder ditemukan'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(FerroDimensions.space16),
      itemCount: folders.length,
      itemBuilder: (context, index) {
        final folder = folders[index];
        final folderName = p.basename(folder);
        return Card(
          margin: const EdgeInsets.only(bottom: FerroDimensions.space8),
          child: ListTile(
            leading: const Icon(Icons.folder_rounded, color: FerroColors.primaryLight, size: 32.0),
            title: Text(folderName.isNotEmpty ? folderName : folder, style: FerroTypography.title),
            subtitle: Text(folder, style: FerroTypography.caption),
            trailing: const Icon(Icons.chevron_right_rounded, color: FerroColors.onSurfaceMuted),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => FolderBrowserScreen(initialPath: folder),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPlaylistsTab() {
    return ListView(
      padding: const EdgeInsets.all(FerroDimensions.space16),
      children: [
        // Buat Playlist Baru Card (Dashed Border style)
        InkWell(
          onTap: () => PlaylistDetailScreen.showCreatePlaylistSheet(context),
          borderRadius: FerroDimensions.radiusCardAll,
          child: Container(
            padding: const EdgeInsets.all(FerroDimensions.space16),
            decoration: BoxDecoration(
              color: FerroColors.surface,
              borderRadius: FerroDimensions.radiusCardAll,
              border: Border.all(
                color: FerroColors.primary.withValues(alpha: 0.6),
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: const BoxDecoration(
                    gradient: FerroColors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.add_rounded, color: Colors.white, size: 28.0),
                  ),
                ),
                const SizedBox(width: FerroDimensions.space16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Buat Playlist Baru', style: FerroTypography.title),
                    const SizedBox(height: FerroDimensions.space2),
                    Text('Kelompokkan musik favoritmu', style: FerroTypography.caption),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: FerroDimensions.space16),

        // Existing playlists
        Card(
          child: ListTile(
            leading: const ArtworkPlaceholder(size: 48.0, icon: Icons.favorite_rounded),
            title: Text('Lagu Favorit', style: FerroTypography.title),
            subtitle: Text('2 Lagu • Lossless', style: FerroTypography.caption),
            trailing: const Icon(Icons.chevron_right_rounded, color: FerroColors.onSurfaceMuted),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const PlaylistDetailScreen(
                    playlistTitle: 'Lagu Favorit',
                    description: 'Koleksi audio favorit offline',
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: FerroDimensions.space8),
        Card(
          child: ListTile(
            leading: const ArtworkPlaceholder(size: 48.0, icon: Icons.queue_music_rounded),
            title: Text('Audiophile Mix (FLAC)', style: FerroTypography.title),
            subtitle: Text('8 Lagu • Hi-Res 96kHz', style: FerroTypography.caption),
            trailing: const Icon(Icons.chevron_right_rounded, color: FerroColors.onSurfaceMuted),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const PlaylistDetailScreen(
                    playlistTitle: 'Audiophile Mix (FLAC)',
                    description: 'Mastering 24-bit Hi-Res 96kHz',
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
