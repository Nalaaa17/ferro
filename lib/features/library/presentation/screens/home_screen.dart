import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/widgets.dart';
import 'package:ferro/data/sources/mock_catalog.dart';
import 'package:ferro/features/player/presentation/providers/player_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isRefreshing = false;

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
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() => _isRefreshing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FerroColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32.0,
              height: 32.0,
              decoration: const BoxDecoration(
                gradient: FerroColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.graphic_eq_rounded, size: 18.0, color: Colors.white),
              ),
            ),
            const SizedBox(width: FerroDimensions.space12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: FerroTypography.headline.copyWith(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '10 Lagu Siap Diputar Offline',
                  style: FerroTypography.caption.copyWith(
                    fontSize: 11.0,
                    color: FerroColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cast_connected_rounded),
            tooltip: 'Perangkat Audio Aktif',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Perangkat Aktif: Speaker Internal (EQ Default)'),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Pengaturan',
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: FerroColors.primary,
        backgroundColor: FerroColors.surfaceHigh,
        child: _isRefreshing
            ? _buildShimmerSkeleton()
            : SingleChildScrollView(
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
                    // Section 1: Putar Lagi Cepat
                    _buildSectionHeader('Putar Lagi Cepat', onActionPressed: () {}),
                    const SizedBox(height: FerroDimensions.space12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      child: Row(
                        children: MockCatalog.albums.map((album) {
                          return Padding(
                            padding: const EdgeInsets.only(right: FerroDimensions.space16),
                            child: AlbumCard(
                              title: album.title,
                              subtitle: '${album.artist} • ${album.year}',
                              onTap: () {},
                              onPlayTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Memutar album: ${album.title}')),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: FerroDimensions.space28),

                    // Section 2: Baru Ditambahkan (2 Kolom Compact Grid)
                    _buildSectionHeader('Baru Ditambahkan', onActionPressed: () {}),
                    const SizedBox(height: FerroDimensions.space12),
                    Card(
                      child: Column(
                        children: List.generate(4, (index) {
                          final song = MockCatalog.songs[index];
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
                              if (index < 3) const Divider(height: 1, indent: 72),
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
                        children: MockCatalog.songs
                            .where((s) => s.playCount > 100)
                            .map((song) {
                          return Container(
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
                                        '${song.playCount}x diputar',
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
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: FerroDimensions.space28),

                    // Section 4: Rekomendasi dari Koleksimu
                    _buildSectionHeader('Rekomendasi dari Koleksimu', onActionPressed: () {}),
                    const SizedBox(height: FerroDimensions.space4),
                    Text(
                      'Dipilih secara offline dari lagu favorit dan genre yang sering kamu dengar.',
                      style: FerroTypography.caption,
                    ),
                    const SizedBox(height: FerroDimensions.space12),
                    Card(
                      child: Column(
                        children: List.generate(3, (index) {
                          final song = MockCatalog.songs[index + 4];
                          return Column(
                            children: [
                              SongTile(
                                title: song.title,
                                artist: '${song.artist} • ${song.genre}',
                                durationText: song.durationString,
                                onTap: () {},
                                onMoreTap: () {},
                              ),
                              if (index < 2) const Divider(height: 1, indent: 72),
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
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

  Widget _buildShimmerSkeleton() {
    return Shimmer.fromColors(
      baseColor: FerroColors.surface,
      highlightColor: FerroColors.surfaceHigh,
      child: ListView(
        padding: const EdgeInsets.all(FerroDimensions.space16),
        children: [
          Container(
            height: 24.0,
            width: 140.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
          const SizedBox(height: FerroDimensions.space16),
          Row(
            children: List.generate(
              2,
              (index) => Container(
                width: 160.0,
                height: 160.0,
                margin: const EdgeInsets.only(right: 16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: FerroDimensions.radiusCardAll,
                ),
              ),
            ),
          ),
          const SizedBox(height: FerroDimensions.space24),
          Container(
            height: 180.0,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: FerroDimensions.radiusCardAll,
            ),
          ),
        ],
      ),
    );
  }
}
