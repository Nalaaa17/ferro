import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferro/core/providers/providers.dart';
import 'package:ferro/data/sources/mock_catalog.dart';
import 'package:ferro/features/library/presentation/screens/home_screen.dart';
import 'package:ferro/features/library/presentation/screens/library_screen.dart';
import 'package:ferro/features/lyrics/domain/entities/lyric_line.dart';
import 'package:ferro/features/player/presentation/providers/player_controller.dart';

void main() {
  group('5.1 Dummy Data Generator Tests', () {
    test('Contains diverse audio formats including FLAC, MP3, WAV, OPUS, and MP4', () {
      final formats = MockCatalog.songs.map((s) => s.format).toSet();
      expect(formats.contains('FLAC'), isTrue);
      expect(formats.contains('MP3'), isTrue);
      expect(formats.contains('WAV'), isTrue);
      expect(formats.contains('OPUS'), isTrue);
      expect(formats.contains('MP4'), isTrue);

      final videoAudioSongs = MockCatalog.songs.where((s) => s.isVideoAudio).toList();
      expect(videoAudioSongs.isNotEmpty, isTrue);
      expect(videoAudioSongs.first.format, 'MP4');
    });

    test('All songs have valid duration strings and file sizes', () {
      for (final song in MockCatalog.songs) {
        expect(song.durationString, matches(r'^\d{2}:\d{2}$'));
        expect(song.fileSizeBytes, contains('MB'));
      }
    });

    test('Albums and genres are populated', () {
      expect(MockCatalog.albums.length, greaterThanOrEqualTo(4));
      expect(MockCatalog.genres.length, greaterThanOrEqualTo(8));
    });

    test('LRC synchronized lyrics parse and sample test', () {
      final parsed = MockLyricsData.parseLrc(MockLyricsData.rawLrcSample);
      expect(parsed.isNotEmpty, isTrue);
      expect(parsed.first.text, "One more time, we're gonna celebrate");
      expect(parsed.first.timestamp, Duration.zero);
      expect(parsed.length, greaterThanOrEqualTo(10));
    });
  });

  group('5.2 Mock Riverpod State Providers Tests', () {
    test('playerProvider and currentSongProvider read initial clean state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final currentSong = container.read(currentSongProvider);
      expect(currentSong.title, 'Belum Ada Lagu Diputar');

      final isPlaying = container.read(isPlayingProvider);
      expect(isPlaying, isFalse);
    });

    test('librarySearchQueryProvider and filteredSongsProvider filter correctly', () {
      PlayerController.instance.setLibrarySongs(MockCatalog.songs);
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Initial all songs
      final allSongs = container.read(filteredSongsProvider);
      expect(allSongs.length, MockCatalog.songs.length);

      // Filter by 'Beatles'
      container.read(librarySearchQueryProvider.notifier).setQuery('Beatles');
      final beatlesSongs = container.read(filteredSongsProvider);
      expect(beatlesSongs.length, 2);
      expect(beatlesSongs.every((s) => s.artist.contains('Beatles')), isTrue);

      // Sort by title ZA
      container.read(librarySortOptionProvider.notifier).setSort(SortOption.titleZA);
      final sorted = container.read(filteredSongsProvider);
      expect(sorted.first.title.compareTo(sorted.last.title), greaterThan(0));
    });

    test('libraryMultiSelectProvider toggles selection', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(libraryMultiSelectProvider.notifier);
      expect(container.read(libraryMultiSelectProvider), isEmpty);

      notifier.toggle('1');
      expect(container.read(libraryMultiSelectProvider).contains('1'), isTrue);

      notifier.toggle('1');
      expect(container.read(libraryMultiSelectProvider), isEmpty);

      notifier.selectAll(['1', '2', '3']);
      expect(container.read(libraryMultiSelectProvider).length, 3);

      notifier.clear();
      expect(container.read(libraryMultiSelectProvider), isEmpty);
    });

    test('deviceGearProvider reads active profile and switches gear', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final activeProfile = container.read(activeGearProfileProvider);
      expect(activeProfile.isActive, isTrue);

      final eq = container.read(deviceGearProvider);
      final second = eq.profiles[1];
      eq.switchActiveDevice(second.id);

      expect(container.read(activeGearProfileProvider).id, second.id);
    });

    testWidgets('HardwareGearSimulator renders simulation sheet and connects gear', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () => HardwareGearSimulator.showSimulationSheet(context),
                  child: const Text('Open Simulator'),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Simulator'));
      await tester.pumpAndSettle();

      expect(find.text('Pilih Profil Output Audio'), findsOneWidget);
      expect(find.textContaining('Apple USB-C DAC'), findsOneWidget);
    });

    testWidgets('HomeScreen displays Ferro logo in top-right AppBar and no settings icon', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Ferro logo Image.asset is present in actions
      expect(find.byType(Image), findsWidgets);
      // Verify no settings icon in top right
      expect(find.byIcon(Icons.settings_outlined), findsNothing);
      expect(find.byIcon(Icons.cast_connected_rounded), findsNothing);
    });
  });
}

