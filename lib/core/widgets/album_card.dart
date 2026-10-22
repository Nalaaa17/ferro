import 'package:flutter/material.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/artwork_placeholder.dart';

/// AlbumCard widget (160dp width) with 1:1 rounded 12dp artwork and play button overlay per PRD §3.5.
class AlbumCard extends StatefulWidget {
  const AlbumCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.artworkUrl,
    this.artworkWidget,
    this.width = FerroDimensions.albumCardWidth,
    this.onTap,
    this.onPlayTap,
  });

  final String title;
  final String subtitle;
  final String? artworkUrl;
  final Widget? artworkWidget;
  final double width;
  final VoidCallback? onTap;
  final VoidCallback? onPlayTap;

  @override
  State<AlbumCard> createState() => _AlbumCardState();
}

class _AlbumCardState extends State<AlbumCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: widget.width,
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1:1 Artwork Container with Overlay Play Button
              SizedBox(
                width: widget.width,
                height: widget.width,
                child: Stack(
                  children: [
                    // Base Image
                    ClipRRect(
                      borderRadius: FerroDimensions.radiusCardAll,
                      child: widget.artworkWidget ??
                          (widget.artworkUrl != null && widget.artworkUrl!.isNotEmpty
                              ? Image.network(
                                  widget.artworkUrl!,
                                  width: widget.width,
                                  height: widget.width,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => ArtworkPlaceholder(
                                    size: widget.width,
                                    borderRadius: FerroDimensions.radiusCardAll,
                                  ),
                                )
                              : ArtworkPlaceholder(
                                  size: widget.width,
                                  borderRadius: FerroDimensions.radiusCardAll,
                                )),
                    ),

                    // Border overlay
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: FerroDimensions.radiusCardAll,
                        border: Border.fromBorderSide(
                          BorderSide(color: FerroColors.divider, width: 1.0),
                        ),
                      ),
                    ),

                    // Play Button Overlay (Animated on hover/pressed)
                    Positioned(
                      right: FerroDimensions.space8,
                      bottom: FerroDimensions.space8,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: _isHovered ? 1.0 : 0.0,
                        curve: Curves.easeOutCubic,
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 200),
                          scale: _isHovered ? 1.0 : 0.8,
                          curve: Curves.easeOutCubic,
                          child: Container(
                            width: 42.0,
                            height: 42.0,
                            decoration: BoxDecoration(
                              gradient: FerroColors.primaryGradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  blurRadius: 10.0,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: widget.onPlayTap ?? widget.onTap,
                                customBorder: const CircleBorder(),
                                child: const Center(
                                  child: Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 26.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: FerroDimensions.space8),

              // Title (max 2 lines)
              Text(
                widget.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: FerroTypography.title.copyWith(
                  color: _isHovered ? FerroColors.primaryLight : FerroColors.onSurface,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: FerroDimensions.space2),

              // Subtitle / Artist (max 1 line)
              Text(
                widget.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: FerroTypography.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
