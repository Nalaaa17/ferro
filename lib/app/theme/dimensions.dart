import 'package:flutter/material.dart';
import 'package:ferro/app/theme/colors.dart';

/// Ferro design system spacing, radius, and elevation tokens according to PRD Section 3.4.
class FerroDimensions {
  FerroDimensions._();

  // Spacing System (4dp Base Grid)
  static const double space2 = 2.0;
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;
  static const double space64 = 64.0;

  // Corner Radii
  static const double radiusArtwork = 8.0;
  static const double radiusCard = 12.0;
  static const double radiusSheet = 20.0;
  static const double radiusButtonPill = 24.0;
  static const double radiusPill = 999.0;

  // Pre-configured BorderRadius objects
  static const BorderRadius radiusArtworkAll = BorderRadius.all(Radius.circular(radiusArtwork));
  static const BorderRadius radiusCardAll = BorderRadius.all(Radius.circular(radiusCard));
  static const BorderRadius radiusButtonPillAll = BorderRadius.all(Radius.circular(radiusButtonPill));
  static const BorderRadius radiusPillAll = BorderRadius.all(Radius.circular(radiusPill));
  static const BorderRadius radiusSheetTop = BorderRadius.vertical(top: Radius.circular(radiusSheet));

  // Component Metrics & Touch Targets
  static const double minTouchTarget = 48.0;
  static const double miniPlayerHeight = 64.0;
  static const double bottomNavHeight = 72.0;
  static const double albumCardWidth = 160.0;
  static const double songTileHeight = 64.0;
  static const double chipHeight = 32.0;
  static const double carModeTouchTarget = 64.0;
  static const double carModePlayButtonSize = 96.0;

  // Elevation: 1dp Border styling (Dark theme boundary definition)
  static const Border sideBorder = Border.fromBorderSide(
    BorderSide(color: FerroColors.divider, width: 1.0),
  );
  static const Border sideBorderTop = Border(
    top: BorderSide(color: FerroColors.divider, width: 1.0),
  );
  static const Border sideBorderBottom = Border(
    bottom: BorderSide(color: FerroColors.divider, width: 1.0),
  );
  static const BorderSide standardBorderSide = BorderSide(
    color: FerroColors.divider,
    width: 1.0,
  );
}
