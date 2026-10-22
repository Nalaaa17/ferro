import 'package:flutter/material.dart';
import 'package:ferro/app/router.dart';
import 'package:ferro/app/theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FerroApp());
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
