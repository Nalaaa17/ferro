import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/ferro_button.dart';

/// Empty state presentation with Lottie animation or fallback illustration + CTA per PRD §3.5.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.description,
    this.lottieAsset,
    this.icon = Icons.music_off_rounded,
    this.actionLabel,
    this.onActionPressed,
    this.actionIcon,
  });

  final String title;
  final String description;
  final String? lottieAsset;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final IconData? actionIcon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: FerroDimensions.space32,
          vertical: FerroDimensions.space24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Illustration (Lottie or Fallback Icon with Glowing Halo)
            SizedBox(
              width: 160.0,
              height: 160.0,
              child: lottieAsset != null
                  ? Lottie.asset(
                      lottieAsset!,
                      width: 160.0,
                      height: 160.0,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => _buildFallbackIllustration(),
                    )
                  : _buildFallbackIllustration(),
            ),
            const SizedBox(height: FerroDimensions.space20),

            // Headline
            Text(
              title,
              textAlign: TextAlign.center,
              style: FerroTypography.headline.copyWith(
                color: FerroColors.onSurface,
              ),
            ),
            const SizedBox(height: FerroDimensions.space8),

            // Description
            Text(
              description,
              textAlign: TextAlign.center,
              style: FerroTypography.body.copyWith(
                color: FerroColors.onSurfaceMuted,
                height: 1.4,
              ),
            ),

            // Optional CTA Action
            if (actionLabel != null && onActionPressed != null) ...[
              const SizedBox(height: FerroDimensions.space24),
              FerroButton(
                label: actionLabel!,
                icon: actionIcon,
                onPressed: onActionPressed,
                variant: FerroButtonVariant.filled,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackIllustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer soft glow
        Container(
          width: 130.0,
          height: 130.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                FerroColors.primary.withValues(alpha: 0.15),
                Colors.transparent,
              ],
            ),
          ),
        ),
        // Inner circle
        Container(
          width: 80.0,
          height: 80.0,
          decoration: BoxDecoration(
            color: FerroColors.surfaceHigh,
            shape: BoxShape.circle,
            border: Border.all(color: FerroColors.divider, width: 1.2),
          ),
          child: Center(
            child: Icon(
              icon,
              size: 38.0,
              color: FerroColors.primaryLight,
            ),
          ),
        ),
      ],
    );
  }
}
