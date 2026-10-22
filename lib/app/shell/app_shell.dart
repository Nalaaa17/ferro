import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/widgets.dart';

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
  bool _isPlaying = true;

  void _onTabSelected(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
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
              title: 'One More Time',
              artist: 'Daft Punk • Discovery',
              isPlaying: _isPlaying,
              progress: 0.42,
              onTap: () {
                // In Phase 3, this will open NowPlaying fullscreen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Now Playing Screen akan dibuka (Fase 3)'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              onPlayPauseTap: () {
                setState(() {
                  _isPlaying = !_isPlaying;
                });
              },
              onNextTap: () {},
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
