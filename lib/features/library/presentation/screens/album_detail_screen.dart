import 'package:flutter/material.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/widgets.dart';
import 'package:ferro/data/sources/mock_catalog.dart';
import 'package:ferro/features/library/presentation/screens/artist_detail_screen.dart';
import 'package:ferro/features/player/presentation/providers/player_controller.dart';

/// Album Detail Screen with hero portrait, metadata, and numbered track list per PRD §4.3.
class AlbumDetailScreen extends StatelessWidget {
  const AlbumDetailScreen({
    super.key,
    required this.album,
  });

  final MockAlbum album;

  @override
  Widget build(BuildContext context) {
    final player = PlayerController.instance;

    // Filter songs matching this album, or use sample songs
    final albumSongs = MockCatalog.songs.where((s) => s.album == album.title).toList();
    final effectiveSongs = albumSongs.isNotEmpty ? albumSongs : MockCatalog.songs.take(6).toList();

    return Scaffold(
      backgroundColor: FerroColors.background,
      appBar: AppBar(
        title: Text(album.title, style: FerroTypography.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Header: Hero Portrait Artwork, Title, Artist, Metadata
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(FerroDimensions.space16),
              child: Column(
                children: [
                  // Hero Artwork (160dp)
                  Container(
                    width: 160.0,
                    height: 160.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: FerroColors.primary.withValues(alpha: 0.25),
                          blurRadius: 24.0,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: const ArtworkPlaceholder(
                        size: 160.0,
                        icon: Icons.album_rounded,
                        iconSize: 64.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: FerroDimensions.space16),

                  // Album Title
                  Text(
                    album.title,
                    textAlign: TextAlign.center,
                    style: FerroTypography.headline.copyWith(fontSize: 22.0),
                  ),
                  const SizedBox(height: FerroDimensions.space6),

                  // Artist Name (Clickable)
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => ArtistDetailScreen(artistName: album.artist),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(4.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.person_rounded, size: 16.0, color: FerroColors.primaryLight),
                          const SizedBox(width: 4.0),
                          Text(
                            album.artist,
                            style: FerroTypography.title.copyWith(
                              color: FerroColors.primaryLight,
                              fontSize: 15.0,
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, size: 16.0, color: FerroColors.primaryLight),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: FerroDimensions.space6),

                  // Meta: Year, Tracks, Audio Format
                  Text(
                    '${album.year} • ${effectiveSongs.length} Lagu • FLAC Hi-Res 96kHz/24bit',
                    style: FerroTypography.caption.copyWith(color: FerroColors.onSurfaceMuted),
                  ),
                  const SizedBox(height: FerroDimensions.space16),

                  // Action Buttons: Play All & Shuffle
                  Row(
                    children: [
                      Expanded(
                        child: FerroButton(
                          label: 'Putar Semua',
                          icon: Icons.play_arrow_rounded,
                          variant: FerroButtonVariant.filled,
                          onPressed: () {
                            if (effectiveSongs.isNotEmpty) {
                              player.play(effectiveSongs.first);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: FerroDimensions.space12),
                      Expanded(
                        child: FerroButton(
                          label: 'Acak',
                          icon: Icons.shuffle_rounded,
                          variant: FerroButtonVariant.outline,
                          onPressed: () {
                            if (effectiveSongs.isNotEmpty) {
                              player.toggleShuffle();
                              player.play(effectiveSongs.first);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: FerroDimensions.space16),
                  const Divider(height: 1.0),
                ],
              ),
            ),
          ),

          // Numbered Track List
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
                  leading: SizedBox(
                    width: 32.0,
                    child: Center(
                      child: isCurrent
                          ? const Icon(Icons.equalizer_rounded, color: FerroColors.primary, size: 20.0)
                          : Text(
                              '${index + 1}',
                              style: FerroTypography.monoTimer.copyWith(
                                color: FerroColors.onSurfaceMuted,
                                fontSize: 13.0,
                              ),
                            ),
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
                  subtitle: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
                        decoration: BoxDecoration(
                          color: FerroColors.surfaceHigh,
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                        child: Text(
                          song.format,
                          style: FerroTypography.captionBold.copyWith(
                            fontSize: 9.0,
                            color: FerroColors.primaryLight,
                          ),
                        ),
                      ),
                      const SizedBox(width: FerroDimensions.space6),
                      Text(song.durationString, style: FerroTypography.caption),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert_rounded, size: 18.0),
                    color: FerroColors.onSurfaceMuted,
                    onPressed: () {},
                  ),
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
