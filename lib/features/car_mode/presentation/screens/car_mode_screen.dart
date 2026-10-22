import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/widgets.dart';
import 'package:ferro/features/player/presentation/providers/player_controller.dart';

/// Next-Gen High-Utility Automotive Car Mode Screen per PRD §4.16 & Driver UX.
/// Features glanceable HUD clock, quick category pills, giant controls, volume steppers,
/// and a driver-friendly quick song switcher modal.
class CarModeScreen extends StatefulWidget {
  const CarModeScreen({super.key});

  @override
  State<CarModeScreen> createState() => _CarModeScreenState();
}

class _CarModeScreenState extends State<CarModeScreen> {
  final PlayerController _player = PlayerController.instance;

  late Timer _clockTimer;
  String _currentTime = '';
  String _selectedCategory = 'Semua Lagu';

  final List<String> _categories = [
    'Semua Lagu',
    'Driving Beat',
    'Favorit Saya',
    'Hi-Res Lossless',
    'Santai Sore',
  ];

  @override
  void initState() {
    super.initState();
    _player.addListener(_onPlayerStateChanged);
    _updateClock();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) => _updateClock());
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    _player.removeListener(_onPlayerStateChanged);
    super.dispose();
  }

  void _updateClock() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    if (mounted) {
      setState(() {
        _currentTime = '$hour:$minute';
      });
    }
  }

  void _onPlayerStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _jumpSeconds(int seconds) {
    final currentMs = _player.position.inMilliseconds;
    final targetMs = (currentMs + (seconds * 1000)).clamp(0, _player.duration.inMilliseconds);
    _player.seek(Duration(milliseconds: targetMs));
  }

  void _adjustVolume(double delta) {
    final newVol = (_player.volume + delta).clamp(0.0, 1.0);
    _player.setVolume(newVol);
  }

  /// Driver-Friendly Quick Song Picker Bottom Sheet (Giant 72dp rows)
  void _openDriverSongPicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.black,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
        side: BorderSide(color: FerroColors.primary, width: 1.5),
      ),
      builder: (context) {
        final songs = _player.allSongs;

        return SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.75,
            padding: const EdgeInsets.symmetric(horizontal: FerroDimensions.space16, vertical: FerroDimensions.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.queue_music_rounded, color: FerroColors.primaryLight, size: 28.0),
                        const SizedBox(width: FerroDimensions.space8),
                        Text(
                          'PILIH LAGU / ANTRIAN',
                          style: FerroTypography.headline.copyWith(
                            fontSize: 18.0,
                            letterSpacing: 1.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 32.0, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: FerroDimensions.space12),
                const Divider(color: FerroColors.divider, height: 1.0),
                const SizedBox(height: FerroDimensions.space12),

                // Giant Song List
                Expanded(
                  child: ListView.separated(
                    itemCount: songs.length,
                    separatorBuilder: (context, index) => const Divider(color: FerroColors.divider, height: 1.0),
                    itemBuilder: (context, index) {
                      final song = songs[index];
                      final isCurrent = _player.currentSong.id == song.id;

                      return InkWell(
                        onTap: () {
                          _player.play(song);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: FerroDimensions.space12),
                          child: Row(
                            children: [
                              Container(
                                width: 52.0,
                                height: 52.0,
                                decoration: BoxDecoration(
                                  color: isCurrent ? FerroColors.primary.withValues(alpha: 0.25) : FerroColors.surfaceHigh,
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    color: isCurrent ? FerroColors.primary : Colors.transparent,
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                  child: isCurrent
                                      ? const Icon(Icons.equalizer_rounded, color: FerroColors.primary, size: 28.0)
                                      : Text(
                                          '${index + 1}',
                                          style: FerroTypography.title.copyWith(color: Colors.white70, fontSize: 18.0),
                                        ),
                                ),
                              ),
                              const SizedBox(width: FerroDimensions.space16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      song.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: FerroTypography.headline.copyWith(
                                        fontSize: 17.0,
                                        color: isCurrent ? FerroColors.primaryLight : Colors.white,
                                        fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      '${song.artist} • ${song.format}',
                                      style: FerroTypography.body.copyWith(
                                        fontSize: 13.0,
                                        color: FerroColors.onSurfaceMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: FerroDimensions.space12),
                              const Icon(Icons.play_circle_fill_rounded, color: FerroColors.primary, size: 36.0),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = _player.currentSong;

    // Up Next Song determination
    final currentIndex = _player.queue.indexWhere((s) => s.id == currentSong.id);
    final nextSong = (currentIndex != -1 && currentIndex + 1 < _player.queue.length)
        ? _player.queue[currentIndex + 1]
        : (_player.queue.isNotEmpty ? _player.queue.first : currentSong);

    final volumePercent = (_player.volume * 100).round();

    return Scaffold(
      backgroundColor: Colors.black, // High-contrast safety black
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: FerroDimensions.space16,
            vertical: FerroDimensions.space12,
          ),
          child: Column(
            children: [
              // 1. Driving HUD Bar: Clock, Driving Badge, and Exit Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: FerroColors.primary.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.directions_car_rounded, color: FerroColors.primaryLight, size: 24.0),
                      ),
                      const SizedBox(width: FerroDimensions.space8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CAR MODE',
                            style: FerroTypography.captionBold.copyWith(
                              letterSpacing: 2.0,
                              color: FerroColors.primaryLight,
                              fontSize: 11.0,
                            ),
                          ),
                          Text(
                            _currentTime,
                            style: FerroTypography.monoTimer.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Quick Switch Playlist/Queue CTA Button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FerroColors.surfaceHigh,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: const BorderSide(color: FerroColors.divider),
                      ),
                    ),
                    icon: const Icon(Icons.playlist_play_rounded, color: FerroColors.primaryLight, size: 22.0),
                    label: Text(
                      'Pilih Lagu',
                      style: FerroTypography.captionBold.copyWith(color: Colors.white, fontSize: 13.0),
                    ),
                    onPressed: _openDriverSongPicker,
                  ),

                  // Exit Button
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 28.0, color: FerroColors.onSurfaceMuted),
                    tooltip: 'Keluar Mode Mobil',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: FerroDimensions.space12),

              // 2. Quick Category / Mood Selector Bar (Giant Glanceable Pills)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: FerroDimensions.space8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = cat;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 1),
                              content: Text('Memuat playlist berkendara: "$cat" 🚗'),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: isSelected ? FerroColors.primary : FerroColors.surface,
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: isSelected ? FerroColors.primaryLight : FerroColors.divider,
                              width: 1.2,
                            ),
                          ),
                          child: Text(
                            cat,
                            style: FerroTypography.captionBold.copyWith(
                              fontSize: 12.0,
                              color: isSelected ? Colors.white : FerroColors.onSurfaceMuted,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const Spacer(flex: 1),

              // 3. Wide Automotive Media Card (Swipe left for Next, Swipe right for Prev)
              GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity != null) {
                    if (details.primaryVelocity! < -200) {
                      _player.next();
                    } else if (details.primaryVelocity! > 200) {
                      _player.previous();
                    }
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(FerroDimensions.space16),
                  decoration: BoxDecoration(
                    color: FerroColors.surface,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: FerroColors.divider, width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: currentSong.accentColor.withValues(alpha: 0.15),
                        blurRadius: 24.0,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Artwork (80dp)
                          Container(
                            width: 80.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14.0),
                              border: Border.all(color: FerroColors.primary, width: 1.5),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: const ArtworkPlaceholder(
                                size: 80.0,
                                iconSize: 36.0,
                              ),
                            ),
                          ),
                          const SizedBox(width: FerroDimensions.space16),

                          // Title, Artist, and Format
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentSong.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: FerroTypography.headline.copyWith(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  currentSong.artist,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: FerroTypography.title.copyWith(
                                    fontSize: 16.0,
                                    color: FerroColors.onSurfaceMuted,
                                  ),
                                ),
                                const SizedBox(height: 6.0),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                                  decoration: BoxDecoration(
                                    color: FerroColors.surfaceHigh,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Text(
                                    '${currentSong.format} • ${currentSong.quality}',
                                    style: FerroTypography.captionBold.copyWith(
                                      color: FerroColors.primaryLight,
                                      fontSize: 11.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Giant Heart Toggle Button
                          IconButton(
                            iconSize: 36.0,
                            icon: Icon(
                              currentSong.isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: currentSong.isFavorite ? FerroColors.error : FerroColors.onSurfaceMuted,
                            ),
                            onPressed: _player.toggleFavorite,
                          ),
                        ],
                      ),
                      const SizedBox(height: FerroDimensions.space12),

                      // Glanceable "Up Next" Ticker (Tap to skip to it directly)
                      InkWell(
                        onTap: () => _player.play(nextSong),
                        borderRadius: BorderRadius.circular(8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                          decoration: BoxDecoration(
                            color: FerroColors.surfaceHigh,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.skip_next_rounded, color: FerroColors.primaryLight, size: 18.0),
                              const SizedBox(width: 6.0),
                              Text(
                                'BERIKUTNYA: ',
                                style: FerroTypography.captionBold.copyWith(color: FerroColors.primaryLight, fontSize: 10.5),
                              ),
                              Expanded(
                                child: Text(
                                  '${nextSong.title} — ${nextSong.artist}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: FerroTypography.caption.copyWith(color: Colors.white70, fontSize: 11.5),
                                ),
                              ),
                              const Icon(Icons.touch_app_rounded, color: Colors.white54, size: 14.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // 4. Giant Driver Playback Controls (Prev, -15s, Play/Pause 88dp, +15s, Next)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Previous Track (64dp)
                  _buildControlCircle(
                    size: 64.0,
                    icon: Icons.skip_previous_rounded,
                    iconSize: 36.0,
                    onTap: _player.previous,
                  ),

                  // Jump Backward 15s (52dp)
                  _buildControlCircle(
                    size: 52.0,
                    icon: Icons.replay_10_rounded,
                    iconSize: 28.0,
                    color: FerroColors.surface,
                    onTap: () => _jumpSeconds(-15),
                  ),

                  // Giant Play / Pause Button (88dp)
                  GestureDetector(
                    onTap: _player.togglePlayPause,
                    child: Container(
                      width: 88.0,
                      height: 88.0,
                      decoration: BoxDecoration(
                        gradient: FerroColors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: FerroColors.primary.withValues(alpha: 0.5),
                            blurRadius: 28.0,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          _player.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          size: 52.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // Jump Forward 15s (52dp)
                  _buildControlCircle(
                    size: 52.0,
                    icon: Icons.forward_10_rounded,
                    iconSize: 28.0,
                    color: FerroColors.surface,
                    onTap: () => _jumpSeconds(15),
                  ),

                  // Next Track (64dp)
                  _buildControlCircle(
                    size: 64.0,
                    icon: Icons.skip_next_rounded,
                    iconSize: 36.0,
                    onTap: _player.next,
                  ),
                ],
              ),

              const Spacer(flex: 1),

              // 5. In-Car Giant Volume Stepper Row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: FerroColors.surface,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: FerroColors.divider),
                ),
                child: Row(
                  children: [
                    // Mute / Unmute
                    IconButton(
                      icon: Icon(
                        volumePercent == 0 ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                        color: volumePercent == 0 ? FerroColors.error : FerroColors.primaryLight,
                        size: 26.0,
                      ),
                      onPressed: () {
                        if (_player.volume > 0) {
                          _player.setVolume(0.0);
                        } else {
                          _player.setVolume(0.7);
                        }
                      },
                    ),
                    const SizedBox(width: FerroDimensions.space8),

                    // Vol - Button (Giant touch target)
                    InkWell(
                      onTap: () => _adjustVolume(-0.1),
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: FerroColors.surfaceHigh,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Text('VOL −', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: FerroDimensions.space12),

                    // Volume Percentage Indicator
                    Expanded(
                      child: Center(
                        child: Text(
                          '$volumePercent%',
                          style: FerroTypography.monoTimer.copyWith(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: FerroDimensions.space12),

                    // Vol + Button (Giant touch target)
                    InkWell(
                      onTap: () => _adjustVolume(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: FerroColors.surfaceHigh,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Text('VOL ＋', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: FerroDimensions.space12),

              // 6. Bottom Safety Utilities (Shuffle Toggle & Queue Switcher)
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _player.toggleShuffle,
                      child: Container(
                        height: 52.0,
                        decoration: BoxDecoration(
                          color: _player.isShuffle ? FerroColors.primary.withValues(alpha: 0.2) : FerroColors.surface,
                          borderRadius: BorderRadius.circular(14.0),
                          border: Border.all(
                            color: _player.isShuffle ? FerroColors.primary : FerroColors.divider,
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shuffle_rounded,
                              color: _player.isShuffle ? FerroColors.primary : Colors.white,
                              size: 24.0,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              _player.isShuffle ? 'Acak Aktif' : 'Acak Lagu',
                              style: FerroTypography.captionBold.copyWith(
                                color: _player.isShuffle ? FerroColors.primary : Colors.white,
                                fontSize: 13.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: FerroDimensions.space12),
                  Expanded(
                    child: GestureDetector(
                      onTap: _openDriverSongPicker,
                      child: Container(
                        height: 52.0,
                        decoration: BoxDecoration(
                          color: FerroColors.surface,
                          borderRadius: BorderRadius.circular(14.0),
                          border: Border.all(color: FerroColors.divider, width: 1.2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.list_rounded, color: FerroColors.primaryLight, size: 24.0),
                            const SizedBox(width: 8.0),
                            Text(
                              'Daftar Antrian',
                              style: FerroTypography.captionBold.copyWith(color: Colors.white, fontSize: 13.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlCircle({
    required double size,
    required IconData icon,
    required double iconSize,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color ?? FerroColors.surfaceHigh,
          shape: BoxShape.circle,
          border: Border.all(color: FerroColors.divider, width: 1.2),
        ),
        child: Center(
          child: Icon(icon, size: iconSize, color: Colors.white),
        ),
      ),
    );
  }
}
