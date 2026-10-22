import 'package:flutter/material.dart';
import 'package:ferro/app/theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FerroApp());
}

class FerroApp extends StatelessWidget {
  const FerroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FERRO',
      debugShowCheckedModeBanner: false,
      theme: FerroTheme.darkTheme,
      darkTheme: FerroTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const ThemeShowcaseScreen(),
    );
  }
}

class ThemeShowcaseScreen extends StatelessWidget {
  const ThemeShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FERRO Design System', style: FerroTypography.headline),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(FerroDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Brand Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(FerroDimensions.space20),
              decoration: const BoxDecoration(
                gradient: FerroColors.primaryGradient,
                borderRadius: FerroDimensions.radiusCardAll,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FERRO',
                    style: FerroTypography.display.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: FerroDimensions.space4),
                  Text(
                    'Semua format, satu player — EQ yang hafal perangkatmu.',
                    style: FerroTypography.body.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: FerroDimensions.space24),

            // Typography Showcase
            Text('Tipografi (Plus Jakarta Sans)', style: FerroTypography.headline),
            const SizedBox(height: FerroDimensions.space12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(FerroDimensions.space16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Display 28sp Bold', style: FerroTypography.display),
                    const SizedBox(height: FerroDimensions.space8),
                    Text('Headline 20sp SemiBold', style: FerroTypography.headline),
                    const SizedBox(height: FerroDimensions.space8),
                    Text('Title 16sp SemiBold', style: FerroTypography.title),
                    const SizedBox(height: FerroDimensions.space8),
                    Text('Body 14sp Regular - Tagline & Deskripsi Lagu', style: FerroTypography.body),
                    const SizedBox(height: FerroDimensions.space8),
                    Text('Caption 12sp Regular - 320kbps • 44.1kHz • FLAC', style: FerroTypography.caption),
                    const SizedBox(height: FerroDimensions.space8),
                    Text('02:45 / 04:12 (Mono Timer)', style: FerroTypography.monoTimer),
                  ],
                ),
              ),
            ),
            const SizedBox(height: FerroDimensions.space24),

            // Colors Showcase
            Text('Palet Warna', style: FerroTypography.headline),
            const SizedBox(height: FerroDimensions.space12),
            Row(
              children: [
                _colorSwatch('Primary', FerroColors.primary),
                const SizedBox(width: FerroDimensions.space8),
                _colorSwatch('Surface', FerroColors.surface),
                const SizedBox(width: FerroDimensions.space8),
                _colorSwatch('High', FerroColors.surfaceHigh),
                const SizedBox(width: FerroDimensions.space8),
                _colorSwatch('Success', FerroColors.success),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorSwatch(String name, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: FerroDimensions.space16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: FerroDimensions.radiusArtworkAll,
          border: Border.all(color: FerroColors.divider, width: 1.0),
        ),
        child: Center(
          child: Text(
            name,
            style: FerroTypography.captionBold.copyWith(
              color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
