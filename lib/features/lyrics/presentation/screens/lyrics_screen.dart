import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/widgets.dart';
import 'package:ferro/features/lyrics/domain/entities/lyric_line.dart';
import 'package:ferro/features/player/presentation/providers/player_controller.dart';

import 'package:ferro/core/services/lyrics/lrc_auto_pairer.dart';

/// Fullscreen synchronized lyrics screen with auto-scroll and karaoke mode per PRD §4.10.
class LyricsScreen extends StatefulWidget {
  const LyricsScreen({super.key});

  @override
  State<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen> {
  final PlayerController _player = PlayerController.instance;
  final ScrollController _scrollController = ScrollController();

  bool _isKaraokeMode = false;
  bool _hasLyrics = false;
  List<LyricLine> _lyrics = [];
  String? _loadedSongId;
  bool _isUserScrolling = false;
  Timer? _resumeAutoScrollTimer;

  int _currentLineIndex = 0;

  @override
  void initState() {
    super.initState();
    _player.addListener(_onPlayerStateChanged);
    _checkAndLoadLyrics();
  }

  @override
  void dispose() {
    _resumeAutoScrollTimer?.cancel();
    _player.removeListener(_onPlayerStateChanged);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _checkAndLoadLyrics() async {
    final currentSong = _player.currentSong;
    if (currentSong.isEmpty) {
      if (mounted) setState(() { _lyrics = []; _hasLyrics = false; });
      return;
    }

    _loadedSongId = currentSong.id;

    if (currentSong.lrcPath != null) {
      final lines = await LrcAutoPairer().readLrcFile(currentSong.lrcPath!);
      if (lines.isNotEmpty && mounted) {
        setState(() {
          _lyrics = lines;
          _hasLyrics = true;
        });
        return;
      }
    }

    if (currentSong.filePath != null) {
      final lrcPath = await LrcAutoPairer().findMatchingLrc(currentSong.filePath!);
      if (lrcPath != null) {
        final lines = await LrcAutoPairer().readLrcFile(lrcPath);
        if (lines.isNotEmpty && mounted) {
          setState(() {
            _lyrics = lines;
            _hasLyrics = true;
          });
          return;
        }
      }
    }

    if (mounted) {
      setState(() {
        _lyrics = [];
        _hasLyrics = false;
      });
    }
  }

  void _onPlayerStateChanged() {
    final currentSong = _player.currentSong;
    if (_loadedSongId != currentSong.id) {
      _checkAndLoadLyrics();
    }

    final currentPos = _player.position;
    final lyrics = _lyrics;

    var newIndex = 0;
    for (var i = 0; i < lyrics.length; i++) {
      if (currentPos >= lyrics[i].timestamp) {
        newIndex = i;
      } else {
        break;
      }
    }

    if (newIndex != _currentLineIndex) {
      setState(() => _currentLineIndex = newIndex);
      if (!_isUserScrolling && _hasLyrics) {
        _scrollToActiveLine();
      }
    }
  }

  void _scrollToActiveLine() {
    if (!_scrollController.hasClients) return;
    const itemHeight = 68.0;
    final screenCenter = MediaQuery.of(context).size.height * 0.38;
    final targetOffset = (_currentLineIndex * itemHeight) - screenCenter;

    _scrollController.animateTo(
      targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  void _onUserScrollStart() {
    _isUserScrolling = true;
    _resumeAutoScrollTimer?.cancel();
    // Auto-resume auto-scroll after 5 seconds idle per PRD §4.10
    _resumeAutoScrollTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() => _isUserScrolling = false);
        _scrollToActiveLine();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = _player.currentSong;
    final lyrics = _lyrics;

    return Scaffold(
      backgroundColor: FerroColors.background,
      body: Stack(
        children: [
          // 1. Dynamic Blurred Background with 80% Dark Overlay per PRD §4.10
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.0, -0.4),
                radius: 1.2,
                colors: [
                  currentSong.accentColor.withValues(alpha: 0.35),
                  FerroColors.background,
                ],
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
            child: Container(
              color: Colors.black.withValues(alpha: 0.80), // 80% dark overlay
            ),
          ),

          // 2. Lyrics Content Surface
          SafeArea(
            child: Column(
              children: [
                // Top Action Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: FerroDimensions.space16,
                    vertical: FerroDimensions.space8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 28.0),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      // Song Title Info
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              currentSong.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: FerroTypography.title.copyWith(fontSize: 15.0),
                            ),
                            Text(
                              currentSong.artist,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: FerroTypography.caption,
                            ),
                          ],
                        ),
                      ),
                      // Karaoke Mode Toggle Chip
                      FerroChip(
                        label: 'Karaoke',
                        icon: Icons.mic_rounded,
                        isSelected: _isKaraokeMode,
                        onTap: () => setState(() => _isKaraokeMode = !_isKaraokeMode),
                      ),
                    ],
                  ),
                ),

                // Lyrics List or Fallback Empty State
                Expanded(
                  child: _hasLyrics
                      ? NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            if (notification is ScrollStartNotification) {
                              _onUserScrollStart();
                            }
                            return false;
                          },
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(
                              horizontal: FerroDimensions.space24,
                              vertical: 120.0,
                            ),
                            itemCount: lyrics.length,
                            itemBuilder: (context, index) {
                              final line = lyrics[index];
                              final isActive = index == _currentLineIndex;

                              return GestureDetector(
                                onTap: () => _player.seek(line.timestamp),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                                  color: Colors.transparent,
                                  child: _isKaraokeMode && isActive
                                      ? _buildKaraokeLine(line)
                                      : _buildStandardLine(line, isActive),
                                ),
                              );
                            },
                          ),
                        )
                      : _buildNoLyricsFallback(),
                ),

                // Bottom Floating Control Bar (Seekbar & Controls Preview)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: FerroDimensions.space20,
                    vertical: FerroDimensions.space12,
                  ),
                  decoration: const BoxDecoration(
                    color: FerroColors.surface,
                    border: FerroDimensions.sideBorderTop,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FerroSeekBar(
                        position: _player.position,
                        duration: _player.duration,
                        onChanged: _player.seek,
                        onChangeEnd: _player.seek,
                      ),
                      const SizedBox(height: FerroDimensions.space8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.skip_previous_rounded, size: 28.0),
                            onPressed: _player.previous,
                          ),
                          const SizedBox(width: FerroDimensions.space16),
                          GestureDetector(
                            onTap: _player.togglePlayPause,
                            child: Container(
                              width: 48.0,
                              height: 48.0,
                              decoration: const BoxDecoration(
                                gradient: FerroColors.primaryGradient,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _player.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 28.0,
                              ),
                            ),
                          ),
                          const SizedBox(width: FerroDimensions.space16),
                          IconButton(
                            icon: const Icon(Icons.skip_next_rounded, size: 28.0),
                            onPressed: _player.next,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStandardLine(LyricLine line, bool isActive) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      style: isActive
          ? FerroTypography.display.copyWith(
              fontSize: 22.0,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.35,
            )
          : FerroTypography.headline.copyWith(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              color: FerroColors.onSurface.withValues(alpha: 0.35), // 40% muted
              height: 1.35,
            ),
      child: Text(line.text),
    );
  }

  Widget _buildKaraokeLine(LyricLine line) {
    if (line.words.isEmpty) {
      return _buildStandardLine(line, true);
    }

    final currentPos = _player.position;

    return Wrap(
      spacing: 4.0,
      runSpacing: 4.0,
      children: line.words.map((word) {
        final isWordActive = currentPos >= word.timestamp;

        return ShaderMask(
          shaderCallback: (bounds) {
            return isWordActive
                ? FerroColors.primaryGradient.createShader(bounds)
                : const LinearGradient(colors: [Colors.white, Colors.white]).createShader(bounds);
          },
          child: Text(
            word.text,
            style: FerroTypography.display.copyWith(
              fontSize: 22.0,
              fontWeight: FontWeight.w800,
              color: isWordActive ? Colors.white : Colors.white.withValues(alpha: 0.5),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNoLyricsFallback() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(FerroDimensions.space24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                color: FerroColors.surfaceHigh,
                shape: BoxShape.circle,
                border: Border.all(color: FerroColors.divider, width: 1.2),
              ),
              child: const Center(
                child: Icon(Icons.lyrics_outlined, size: 40.0, color: FerroColors.primary),
              ),
            ),
            const SizedBox(height: FerroDimensions.space20),
            Text('Lirik Tidak Tersedia', style: FerroTypography.headline),
            const SizedBox(height: FerroDimensions.space8),
            Text(
              'File .lrc untuk lagu ini belum ditemukan dalam folder yang sama.',
              textAlign: TextAlign.center,
              style: FerroTypography.body.copyWith(color: FerroColors.onSurfaceMuted),
            ),
            const SizedBox(height: FerroDimensions.space24),
            FerroButton(
              label: 'Muat File .lrc',
              icon: Icons.file_upload_outlined,
              variant: FerroButtonVariant.filled,
              onPressed: () {
                setState(() => _hasLyrics = true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('File .lrc berhasil dimuat!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
