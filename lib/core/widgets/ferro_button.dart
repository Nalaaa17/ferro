import 'package:flutter/material.dart';
import 'package:ferro/app/theme/theme.dart';

enum FerroButtonVariant {
  filled,
  outline,
  text,
}

/// Pill button (48dp height) with filled gradient, outline, or text variants per PRD §3.5.
class FerroButton extends StatefulWidget {
  const FerroButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = FerroButtonVariant.filled,
    this.icon,
    this.height = FerroDimensions.minTouchTarget,
    this.fullWidth = false,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final FerroButtonVariant variant;
  final IconData? icon;
  final double height;
  final bool fullWidth;
  final bool isLoading;

  @override
  State<FerroButton> createState() => _FerroButtonState();
}

class _FerroButtonState extends State<FerroButton> {
  bool _isHovered = false;

  bool get _isEnabled => widget.onPressed != null && !widget.isLoading;

  @override
  Widget build(BuildContext context) {
    final effectiveContent = Row(
      mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading) ...[
          const SizedBox(
            width: 18.0,
            height: 18.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(width: FerroDimensions.space8),
        ] else if (widget.icon != null) ...[
          Icon(
            widget.icon,
            size: 20.0,
            color: _getContentColor(),
          ),
          const SizedBox(width: FerroDimensions.space8),
        ],
        Flexible(
          child: Text(
            widget.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: FerroTypography.title.copyWith(
              color: _getContentColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: _isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        height: widget.height,
        constraints: BoxConstraints(
          minWidth: widget.fullWidth ? double.infinity : 96.0,
        ),
        decoration: _getBoxDecoration(),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _isEnabled ? widget.onPressed : null,
            borderRadius: FerroDimensions.radiusButtonPillAll,
            splashColor: Colors.white.withValues(alpha: 0.15),
            highlightColor: Colors.white.withValues(alpha: 0.08),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: FerroDimensions.space20,
              ),
              child: effectiveContent,
            ),
          ),
        ),
      ),
    );
  }

  Color _getContentColor() {
    if (!_isEnabled) return FerroColors.onSurfaceDisabled;
    switch (widget.variant) {
      case FerroButtonVariant.filled:
        return Colors.white;
      case FerroButtonVariant.outline:
        return _isHovered ? FerroColors.primaryLight : FerroColors.onSurface;
      case FerroButtonVariant.text:
        return _isHovered ? FerroColors.primaryLight : FerroColors.primary;
    }
  }

  BoxDecoration _getBoxDecoration() {
    final isEnabled = _isEnabled;

    switch (widget.variant) {
      case FerroButtonVariant.filled:
        return BoxDecoration(
          gradient: isEnabled
              ? (_isHovered
                  ? const LinearGradient(
                      colors: [Color(0xFFFF8B38), Color(0xFFFF526C)],
                    )
                  : FerroColors.primaryGradient)
              : null,
          color: isEnabled ? null : FerroColors.surfaceHigh,
          borderRadius: FerroDimensions.radiusButtonPillAll,
          boxShadow: isEnabled && _isHovered
              ? [
                  BoxShadow(
                    color: FerroColors.primary.withValues(alpha: 0.35),
                    blurRadius: 16.0,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        );
      case FerroButtonVariant.outline:
        return BoxDecoration(
          color: _isHovered ? FerroColors.surfaceHigh : Colors.transparent,
          borderRadius: FerroDimensions.radiusButtonPillAll,
          border: Border.all(
            color: isEnabled
                ? (_isHovered ? FerroColors.primary : FerroColors.divider)
                : FerroColors.divider.withValues(alpha: 0.5),
            width: 1.2,
          ),
        );
      case FerroButtonVariant.text:
        return BoxDecoration(
          color: _isHovered ? FerroColors.surfaceHigh.withValues(alpha: 0.5) : Colors.transparent,
          borderRadius: FerroDimensions.radiusButtonPillAll,
        );
    }
  }
}
