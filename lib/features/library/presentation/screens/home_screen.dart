import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/widgets.dart';
import 'package:ferro/data/sources/mock_catalog.dart';
import 'package:ferro/features/player/presentation/providers/player_controller.dart';

import 'package:ferro/data/repositories/mock_repositories.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    PlayerController.instance.addListener(_onPlayerUpdate);
  }

  @override
  void dispose() {
    PlayerController.instance.removeListener(_onPlayerUpdate);
    super.dispose();
  }

  void _onPlayerUpdate() {
    if (mounted) setState(() {});
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 11) {
      return 'Selamat Pagi';
    } else if (hour >= 11 && hour < 15) {
      return 'Selamat Siang';
    } else if (hour >= 15 && hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    final count = await PlayerController.instance.scanDeviceMusic(MockSongRepository());
    if (mounted) {
      setState(() => _isRefreshing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pemindaian selesai: $count lagu ditemukan')),
      );
    }
  }

  Future<void> _handleLoadSampleAudio() async {
    setState(() => _isRefreshing = true);
    final count = await PlayerController.instance.generateSamplePlayableTracks(MockSongRepository());
    if (mounted) {
      setState(() => _isRefreshing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sample audio nyata siap diputar ($count lagu)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final allSongs = PlayerController.instance.allSongs;
    final isScanning = PlayerController.instance.isScanning;
    final scanStatus = PlayerController.instance.scanStatus;

    return Scaffold(
      backgroundColor: FerroColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getGreeting(),
              style: FerroTypography.headline.copyWith(
                fontSize: 22.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              allSongs.isEmpty
                  ? 'Pustaka Siap Dipindai'
                  : '${allSongs.length} Lagu Siap Diputar Offline',
              style: FerroTypography.caption.copyWith(
                fontSize: 12.0,
                color: FerroColors.primary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync_rounded, color: FerroColors.primaryLight),
            tooltip: 'Pindai Penyimpanan',
            onPressed: isScanning ? null : _handleRefresh,
          ),
          Padding(
            padding: const EdgeInsets.only(right: FerroDimensions.space16),
            child: Center(
              child: Image.asset(
                'assets/images/ferro_logo.png',
                height: 38.0,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.graphic_eq_rounded,
                  size: 28.0,
                  color: FerroColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: FerroColors.primary,
        backgroundColor: FerroColors.surfaceHigh,
        child: _isRefreshing || isScanning
            ? _buildScanLoading(scanStatus)
            : allSongs.isEmpty
                ? _buildEmptyState()
                : _buildHomeContent(allSongs),
      ),
    );
  }

  Widget _buildScanLoading(String status) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(FerroDimensions.space24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: FerroColors.primary),
            const SizedBox(height: FerroDimensions.space20),
            Text(
              status.isNotEmpty ? status : 'Memindai media penyimpanan...',
              textAlign: TextAlign.center,
              style: FerroTypography.title,
            ),
            const SizedBox(height: FerroDimensions.space8),
            Text(
              'Mencari file FLAC, WAV, MP3, OPUS di penyimpanan perangkat...',
              textAlign: TextAlign.center,
              style: FerroTypography.caption.copyWith(color: FerroColors.onSurfaceMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: FerroDimensions.space24, vertical: FerroDimensions.space40),
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: FerroColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: FerroColors.primary.withValues(alpha: 0.3)),
            ),
            child: const Icon(
              Icons.music_note_rounded,
              size: 56.0,
              color: FerroColors.primary,
            ),
          ),
        ),
        const SizedBox(height: FerroDimensions.space20),
        Text(
          'Pustaka Audio Masih Kosong',
          textAlign: TextAlign.center,
          style: FerroTypography.headline.copyWith(fontSize: 20.0),
        ),
        const SizedBox(height: FerroDimensions.space8),
        Text(
          'Pindai memori perangkat untuk memuat koleksi lagu lokal Anda, atau buat sample audio nyata untuk menguji pemutaran fisik dan equalizer.',
          textAlign: TextAlign.center,
          style: FerroTypography.body.copyWith(color: FerroColors.onSurfaceMuted, height: 1.4),
        ),
        const SizedBox(height: FerroDimensions.space28),
        FerroButton(
          label: 'Pindai Penyimpanan Perangkat',
          icon: Icons.sync_rounded,
          onPressed: _handleRefresh,
        ),
        const SizedBox(height: FerroDimensions.space12),
        FerroButton(
          label: 'Muat Sample Audio Nyata (.wav)',
          icon: Icons.audiotrack_rounded,
          variant: FerroButtonVariant.outline,
          onPressed: _handleLoadSampleAudio,
        ),
      ],
    );
  }

  Widget _buildHomeContent(List<MockSong> allSongs) {
    // Dynamic albums grouped from scanned songs
    final albumsMap = <String, List<MockSong>>{};
    for (final song in allSongs) {
      albumsMap.putIfAbsent(song.album, () => []).add(song);
    }
    final dynamicAlbums = albumsMap.entries.map((e) {
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

    final recentSongs = allSongs.take(4).toList();
    final popularSongs = allSongs.where((s) => s.playCount > 0).take(6).toList();
    final effectivePopular = popularSongs.isNotEmpty ? popularSongs : allSongs.take(6).toList();
    final extraSongs = allSongs.length > 4 ? allSongs.skip(4).take(4).toList() : allSongs;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(
        left: FerroDimensions.space16,
        right: FerroDimensions.space16,
        top: FerroDimensions.space12,
        bottom: FerroDimensions.space32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1: Album Koleksi
          if (dynamicAlbums.isNotEmpty) ...[
            _buildSectionHeader('Album Koleksi', onActionPressed: () {}),
            const SizedBox(height: FerroDimensions.space12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: dynamicAlbums.map((album) {
                  return Padding(
                    padding: const EdgeInsets.only(right: FerroDimensions.space16),
                    child: AlbumCard(
                      title: album.title,
                      subtitle: '${album.artist} • ${album.trackCount} Lagu',
                      onTap: () {},
                      onPlayTap: () {
                        if (album.songs.isNotEmpty) {
                          PlayerController.instance.playSong(album.songs.first);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Memutar album: ${album.title}')),
                          );
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: FerroDimensions.space28),
          ],

          // Section 2: Baru Ditambahkan
          _buildSectionHeader('Baru Ditambahkan', onActionPressed: () {}),
          const SizedBox(height: FerroDimensions.space12),
          Card(
            child: Column(
              children: List.generate(recentSongs.length, (index) {
                final song = recentSongs[index];
                return Column(
                  children: [
                    SongTile(
                      title: song.title,
                      artist: '${song.artist} • ${song.format}',
                      durationText: song.durationString,
                      isPlaying: PlayerController.instance.currentSong.id == song.id && PlayerController.instance.isPlaying,
                      onTap: () => PlayerController.instance.playSong(song),
                      onMoreTap: () {},
                    ),
                    if (index < recentSongs.length - 1) const Divider(height: 1, indent: 72),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: FerroDimensions.space28),

          // Section 3: Paling Sering Diputar
          _buildSectionHeader('Paling Sering Diputar', onActionPressed: () {}),
          const SizedBox(height: FerroDimensions.space12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              children: effectivePopular.map((song) {
                return GestureDetector(
                  onTap: () => PlayerController.instance.playSong(song),
                  child: Container(
                    width: 220.0,
                    margin: const EdgeInsets.only(right: FerroDimensions.space12),
                    padding: const EdgeInsets.all(FerroDimensions.space12),
                    decoration: BoxDecoration(
                      color: FerroColors.surface,
                      borderRadius: FerroDimensions.radiusCardAll,
                      border: Border.all(color: FerroColors.divider, width: 1.0),
                    ),
                    child: Row(
                      children: [
                        const ArtworkPlaceholder(size: 48.0),
                        const SizedBox(width: FerroDimensions.space12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                song.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: FerroTypography.title.copyWith(fontSize: 13.5),
                              ),
                              const SizedBox(height: FerroDimensions.space2),
                              Text(
                                song.format,
                                style: FerroTypography.caption.copyWith(
                                  color: FerroColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: FerroDimensions.space28),

          // Section 4: Rekomendasi Koleksi
          if (extraSongs.isNotEmpty) ...[
            _buildSectionHeader('Rekomendasi Koleksi', onActionPressed: () {}),
            const SizedBox(height: FerroDimensions.space4),
            Text(
              'Dipilih secara offline dari pustaka lagu Anda.',
              style: FerroTypography.caption,
            ),
            const SizedBox(height: FerroDimensions.space12),
            Card(
              child: Column(
                children: List.generate(extraSongs.length, (index) {
                  final song = extraSongs[index];
                  return Column(
                    children: [
                      SongTile(
                        title: song.title,
                        artist: '${song.artist} • ${song.format}',
                        durationText: song.durationString,
                        onTap: () => PlayerController.instance.playSong(song),
                        onMoreTap: () {},
                      ),
                      if (index < extraSongs.length - 1) const Divider(height: 1, indent: 72),
                    ],
                  );
                }),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {required VoidCallback onActionPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: FerroTypography.headline),
        TextButton(
          onPressed: onActionPressed,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: FerroDimensions.space8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Lihat Semua',
            style: FerroTypography.captionBold.copyWith(
              color: FerroColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
