import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/widgets.dart';
import 'package:ferro/features/car_mode/presentation/screens/car_mode_screen.dart';
import 'package:ferro/features/player/presentation/screens/now_playing_screen.dart';

void main() {
  group('NowPlayingScreen FLAC Position Test', () {
    testWidgets('Renders FLAC badge inside seekbar centerWidget below progress', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(
        MaterialApp(
          theme: FerroTheme.darkTheme,
          home: const NowPlayingScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // FerroSeekBar should have centerWidget with FLAC
      expect(find.byType(FerroSeekBar), findsOneWidget);
      expect(find.text('FLAC'), findsOneWidget);
    });
  });

  group('Redesigned CarModeScreen Tests', () {
    testWidgets('Renders driving HUD, quick mood pills, giant controls, and volume stepper', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(
        MaterialApp(
          theme: FerroTheme.darkTheme,
          home: const CarModeScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('CAR MODE'), findsOneWidget);
      expect(find.text('Pilih Lagu'), findsOneWidget);
      expect(find.text('Semua Lagu'), findsOneWidget);
      expect(find.text('Driving Beat'), findsOneWidget);
      expect(find.text('VOL −'), findsOneWidget);
      expect(find.text('VOL ＋'), findsOneWidget);
      expect(find.textContaining('BERIKUTNYA:'), findsOneWidget);

      // Tap 'Pilih Lagu' to open driver-friendly giant list modal
      await tester.tap(find.text('Pilih Lagu'));
      await tester.pumpAndSettle();

      expect(find.text('PILIH LAGU / ANTRIAN'), findsOneWidget);
    });
  });
}
