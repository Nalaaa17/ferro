import 'package:flutter/material.dart';
import 'package:ferro/app/theme/theme.dart';

/// Dynamic artwork placeholder with gradient background and music note icon per PRD §3.5.
class ArtworkPlaceholder extends StatelessWidget {
  const ArtworkPlaceholder({
    super.key,
    this.size,
    this.width,
    this.height,
    this.borderRadius = FerroDimensions.radiusArtworkAll,
    this.iconSize,
    this.icon = Icons.music_note_rounded,
  });

  final double? size;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;
  final double? iconSize;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = size ?? width ?? 48.0;
    final effectiveHeight = size ?? height ?? 48.0;
    final effectiveIconSize = iconSize ?? (effectiveWidth * 0.45).clamp(16.0, 64.0);

    return Container(
      width: effectiveWidth,
      height: effectiveHeight,
      decoration: BoxDecoration(
        gradient: FerroColors.artworkPlaceholderGradient,
        borderRadius: borderRadius,
        border: Border.all(color: FerroColors.divider, width: 1.0),
      ),
      child: Center(
        child: Icon(
          icon,
          size: effectiveIconSize,
          color: FerroColors.primary.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
