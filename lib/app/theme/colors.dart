import 'package:flutter/material.dart';

/// Ferro design system color tokens according to PRD Section 3.2.
class FerroColors {
  FerroColors._();

  // Core Background & Surfaces (Spotify-like dark palette)
  static const Color background = Color(0xFF0E0E10);
  static const Color surface = Color(0xFF18181C);
  static const Color surfaceHigh = Color(0xFF242429);
  static const Color surfaceHigher = Color(0xFF2E2E35);

  // Content & Typography
  static const Color onSurface = Color(0xFFF5F5F7);
  static const Color onSurfaceMuted = Color(0xFF9C9CA3);
  static const Color onSurfaceDisabled = Color(0xFF5A5A62);

  // Borders & Dividers (Dark theme uses 1dp borders instead of heavy elevation)
  static const Color divider = Color(0xFF2C2C31);
  static const Color borderLight = Color(0xFF38383F);

  // Primary Accent: Ferro Orange (Metallurgical fire & iron identity)
  static const Color primary = Color(0xFFFF7A1A);
  static const Color primaryLight = Color(0xFFFF9447);
  static const Color primaryDark = Color(0xFFE66505);
  static const Color secondary = Color(0xFFFF3D5A);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF7A1A),
      Color(0xFFFF3D5A),
    ],
  );

  static const LinearGradient cardOverlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      Color(0xCC0E0E10),
    ],
  );

  static const LinearGradient artworkPlaceholderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF261D17),
      Color(0xFF18151D),
    ],
  );

  // Semantic Status
  static const Color success = Color(0xFF2DD4A7);
  static const Color warning = Color(0xFFFFB800);
  static const Color error = Color(0xFFFF5252);
  static const Color info = Color(0xFF3897F0);
}
