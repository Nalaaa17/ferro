import 'package:flutter/material.dart';
import 'package:ferro/app/theme/theme.dart';

/// Pill filter chip per PRD §3.5. Active state features surfaceHigh background and Ferro Orange border.
class FerroChip extends StatefulWidget {
  const FerroChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
    this.height = FerroDimensions.chipHeight,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;
  final double height;

  @override
  State<FerroChip> createState() => _FerroChipState();
}

class _FerroChipState extends State<FerroChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        height: widget.height,
        padding: const EdgeInsets.symmetric(
          horizontal: FerroDimensions.space12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? FerroColors.surfaceHigh
              : (_isHovered ? FerroColors.surfaceHigh.withValues(alpha: 0.6) : FerroColors.surface),
          borderRadius: FerroDimensions.radiusPillAll,
          border: Border.all(
            color: isSelected
                ? FerroColors.primary
                : (_isHovered ? FerroColors.borderLight : FerroColors.divider),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: FerroColors.primary.withValues(alpha: 0.2),
                    blurRadius: 8.0,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: FerroDimensions.radiusPillAll,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    size: 16.0,
                    color: isSelected ? FerroColors.primary : FerroColors.onSurfaceMuted,
                  ),
                  const SizedBox(width: FerroDimensions.space6),
                ],
                Text(
                  widget.label,
                  style: FerroTypography.captionBold.copyWith(
                    color: isSelected ? FerroColors.onSurface : FerroColors.onSurfaceMuted,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
