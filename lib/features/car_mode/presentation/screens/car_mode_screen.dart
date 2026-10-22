import 'package:flutter/material.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/widgets.dart';
import 'package:ferro/features/player/presentation/providers/player_controller.dart';

/// Safety-first Car Mode screen with giant touch targets (≥64dp) per PRD §4.16.
class CarModeScreen extends StatefulWidget {
  const CarModeScreen({super.key});

  @override
  State<CarModeScreen> createState() => _CarModeScreenState();
}

class _CarModeScreenState extends State<CarModeScreen> {
  final PlayerController _player = PlayerController.instance;

  @override
  void initState() {
    super.initState();
    _player.addListener(_onPlayerStateChanged);
  }

  @override
  void dispose() {
    _player.removeListener(_onPlayerStateChanged);
    super.dispose();
  }

  void _onPlayerStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = _player.currentSong;

    return Scaffold(
      backgroundColor: Colors.black, // Pure black for maximum contrast and safety
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: FerroDimensions.space20,
            vertical: FerroDimensions.space16,
          ),
          child: Column(
            children: [
              // 1. Top Bar: CAR MODE Badge & Exit Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.directions_car_rounded, color: FerroColors.primary, size: 28.0),
                      const SizedBox(width: FerroDimensions.space8),
                      Text(
                        'CAR MODE',
                        style: FerroTypography.title.copyWith(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  FerroButton(
                    label: 'Keluar',
                    icon: Icons.exit_to_app_rounded,
                    height: 44.0,
                    variant: FerroButtonVariant.outline,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),

              const Spacer(),

              // 2. Album Art (200dp) with Left/Right Tap Gestures for Prev/Next
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 200.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: FerroColors.primary, width: 2.0),
                      boxShadow: [
                        BoxShadow(
                          color: FerroColors.primary.withValues(alpha: 0.3),
                          blurRadius: 24.0,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18.0),
                      child: const ArtworkPlaceholder(
                        size: 200.0,
                        iconSize: 72.0,
                      ),
                    ),
                  ),

                  // Tap left half = previous, Tap right half = next
                  SizedBox(
                    width: 200.0,
                    height: 200.0,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: _player.previous,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.chevron_left_rounded, color: Colors.white, size: 32.0),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: _player.next,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 32.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: FerroDimensions.space20),

              // 3. High-Contrast Track Info
              Text(
                currentSong.title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: FerroTypography.display.copyWith(
                  fontSize: 26.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: FerroDimensions.space6),
              Text(
                '${currentSong.artist} • ${currentSong.format}',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: FerroTypography.title.copyWith(
                  fontSize: 16.0,
                  color: FerroColors.onSurfaceMuted,
                ),
              ),

              const Spacer(),

              // 4. Giant Controls Row: 72dp Prev, 96dp Play/Pause, 72dp Next
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Giant Previous (72dp)
                  GestureDetector(
                    onTap: _player.previous,
                    child: Container(
                      width: 72.0,
                      height: 72.0,
                      decoration: BoxDecoration(
                        color: FerroColors.surfaceHigh,
                        shape: BoxShape.circle,
                        border: Border.all(color: FerroColors.divider, width: 1.5),
                      ),
                      child: const Center(
                        child: Icon(Icons.skip_previous_rounded, size: 44.0, color: Colors.white),
                      ),
                    ),
                  ),

                  // Raksasa Play/Pause (96dp) per PRD §4.16
                  GestureDetector(
                    onTap: _player.togglePlayPause,
                    child: Container(
                      width: FerroDimensions.carModePlayButtonSize, // 96dp
                      height: FerroDimensions.carModePlayButtonSize,
                      decoration: BoxDecoration(
                        gradient: FerroColors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: FerroColors.primary.withValues(alpha: 0.5),
                            blurRadius: 30.0,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          _player.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          size: 56.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // Giant Next (72dp)
                  GestureDetector(
                    onTap: _player.next,
                    child: Container(
                      width: 72.0,
                      height: 72.0,
                      decoration: BoxDecoration(
                        color: FerroColors.surfaceHigh,
                        shape: BoxShape.circle,
                        border: Border.all(color: FerroColors.divider, width: 1.5),
                      ),
                      child: const Center(
                        child: Icon(Icons.skip_next_rounded, size: 44.0, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // 5. Giant Bottom Action Buttons (≥64dp touch target)
              Row(
                children: [
                  // Favorit Big Button
                  Expanded(
                    child: GestureDetector(
                      onTap: _player.toggleFavorite,
                      child: Container(
                        height: FerroDimensions.carModeTouchTarget, // 64dp
                        decoration: BoxDecoration(
                          color: FerroColors.surface,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: currentSong.isFavorite ? FerroColors.error : FerroColors.divider,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              currentSong.isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: currentSong.isFavorite ? FerroColors.error : Colors.white,
                              size: 28.0,
                            ),
                            const SizedBox(width: FerroDimensions.space8),
                            Text(
                              'Favorit',
                              style: FerroTypography.title.copyWith(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: FerroDimensions.space16),

                  // Acak / Shuffle Big Button
                  Expanded(
                    child: GestureDetector(
                      onTap: _player.toggleShuffle,
                      child: Container(
                        height: FerroDimensions.carModeTouchTarget, // 64dp
                        decoration: BoxDecoration(
                          color: FerroColors.surface,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: _player.isShuffle ? FerroColors.primary : FerroColors.divider,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shuffle_rounded,
                              color: _player.isShuffle ? FerroColors.primary : Colors.white,
                              size: 28.0,
                            ),
                            const SizedBox(width: FerroDimensions.space8),
                            Text(
                              'Acak',
                              style: FerroTypography.title.copyWith(
                                fontSize: 16.0,
                                color: _player.isShuffle ? FerroColors.primary : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: FerroDimensions.space12),
            ],
          ),
        ),
      ),
    );
  }
}
