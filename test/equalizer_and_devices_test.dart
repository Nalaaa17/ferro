import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/features/devices/presentation/screens/devices_screen.dart';
import 'package:ferro/features/equalizer/presentation/providers/equalizer_controller.dart';
import 'package:ferro/features/equalizer/presentation/screens/equalizer_screen.dart';

void main() {
  group('EqualizerController Tests', () {
    final eq = EqualizerController.instance;

    test('Initial controller state loads active profile', () {
      expect(eq.isEnabled, isTrue);
      expect(eq.profiles.isNotEmpty, isTrue);
      expect(eq.activeProfile.isActive, isTrue);
      expect(eq.bandGains.length, 10);
    });

    test('Selecting preset updates band gains', () {
      eq.selectPreset('Rock');
      expect(eq.selectedPreset, 'Rock');
      expect(eq.bandGains, EqualizerController.presets['Rock']);
    });

    test('Modifying single band sets preset to Custom', () {
      eq.setBandGain(0, 5.0);
      expect(eq.selectedPreset, 'Custom');
      expect(eq.bandGains[0], 5.0);
    });

    test('Bass boost and virtualizer clamp properly', () {
      eq.setBassBoost(150.0);
      expect(eq.bassBoost, 100.0);
      eq.setBassBoost(-10.0);
      expect(eq.bassBoost, 0.0);

      eq.setVirtualizer(50.0);
      expect(eq.virtualizer, 50.0);
    });

    test('Switching active profile updates active profile', () {
      final secondProfile = eq.profiles[1];
      eq.switchActiveDevice(secondProfile.id);
      expect(eq.activeProfile.id, secondProfile.id);
    });
  });

  group('EqualizerScreen Widget Tests', () {
    testWidgets('Renders EqualizerScreen with 10 bands and presets', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(
        MaterialApp(
          theme: FerroTheme.darkTheme,
          home: const EqualizerScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Equalizer'), findsOneWidget);
      expect(find.text('Preset Frekuensi'), findsOneWidget);
      expect(find.text('Rock'), findsOneWidget);
      expect(find.text('Pop'), findsOneWidget);
      expect(find.text('31Hz'), findsOneWidget);
      expect(find.text('16kHz'), findsOneWidget);
      expect(find.text('Efek Suara Tambahan'), findsOneWidget);
      expect(find.textContaining('Simpan ke Profil Perangkat Aktif'), findsOneWidget);
    });
  });

  group('DevicesScreen Widget Tests', () {
    testWidgets('Renders DevicesScreen with education banner and profile list', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(
        MaterialApp(
          theme: FerroTheme.darkTheme,
          home: const DevicesScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Perangkat Saya'), findsOneWidget);
      expect(find.text('Deteksi Perangkat Cerdas (Per-Gear)'), findsOneWidget);
      expect(find.text('Tambah Profil'), findsOneWidget);
      expect(find.text('AKTIF'), findsWidgets);
    });
  });
}
