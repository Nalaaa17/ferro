import 'package:flutter/material.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/artwork_placeholder.dart';

/// SongTile widget (64dp height) with 48dp artwork, title, subtitle, and trailing action per PRD §3.5.
class SongTile extends StatefulWidget {
  const SongTile({
    super.key,
    required this.title,
    required this.artist,
    this.artworkUrl,
    this.artworkWidget,
    this.durationText,
    this.trackNumber,
    this.isPlaying = false,
    this.isSelectMode = false,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
    this.onMoreTap,
  });

  final String title;
  final String artist;
  final String? artworkUrl;
  final Widget? artworkWidget;
  final String? durationText;
  final int? trackNumber;
  final bool isPlaying;
  final bool isSelectMode;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onMoreTap;

  @override
  State<SongTile> createState() => _SongTileState();
}

class _SongTileState extends State<SongTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: FerroDimensions.songTileHeight,
        decoration: BoxDecoration(
          color: widget.isSelected
              ? FerroColors.surfaceHigh
              : (_isHovered ? FerroColors.surfaceHigh.withValues(alpha: 0.5) : Colors.transparent),
          borderRadius: FerroDimensions.radiusCardAll,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            borderRadius: FerroDimensions.radiusCardAll,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: FerroDimensions.space12,
                vertical: FerroDimensions.space8,
              ),
              child: Row(
                children: [
                  // Multi-select Checkbox or Track Number or Artwork
                  if (widget.isSelectMode) ...[
                    SizedBox(
                      width: 32.0,
                      child: Icon(
                        widget.isSelected
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: widget.isSelected ? FerroColors.primary : FerroColors.onSurfaceMuted,
                        size: 22.0,
                      ),
                    ),
                    const SizedBox(width: FerroDimensions.space8),
                  ] else if (widget.trackNumber != null) ...[
                    SizedBox(
                      width: 28.0,
                      child: Text(
                        widget.trackNumber.toString().padLeft(2, '0'),
                        style: FerroTypography.caption.copyWith(
                          color: widget.isPlaying ? FerroColors.primary : FerroColors.onSurfaceMuted,
                          fontWeight: widget.isPlaying ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(width: FerroDimensions.space8),
                  ],

                  // Artwork (48dp x 48dp)
                  SizedBox(
                    width: 48.0,
                    height: 48.0,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: FerroDimensions.radiusArtworkAll,
                          child: widget.artworkWidget ??
                              (widget.artworkUrl != null && widget.artworkUrl!.isNotEmpty
                                  ? Image.network(
                                      widget.artworkUrl!,
                                      width: 48.0,
                                      height: 48.0,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) => const ArtworkPlaceholder(size: 48.0),
                                    )
                                  : const ArtworkPlaceholder(size: 48.0)),
                        ),
                        if (widget.isPlaying)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.45),
                              borderRadius: FerroDimensions.radiusArtworkAll,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.equalizer_rounded,
                                color: FerroColors.primary,
                                size: 24.0,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: FerroDimensions.space12),

                  // Title and Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: FerroTypography.title.copyWith(
                            color: widget.isPlaying ? FerroColors.primary : FerroColors.onSurface,
                            fontWeight: widget.isPlaying ? FontWeight.w700 : FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: FerroDimensions.space2),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.artist,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: FerroTypography.caption,
                              ),
                            ),
                            if (widget.durationText != null) ...[
                              const SizedBox(width: FerroDimensions.space8),
                              Text(
                                widget.durationText!,
                                style: FerroTypography.monoTimer.copyWith(
                                  fontSize: 11.0,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Trailing Action (More button with 48dp hit area)
                  if (!widget.isSelectMode && widget.onMoreTap != null)
                    IconButton(
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: FerroColors.onSurfaceMuted,
                        size: 20.0,
                      ),
                      splashRadius: 24.0,
                      onPressed: widget.onMoreTap,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
