import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferro/app/router.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/features/player/presentation/providers/player_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PlayerController.enableTicker = true;
  PlayerController.instance.startTicker();
  runApp(const ProviderScope(child: FerroApp()));
}

class FerroApp extends StatelessWidget {
  const FerroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FERRO',
      debugShowCheckedModeBanner: false,
      theme: FerroTheme.darkTheme,
      darkTheme: FerroTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: appRouter,
    );
  }
}
