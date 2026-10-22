import 'package:flutter/material.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/widgets.dart';
import 'package:ferro/data/sources/mock_catalog.dart';
import 'package:ferro/features/library/presentation/screens/album_detail_screen.dart';
import 'package:ferro/features/player/presentation/providers/player_controller.dart';

/// Artist Detail Screen with hero portrait, discography view, and popular tracks per PRD §4.3.
class ArtistDetailScreen extends StatelessWidget {
  const ArtistDetailScreen({
    super.key,
    required this.artistName,
  });

  final String artistName;

  @override
  Widget build(BuildContext context) {
    final player = PlayerController.instance;

    // Filter artist songs and albums from library
    final effectiveSongs = player.allSongs
        .where((s) => s.artist.toLowerCase() == artistName.toLowerCase())
        .toList();

    // Group artist albums dynamically
    final albumsMap = <String, List<MockSong>>{};
    for (final song in effectiveSongs) {
      albumsMap.putIfAbsent(song.album, () => []).add(song);
    }
    final effectiveAlbums = albumsMap.entries.map((e) {
      return MockAlbum(
        id: e.key,
        title: e.key,
        artist: artistName,
        year: 2024,
        trackCount: e.value.length,
        songs: e.value,
        artworkUrl: e.value.first.artworkUrl,
      );
    }).toList();

    return Scaffold(
      backgroundColor: FerroColors.background,
      appBar: AppBar(
        title: Text(artistName, style: FerroTypography.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 1. Header Hero Portrait
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(FerroDimensions.space16),
              child: Column(
                children: [
                  Container(
                    width: 130.0,
                    height: 130.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: FerroColors.primaryGradient,
                      boxShadow: [
                        BoxShadow(
                          color: FerroColors.primary.withValues(alpha: 0.35),
                          blurRadius: 24.0,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.person_rounded, size: 70.0, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: FerroDimensions.space16),
                  Text(
                    artistName,
                    textAlign: TextAlign.center,
                    style: FerroTypography.headline.copyWith(fontSize: 22.0),
                  ),
                  const SizedBox(height: FerroDimensions.space4),
                  Text(
                    '${effectiveSongs.length} Lagu di Pustaka • ${effectiveAlbums.length} Album Offline',
                    style: FerroTypography.caption.copyWith(color: FerroColors.onSurfaceMuted),
                  ),
                  const SizedBox(height: FerroDimensions.space16),

                  // Play Artist CTA
                  FerroButton(
                    label: 'Putar Semua Musik $artistName',
                    icon: Icons.play_arrow_rounded,
                    fullWidth: true,
                    onPressed: () {
                      if (effectiveSongs.isNotEmpty) {
                        player.play(effectiveSongs.first);
                      }
                    },
                  ),
                  const SizedBox(height: FerroDimensions.space24),

                  // 2. Discography Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Diskografi Album', style: FerroTypography.title),
                      Text('${effectiveAlbums.length} Album', style: FerroTypography.caption),
                    ],
                  ),
                  const SizedBox(height: FerroDimensions.space12),

                  // Horizontal Album Discography Cards
                  SizedBox(
                    height: 200.0,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: effectiveAlbums.length,
                      separatorBuilder: (context, index) => const SizedBox(width: FerroDimensions.space12),
                      itemBuilder: (context, index) {
                        final album = effectiveAlbums[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => AlbumDetailScreen(album: album),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: 130.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 130.0,
                                  height: 130.0,
                                  decoration: BoxDecoration(
                                    color: FerroColors.surfaceHigh,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.album_rounded, size: 48.0, color: FerroColors.primaryLight),
                                  ),
                                ),
                                const SizedBox(height: FerroDimensions.space6),
                                Text(
                                  album.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: FerroTypography.title.copyWith(fontSize: 13.5),
                                ),
                                Text(
                                  '${album.year} • ${album.trackCount} Lagu',
                                  style: FerroTypography.caption,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: FerroDimensions.space20),

                  // 3. Popular Songs Section Header
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Lagu Populer & Sering Diputar', style: FerroTypography.title),
                  ),
                  const SizedBox(height: FerroDimensions.space8),
                ],
              ),
            ),
          ),

          // Popular Songs List
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final song = effectiveSongs[index];
                final isCurrent = player.currentSong.id == song.id;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: FerroDimensions.space16,
                    vertical: FerroDimensions.space4,
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: const ArtworkPlaceholder(
                      size: 44.0,
                    ),
                  ),
                  title: Text(
                    song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FerroTypography.title.copyWith(
                      color: isCurrent ? FerroColors.primary : FerroColors.onSurface,
                      fontSize: 14.5,
                    ),
                  ),
                  subtitle: Text(
                    '${song.album} • Diputar ${song.playCount}x',
                    style: FerroTypography.caption,
                  ),
                  trailing: Text(song.durationString, style: FerroTypography.monoTimer),
                  onTap: () => player.play(song),
                );
              },
              childCount: effectiveSongs.length,
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 100.0), // Spacing for MiniPlayer
          ),
        ],
      ),
    );
  }
}
