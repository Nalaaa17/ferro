import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/widgets.dart';
import 'package:ferro/data/sources/mock_catalog.dart';
import 'package:ferro/features/player/presentation/providers/player_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  String _searchQuery = '';
  bool _isSearching = false;

  final List<String> _recentSearches = [
    'Daft Punk',
    'Abbey Road',
    'FLAC 24-bit',
    'Pink Floyd',
  ];

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debounceTimer?.cancel();
    if (query.trim().isEmpty) {
      setState(() {
        _searchQuery = '';
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    // 200ms debounce per PRD §4.7
    _debounceTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _searchQuery = query.trim().toLowerCase();
          _isSearching = false;
        });
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasQuery = _searchQuery.isNotEmpty;

    return Scaffold(
      backgroundColor: FerroColors.background,
      appBar: AppBar(
        title: Text('Cari', style: FerroTypography.display.copyWith(fontSize: 22.0)),
      ),
      body: Column(
        children: [
          // Search Bar Pill
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: FerroDimensions.space16,
              vertical: FerroDimensions.space8,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onQueryChanged,
              decoration: InputDecoration(
                hintText: 'Cari lagu, artis, atau album...',
                prefixIcon: const Icon(Icons.search_rounded, color: FerroColors.onSurfaceMuted),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, color: FerroColors.onSurfaceMuted),
                        onPressed: _clearSearch,
                      )
                    : null,
              ),
            ),
          ),

          // Content Area (Active Search Results vs Inactive Browse)
          Expanded(
            child: _isSearching
                ? _buildSearchShimmer()
                : hasQuery
                    ? _buildSearchResults()
                    : _buildDefaultBrowse(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    final allSongs = PlayerController.instance.allSongs;
    final filteredSongs = allSongs.where((song) {
      return song.title.toLowerCase().contains(_searchQuery) ||
          song.artist.toLowerCase().contains(_searchQuery) ||
          song.album.toLowerCase().contains(_searchQuery) ||
          song.format.toLowerCase().contains(_searchQuery);
    }).toList();

    // Group matching albums from filtered songs
    final albumsMap = <String, List<MockSong>>{};
    for (final song in filteredSongs) {
      albumsMap.putIfAbsent(song.album, () => []).add(song);
    }
    final filteredAlbums = albumsMap.entries.map((e) {
      return MockAlbum(
        id: e.key,
        title: e.key,
        artist: e.value.first.artist,
        year: 2024,
        trackCount: e.value.length,
        songs: e.value,
      );
    }).toList();

    if (filteredSongs.isEmpty && filteredAlbums.isEmpty) {
      return EmptyState(
        title: 'Tidak Ada Hasil',
        description: 'Tidak menemukan hasil untuk "$_searchQuery". Coba periksa ejaan atau kata kunci lain.',
        icon: Icons.search_off_rounded,
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: FerroDimensions.space16,
        vertical: FerroDimensions.space12,
      ),
      children: [
        // Albums results
        if (filteredAlbums.isNotEmpty) ...[
          Text('Album', style: FerroTypography.headline),
          const SizedBox(height: FerroDimensions.space12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filteredAlbums.map((album) {
                return Padding(
                  padding: const EdgeInsets.only(right: FerroDimensions.space16),
                  child: AlbumCard(
                    title: album.title,
                    subtitle: album.artist,
                    onTap: () {},
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: FerroDimensions.space24),
        ],

        // Songs results
        if (filteredSongs.isNotEmpty) ...[
          Text('Lagu', style: FerroTypography.headline),
          const SizedBox(height: FerroDimensions.space12),
          Card(
            child: Column(
              children: List.generate(filteredSongs.length, (index) {
                final song = filteredSongs[index];
                return Column(
                  children: [
                    SongTile(
                      title: song.title,
                      artist: '${song.artist} • ${song.album}',
                      durationText: song.durationString,
                      onTap: () => PlayerController.instance.playSong(song),
                      onMoreTap: () {},
                    ),
                    if (index < filteredSongs.length - 1)
                      const Divider(height: 1, indent: 72),
                  ],
                );
              }),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDefaultBrowse() {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: FerroDimensions.space16,
        vertical: FerroDimensions.space12,
      ),
      children: [
        // Recent Searches
        if (_recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pencarian Terakhir', style: FerroTypography.title),
              TextButton(
                onPressed: () => setState(() => _recentSearches.clear()),
                child: Text(
                  'Hapus Riwayat',
                  style: FerroTypography.caption.copyWith(color: FerroColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: FerroDimensions.space8),
          Wrap(
            spacing: FerroDimensions.space8,
            runSpacing: FerroDimensions.space8,
            children: _recentSearches.map((term) {
              return FerroChip(
                label: term,
                icon: Icons.history_rounded,
                isSelected: false,
                onTap: () {
                  _searchController.text = term;
                  _onQueryChanged(term);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: FerroDimensions.space24),
        ],

        // Browse by Genre
        Text('Telusuri Menurut Kategori', style: FerroTypography.headline),
        const SizedBox(height: FerroDimensions.space12),
        Builder(
          builder: (context) {
            final songGenres = PlayerController.instance.allSongs.map((s) => s.genre).where((g) => g.isNotEmpty).toSet().toList();
            final genres = songGenres.isNotEmpty ? songGenres : const ['FLAC Hi-Res', 'WAV Master', 'MP3 Lossy', 'Rock', 'Electronic', 'Jazz'];
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: FerroDimensions.space12,
                crossAxisSpacing: FerroDimensions.space12,
                childAspectRatio: 2.0,
              ),
              itemCount: genres.length,
              itemBuilder: (context, index) {
                final genre = genres[index];
            return InkWell(
              borderRadius: FerroDimensions.radiusCardAll,
              onTap: () {
                _searchController.text = genre;
                _onQueryChanged(genre);
              },
              child: Container(
                padding: const EdgeInsets.all(FerroDimensions.space12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [FerroColors.surfaceHigh, FerroColors.surface],
                  ),
                  borderRadius: FerroDimensions.radiusCardAll,
                  border: Border.all(color: FerroColors.divider, width: 1.0),
                ),
                child: Center(
                  child: Text(
                    genre,
                    style: FerroTypography.title.copyWith(fontSize: 14.5),
                  ),
                ),
              ),
            );
          },
        );
      },
    ),
      ],
    );
  }

  Widget _buildSearchShimmer() {
    return Shimmer.fromColors(
      baseColor: FerroColors.surface,
      highlightColor: FerroColors.surfaceHigh,
      child: ListView.separated(
        padding: const EdgeInsets.all(FerroDimensions.space16),
        itemCount: 5,
        separatorBuilder: (_, _) => const SizedBox(height: 12.0),
        itemBuilder: (_, _) => Container(
          height: 64.0,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: FerroDimensions.radiusCardAll,
          ),
        ),
      ),
    );
  }
}
