import 'package:flutter/material.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/widgets.dart';
import 'package:ferro/data/sources/mock_catalog.dart';

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
  }

  @override
  void dispose() {
    _tabController.dispose();
    _songScrollController.dispose();
    super.dispose();
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
    setState(() {
      if (_selectedSongIds.length == MockCatalog.songs.length) {
        _selectedSongIds.clear();
        _isSelectMode = false;
      } else {
        _selectedSongIds.addAll(MockCatalog.songs.map((s) => s.id));
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
            _selectedSongIds.length == MockCatalog.songs.length
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
    const songs = MockCatalog.songs;

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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Memutar: ${song.title}')),
                  );
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
    return GridView.builder(
      padding: const EdgeInsets.all(FerroDimensions.space16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: FerroDimensions.space16,
        crossAxisSpacing: FerroDimensions.space16,
        childAspectRatio: 0.75,
      ),
      itemCount: MockCatalog.albums.length,
      itemBuilder: (context, index) {
        final album = MockCatalog.albums[index];
        return AlbumCard(
          title: album.title,
          subtitle: '${album.artist} • ${album.trackCount} Lagu',
          width: double.infinity,
          onTap: () {},
        );
      },
    );
  }

  Widget _buildArtistsTab() {
    final artists = [
      {'name': 'Daft Punk', 'count': '5 Lagu'},
      {'name': 'The Beatles', 'count': '2 Lagu'},
      {'name': 'Pink Floyd', 'count': '1 Lagu'},
      {'name': 'The Weeknd', 'count': '1 Lagu'},
      {'name': 'Eagles', 'count': '1 Lagu'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(FerroDimensions.space16),
      itemCount: artists.length,
      itemBuilder: (context, index) {
        final artist = artists[index];
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
          title: Text(artist['name']!, style: FerroTypography.title),
          subtitle: Text(artist['count']!, style: FerroTypography.caption),
          trailing: const Icon(Icons.chevron_right_rounded, color: FerroColors.onSurfaceMuted),
          onTap: () {},
        );
      },
    );
  }

  Widget _buildGenresTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(FerroDimensions.space16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: FerroDimensions.space12,
        crossAxisSpacing: FerroDimensions.space12,
        childAspectRatio: 1.8,
      ),
      itemCount: MockCatalog.genres.length,
      itemBuilder: (context, index) {
        final genre = MockCatalog.genres[index];
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
              Text(genre, style: FerroTypography.headline.copyWith(fontSize: 16.0)),
              Text('Koleksi Offline', style: FerroTypography.caption),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFoldersTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(FerroDimensions.space16),
      itemCount: MockCatalog.folders.length,
      itemBuilder: (context, index) {
        final folder = MockCatalog.folders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: FerroDimensions.space8),
          child: ListTile(
            leading: const Icon(Icons.folder_rounded, color: FerroColors.primaryLight, size: 32.0),
            title: Text(folder.split('/').last, style: FerroTypography.title),
            subtitle: Text(folder, style: FerroTypography.caption),
            trailing: const Icon(Icons.chevron_right_rounded, color: FerroColors.onSurfaceMuted),
            onTap: () {},
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
        Container(
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
        const SizedBox(height: FerroDimensions.space16),

        // Existing playlists
        Card(
          child: ListTile(
            leading: const ArtworkPlaceholder(size: 48.0, icon: Icons.favorite_rounded),
            title: Text('Lagu Favorit', style: FerroTypography.title),
            subtitle: Text('2 Lagu • Lossless', style: FerroTypography.caption),
            trailing: const Icon(Icons.chevron_right_rounded, color: FerroColors.onSurfaceMuted),
            onTap: () {},
          ),
        ),
        const SizedBox(height: FerroDimensions.space8),
        Card(
          child: ListTile(
            leading: const ArtworkPlaceholder(size: 48.0, icon: Icons.queue_music_rounded),
            title: Text('Audiophile Mix (FLAC)', style: FerroTypography.title),
            subtitle: Text('8 Lagu • Hi-Res 96kHz', style: FerroTypography.caption),
            trailing: const Icon(Icons.chevron_right_rounded, color: FerroColors.onSurfaceMuted),
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
