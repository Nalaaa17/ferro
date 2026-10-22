import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ferro/app/shell/app_shell.dart';
import 'package:ferro/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:ferro/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:ferro/features/onboarding/presentation/screens/permission_screen.dart';
import 'package:ferro/features/car_mode/presentation/screens/car_mode_screen.dart';
import 'package:ferro/features/library/presentation/screens/home_screen.dart';
import 'package:ferro/features/library/presentation/screens/library_screen.dart';
import 'package:ferro/features/library/presentation/screens/search_screen.dart';
import 'package:ferro/features/lyrics/presentation/screens/lyrics_screen.dart';
import 'package:ferro/features/player/presentation/screens/now_playing_screen.dart';
import 'package:ferro/features/settings/presentation/screens/settings_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    // 1. Entry Flow: Splash Screen
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),

    // 2. Entry Flow: Onboarding Screen
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    // 3. Entry Flow: Permission Screen
    GoRoute(
      path: '/permission',
      builder: (context, state) => const PermissionScreen(),
    ),

    // 4. Immersive Fullscreen Now Playing Screen
    GoRoute(
      path: '/now-playing',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const NowPlayingScreen(),
    ),

    // 5. Synced Lyrics Screen
    GoRoute(
      path: '/lyrics',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LyricsScreen(),
    ),

    // 6. Car Mode Screen (Safety-first)
    GoRoute(
      path: '/car-mode',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CarModeScreen(),
    ),

    // 7. Main App Navigation Shell (StatefulIndexedStack)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        // Tab 0: Beranda
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),

        // Tab 1: Pustaka
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/library',
              builder: (context, state) => const LibraryScreen(),
            ),
          ],
        ),

        // Tab 2: Cari
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchScreen(),
            ),
          ],
        ),

        // Tab 3: Pengaturan
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
