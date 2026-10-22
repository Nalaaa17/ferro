import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ferro/app/theme/colors.dart';

/// Ferro design system typography using Google Font Plus Jakarta Sans per PRD Section 3.3.
class FerroTypography {
  FerroTypography._();

  /// Display (28sp, Bold 700) - Judul layar, judul lagu di Now Playing
  static TextStyle get display => GoogleFonts.plusJakartaSans(
    fontSize: 28.0,
    fontWeight: FontWeight.w700,
    color: FerroColors.onSurface,
    letterSpacing: -0.5,
    height: 1.2,
  );

  /// Headline (20sp, SemiBold 600) - Section header, judul album
  static TextStyle get headline => GoogleFonts.plusJakartaSans(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: FerroColors.onSurface,
    letterSpacing: -0.3,
    height: 1.3,
  );

  /// Title (16sp, SemiBold 600) - Judul item list, card
  static TextStyle get title => GoogleFonts.plusJakartaSans(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: FerroColors.onSurface,
    letterSpacing: -0.2,
    height: 1.35,
  );

  /// Body (14sp, Regular 400) - Deskripsi, metadata
  static TextStyle get body => GoogleFonts.plusJakartaSans(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: FerroColors.onSurfaceMuted,
    letterSpacing: 0,
    height: 1.4,
  );

  /// Body Bold / Highlight (14sp, Medium 500)
  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: FerroColors.onSurface,
    letterSpacing: 0,
    height: 1.4,
  );

  /// Caption (12sp, Regular 400) - Timestamp, label kecil
  static TextStyle get caption => GoogleFonts.plusJakartaSans(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: FerroColors.onSurfaceMuted,
    letterSpacing: 0.1,
    height: 1.3,
  );

  /// Caption Bold (12sp, SemiBold 600) - Tag, badge
  static TextStyle get captionBold => GoogleFonts.plusJakartaSans(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    color: FerroColors.onSurface,
    letterSpacing: 0.2,
    height: 1.3,
  );

  /// Mono / Timer (13sp, Medium 500, tabular figures) - Seekbar timestamp
  static TextStyle get monoTimer => GoogleFonts.plusJakartaSans(
    fontSize: 13.0,
    fontWeight: FontWeight.w500,
    color: FerroColors.onSurfaceMuted,
    fontFeatures: const [FontFeature.tabularFigures()],
    letterSpacing: 0.2,
  );

  /// Assembled Material TextTheme
  static TextTheme get textTheme => TextTheme(
    displayLarge: display,
    headlineMedium: headline,
    titleMedium: title,
    bodyMedium: body,
    bodyLarge: bodyMedium,
    bodySmall: caption,
    labelSmall: captionBold,
  );
}
