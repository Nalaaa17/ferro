import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/widgets.dart';
import 'package:ferro/features/car_mode/presentation/screens/car_mode_screen.dart';
import 'package:ferro/features/devices/presentation/screens/devices_screen.dart';
import 'package:ferro/features/equalizer/presentation/providers/equalizer_controller.dart';
import 'package:ferro/features/equalizer/presentation/screens/equalizer_screen.dart';
import 'package:ferro/features/lyrics/presentation/screens/lyrics_screen.dart';
import 'package:ferro/features/player/presentation/providers/player_controller.dart';
import 'package:ferro/features/player/presentation/widgets/queue_sheet.dart';

/// Fullscreen immersive Now Playing screen per PRD §4.8.
class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> with SingleTickerProviderStateMixin {
  final PlayerController _player = PlayerController.instance;
  final EqualizerController _eq = EqualizerController.instance;

  late final AnimationController _heartAnimController;
  late final Animation<double> _heartScale;

  @override
  void initState() {
    super.initState();
    _player.addListener(_onPlayerStateChanged);
    _eq.addListener(_onPlayerStateChanged);

    _heartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _heartScale = Tween<double>(begin: 1.0, end: 1.35).animate(
      CurvedAnimation(parent: _heartAnimController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _player.removeListener(_onPlayerStateChanged);
    _eq.removeListener(_onPlayerStateChanged);
    _heartAnimController.dispose();
    super.dispose();
  }

  void _onPlayerStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onToggleFavorite() {
    _heartAnimController.forward().then((_) => _heartAnimController.reverse());
    _player.toggleFavorite();
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = _player.currentSong;
    final screenWidth = MediaQuery.of(context).size.width;
    final artSize = (screenWidth * 0.74).clamp(240.0, 380.0);

    return Scaffold(
      backgroundColor: FerroColors.background,
      body: Stack(
        children: [
          // 1. Dynamic Blurred Background (Sampled Accent Color)
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.0, -0.3),
                radius: 1.2,
                colors: [
                  currentSong.accentColor.withValues(alpha: 0.35),
                  FerroColors.background,
                ],
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
            child: Container(
              color: Colors.black.withValues(alpha: 0.55),
            ),
          ),

          // 2. Main Player Interactive Surface
          SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              // Swipe down gesture to dismiss to MiniPlayer
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity != null && details.primaryVelocity! > 300) {
                  Navigator.of(context).pop();
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: FerroDimensions.space24),
                child: Column(
                  children: [
                    // Top Bar (Chevron Down, Device Pill, More Menu)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 32.0),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        // Device Badge Pill (Interactive)
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(builder: (_) => const DevicesScreen()),
                            );
                          },
                          borderRadius: FerroDimensions.radiusPillAll,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                            decoration: BoxDecoration(
                              color: FerroColors.surfaceHigh,
                              borderRadius: FerroDimensions.radiusPillAll,
                              border: Border.all(color: FerroColors.divider, width: 1.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _eq.activeProfile.connectionType == 'usb'
                                      ? Icons.usb_rounded
                                      : _eq.activeProfile.connectionType == 'wired'
                                          ? Icons.headphones_rounded
                                          : Icons.bluetooth_audio_rounded,
                                  size: 16.0,
                                  color: FerroColors.success,
                                ),
                                const SizedBox(width: FerroDimensions.space6),
                                Text(
                                  _eq.activeProfile.displayName,
                                  style: FerroTypography.captionBold.copyWith(
                                    color: FerroColors.onSurface,
                                    fontSize: 11.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.directions_car_rounded, size: 24.0),
                              tooltip: 'Mode Mobil (Car Mode)',
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(builder: (_) => const CarModeScreen()),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.more_horiz_rounded, size: 26.0),
                              onPressed: () => _showMoreMenu(context),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Hero Album Art with Horizontal Swipe Gestures (Prev/Next)
                    GestureDetector(
                      onHorizontalDragEnd: (details) {
                        if (details.primaryVelocity != null) {
                          if (details.primaryVelocity! < -250) {
                            _player.next();
                          } else if (details.primaryVelocity! > 250) {
                            _player.previous();
                          }
                        }
                      },
                      child: Hero(
                        tag: 'now-playing-art-hero',
                        child: Container(
                          width: artSize,
                          height: artSize,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: [
                              BoxShadow(
                                color: currentSong.accentColor.withValues(alpha: 0.3),
                                blurRadius: 40.0,
                                offset: const Offset(0, 16),
                              ),
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.6),
                                blurRadius: 20.0,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: ArtworkPlaceholder(
                              size: artSize,
                              borderRadius: BorderRadius.circular(16.0),
                              iconSize: artSize * 0.35,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Title, Artist, and Favorite Heart
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentSong.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: FerroTypography.display.copyWith(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: FerroDimensions.space4),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${currentSong.artist} — ${currentSong.album}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: FerroTypography.body.copyWith(
                                        color: FerroColors.onSurfaceMuted,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: FerroDimensions.space8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                    decoration: BoxDecoration(
                                      color: FerroColors.surfaceHigh,
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: Text(
                                      currentSong.format,
                                      style: FerroTypography.captionBold.copyWith(
                                        color: FerroColors.primary,
                                        fontSize: 10.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: FerroDimensions.space12),
                        ScaleTransition(
                          scale: _heartScale,
                          child: IconButton(
                            icon: Icon(
                              currentSong.isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: currentSong.isFavorite ? FerroColors.error : FerroColors.onSurfaceMuted,
                              size: 28.0,
                            ),
                            onPressed: _onToggleFavorite,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: FerroDimensions.space16),

                    // Interactive Seek Bar
                    FerroSeekBar(
                      position: _player.position,
                      duration: _player.duration,
                      bufferedPosition: _player.bufferedPosition,
                      onChanged: _player.seek,
                      onChangeEnd: _player.seek,
                    ),
                    const SizedBox(height: FerroDimensions.space16),

                    // Main Controls Row (Shuffle, Prev, Play/Pause 64dp, Next, Repeat)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Shuffle button
                        IconButton(
                          icon: Icon(
                            Icons.shuffle_rounded,
                            color: _player.isShuffle ? FerroColors.primary : FerroColors.onSurfaceMuted,
                            size: 24.0,
                          ),
                          onPressed: _player.toggleShuffle,
                        ),
                        // Prev button
                        IconButton(
                          icon: const Icon(
                            Icons.skip_previous_rounded,
                            size: 38.0,
                            color: FerroColors.onSurface,
                          ),
                          onPressed: _player.previous,
                        ),
                        // Play / Pause Giant Button (64dp)
                        GestureDetector(
                          onTap: _player.togglePlayPause,
                          child: Container(
                            width: 64.0,
                            height: 64.0,
                            decoration: BoxDecoration(
                              gradient: FerroColors.primaryGradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: FerroColors.primary.withValues(alpha: 0.45),
                                  blurRadius: 20.0,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                _player.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                size: 36.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        // Next button
                        IconButton(
                          icon: const Icon(
                            Icons.skip_next_rounded,
                            size: 38.0,
                            color: FerroColors.onSurface,
                          ),
                          onPressed: _player.next,
                        ),
                        // Repeat button
                        IconButton(
                          icon: Icon(
                            _player.repeatMode == FerroRepeatMode.one
                                ? Icons.repeat_one_rounded
                                : Icons.repeat_rounded,
                            color: _player.repeatMode != FerroRepeatMode.off
                                ? FerroColors.primary
                                : FerroColors.onSurfaceMuted,
                            size: 24.0,
                          ),
                          onPressed: _player.toggleRepeat,
                        ),
                      ],
                    ),
                    const SizedBox(height: FerroDimensions.space16),

                    // Volume Slider Row
                    Row(
                      children: [
                        const Icon(
                          Icons.volume_mute_rounded,
                          size: 18.0,
                          color: FerroColors.onSurfaceMuted,
                        ),
                        Expanded(
                          child: SliderTheme(
                            data: Theme.of(context).sliderTheme.copyWith(
                              trackHeight: 2.0,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4.5),
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 10.0),
                            ),
                            child: Slider(
                              value: _player.volume,
                              onChanged: _player.setVolume,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.volume_up_rounded,
                          size: 18.0,
                          color: FerroColors.onSurfaceMuted,
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Bottom Action Row (Lyrics, Queue, EQ, Devices)
                    Padding(
                      padding: const EdgeInsets.only(bottom: FerroDimensions.space12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildBottomAction(
                            icon: Icons.lyrics_rounded,
                            label: 'Lirik',
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder<void>(
                                  pageBuilder: (context, animation, secondaryAnimation) =>
                                      const LyricsScreen(),
                                  transitionsBuilder:
                                      (context, animation, secondaryAnimation, child) {
                                    const begin = Offset(0.0, 1.0);
                                    const end = Offset.zero;
                                    const curve = Curves.easeOutCubic;
                                    final tween =
                                        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                    return SlideTransition(position: animation.drive(tween), child: child);
                                  },
                                ),
                              );
                            },
                          ),
                          _buildBottomAction(
                            icon: Icons.queue_music_rounded,
                            label: 'Antrian',
                            onTap: () => QueueSheet.show(context),
                          ),
                          _buildBottomAction(
                            icon: Icons.equalizer_rounded,
                            label: 'Equalizer',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(builder: (_) => const EqualizerScreen()),
                              );
                            },
                          ),
                          _buildBottomAction(
                            icon: Icons.devices_rounded,
                            label: 'Perangkat',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(builder: (_) => const DevicesScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22.0, color: FerroColors.onSurfaceMuted),
            const SizedBox(height: 3.0),
            Text(
              label,
              style: FerroTypography.caption.copyWith(
                fontSize: 11.0,
                color: FerroColors.onSurfaceMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: FerroColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: FerroDimensions.radiusSheetTop,
        side: BorderSide(color: FerroColors.divider, width: 1.0),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline_rounded, color: FerroColors.onSurface),
                title: Text('Detail File Audio', style: FerroTypography.title),
                subtitle: Text('${_player.currentSong.format} • ${_player.currentSong.quality}', style: FerroTypography.caption),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.playlist_add_rounded, color: FerroColors.onSurface),
                title: Text('Tambah ke Playlist', style: FerroTypography.title),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.share_outlined, color: FerroColors.onSurface),
                title: Text('Bagikan Info Lagu', style: FerroTypography.title),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
