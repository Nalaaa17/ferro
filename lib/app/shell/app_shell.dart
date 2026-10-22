import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/widgets.dart';
import 'package:ferro/features/player/presentation/providers/player_controller.dart';
import 'package:ferro/features/player/presentation/screens/now_playing_screen.dart';

/// AppShell widget providing persistent MiniPlayer floating above BottomNavigationBar per PRD §4.4.
class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
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

  void _onTabSelected(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  void _openNowPlaying() {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) => const NowPlayingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;
          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(position: animation.drive(tween), child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = _player.currentSong;
    final progress = _player.duration.inMilliseconds > 0
        ? _player.position.inMilliseconds / _player.duration.inMilliseconds
        : 0.0;

    return Scaffold(
      backgroundColor: FerroColors.background,
      body: widget.navigationShell,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Persistent Mini Player (64dp height)
            MiniPlayer(
              title: currentSong.title,
              artist: '${currentSong.artist} • ${currentSong.format}',
              isPlaying: _player.isPlaying,
              progress: progress,
              onTap: _openNowPlaying,
              onPlayPauseTap: _player.togglePlayPause,
              onNextTap: _player.next,
            ),

            // Bottom Navigation Bar (72dp height)
            Container(
              height: FerroDimensions.bottomNavHeight,
              decoration: const BoxDecoration(
                color: FerroColors.surface,
                border: FerroDimensions.sideBorderTop,
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: BottomNavigationBar(
                  currentIndex: widget.navigationShell.currentIndex,
                  onTap: _onTabSelected,
                  backgroundColor: FerroColors.surface,
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: FerroColors.primary,
                  unselectedItemColor: FerroColors.onSurfaceMuted,
                  selectedFontSize: 12.0,
                  unselectedFontSize: 12.0,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      activeIcon: Icon(Icons.home_rounded),
                      label: 'Beranda',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.library_music_outlined),
                      activeIcon: Icon(Icons.library_music_rounded),
                      label: 'Pustaka',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.search_rounded),
                      activeIcon: Icon(Icons.search_rounded),
                      label: 'Cari',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings_outlined),
                      activeIcon: Icon(Icons.settings_rounded),
                      label: 'Pengaturan',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
