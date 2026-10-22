import 'package:flutter/material.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/artwork_placeholder.dart';

/// Persistent MiniPlayer widget (64dp height) positioned directly above BottomNavigationBar per PRD §4.4.
class MiniPlayer extends StatelessWidget {
  const MiniPlayer({
    super.key,
    required this.title,
    required this.artist,
    this.artworkUrl,
    this.isPlaying = false,
    this.progress = 0.35,
    this.onTap,
    this.onPlayPauseTap,
    this.onNextTap,
  });

  final String title;
  final String artist;
  final String? artworkUrl;
  final bool isPlaying;
  final double progress;
  final VoidCallback? onTap;
  final VoidCallback? onPlayPauseTap;
  final VoidCallback? onNextTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: FerroColors.surface,
      elevation: 0,
      child: Container(
        height: FerroDimensions.miniPlayerHeight,
        decoration: const BoxDecoration(
          color: FerroColors.surface,
          border: FerroDimensions.sideBorderTop,
        ),
        child: Stack(
          children: [
            // Thin Progress Bar (2dp) at top of mini player
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 2.0,
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation<Color>(FerroColors.primary),
                ),
              ),
            ),

            // Content Row
            InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: FerroDimensions.space12,
                ),
                child: Row(
                  children: [
                    // Artwork (48dp x 48dp rounded 8) with Hero transition
                    Hero(
                      tag: 'now-playing-art-hero',
                      child: ClipRRect(
                        borderRadius: FerroDimensions.radiusArtworkAll,
                        child: artworkUrl != null && artworkUrl!.isNotEmpty
                            ? Image.network(
                                artworkUrl!,
                                width: 48.0,
                                height: 48.0,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => const ArtworkPlaceholder(size: 48.0),
                              )
                            : const ArtworkPlaceholder(size: 48.0),
                      ),
                    ),
                    const SizedBox(width: FerroDimensions.space12),

                    // Title & Artist
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: FerroTypography.title.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: FerroDimensions.space2),
                          Text(
                            artist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: FerroTypography.caption.copyWith(
                              fontSize: 12.0,
                              color: FerroColors.onSurfaceMuted,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Controls (Play/Pause & Next)
                    IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: FerroColors.onSurface,
                        size: 28.0,
                      ),
                      splashRadius: 24.0,
                      onPressed: onPlayPauseTap,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.skip_next_rounded,
                        color: FerroColors.onSurface,
                        size: 28.0,
                      ),
                      splashRadius: 24.0,
                      onPressed: onNextTap,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
