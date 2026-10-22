import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ferro/app/theme/colors.dart';
import 'package:ferro/app/theme/dimensions.dart';
import 'package:ferro/app/theme/typography.dart';

export 'package:ferro/app/theme/colors.dart';
export 'package:ferro/app/theme/dimensions.dart';
export 'package:ferro/app/theme/typography.dart';

/// Complete Ferro Theme configuration assembling all design tokens.
class FerroTheme {
  FerroTheme._();

  static ThemeData get darkTheme {
    final textTheme = FerroTypography.textTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: FerroColors.background,
      primaryColor: FerroColors.primary,
      canvasColor: FerroColors.surface,
      dividerColor: FerroColors.divider,
      fontFamily: textTheme.bodyMedium?.fontFamily,
      textTheme: textTheme,
      colorScheme: const ColorScheme.dark(
        primary: FerroColors.primary,
        secondary: FerroColors.secondary,
        surface: FerroColors.surface,
        error: FerroColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: FerroColors.onSurface,
        onError: Colors.white,
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: FerroColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: FerroColors.onSurface),
        titleTextStyle: FerroTypography.headline,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),

      // Card Theme (1dp border boundary, no heavy elevation)
      cardTheme: const CardThemeData(
        color: FerroColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: FerroDimensions.radiusCardAll,
          side: FerroDimensions.standardBorderSide,
        ),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: FerroColors.surface,
        modalBackgroundColor: FerroColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: FerroDimensions.radiusSheetTop,
          side: BorderSide(color: FerroColors.divider, width: 1.0),
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: FerroColors.surface,
        elevation: 0,
        selectedItemColor: FerroColors.primary,
        unselectedItemColor: FerroColors.onSurfaceMuted,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // Slider Theme (Seekbar & Volume styling)
      sliderTheme: const SliderThemeData(
        activeTrackColor: FerroColors.primary,
        inactiveTrackColor: FerroColors.surfaceHigh,
        thumbColor: FerroColors.primary,
        overlayColor: Color(0x33FF7A1A),
        trackHeight: 3.0,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.0),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 14.0),
      ),

      // Switch Theme (Toggle Master Equalizer, Gapless, etc.)
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return FerroColors.onSurfaceMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return FerroColors.primary;
          }
          return FerroColors.surfaceHigh;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // Dialog Theme
      dialogTheme: const DialogThemeData(
        backgroundColor: FerroColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: FerroDimensions.radiusCardAll,
          side: FerroDimensions.standardBorderSide,
        ),
      ),

      // SnackBar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: FerroColors.surfaceHigh,
        contentTextStyle: FerroTypography.body.copyWith(color: FerroColors.onSurface),
        shape: const RoundedRectangleBorder(
          borderRadius: FerroDimensions.radiusCardAll,
          side: FerroDimensions.standardBorderSide,
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Input Decoration Theme (Search Bar & Inputs)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: FerroColors.surfaceHigh,
        hintStyle: FerroTypography.body.copyWith(color: FerroColors.onSurfaceMuted),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: FerroDimensions.space16,
          vertical: FerroDimensions.space12,
        ),
        border: const OutlineInputBorder(
          borderRadius: FerroDimensions.radiusPillAll,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: FerroDimensions.radiusPillAll,
          borderSide: BorderSide(color: FerroColors.divider, width: 1.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: FerroDimensions.radiusPillAll,
          borderSide: BorderSide(color: FerroColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
