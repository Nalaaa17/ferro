import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/data/sources/mock_catalog.dart';
import 'package:ferro/features/library/presentation/screens/album_detail_screen.dart';
import 'package:ferro/features/library/presentation/screens/artist_detail_screen.dart';
import 'package:ferro/features/library/presentation/screens/folder_browser_screen.dart';
import 'package:ferro/features/library/presentation/screens/playlist_detail_screen.dart';
import 'package:ferro/features/settings/presentation/screens/settings_screen.dart';

void main() {
  group('PlaylistDetailScreen Tests', () {
    testWidgets('Renders playlist header, 2x2 collage, and songs', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(
        const MaterialApp(
          home: PlaylistDetailScreen(
            playlistTitle: 'Lagu Favorit',
            description: 'Koleksi audio pilihan offline',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Lagu Favorit'), findsWidgets);
      expect(find.text('Putar Semua'), findsOneWidget);
      expect(find.text('Acak'), findsOneWidget);
      expect(find.byType(SliverReorderableList), findsOneWidget);
    });
  });

  group('AlbumDetailScreen Tests', () {
    testWidgets('Renders album hero portrait and numbered tracks', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      final album = MockCatalog.albums.first;
      await tester.pumpWidget(
        MaterialApp(
          home: AlbumDetailScreen(album: album),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(album.title), findsWidgets);
      expect(find.text(album.artist), findsOneWidget);
      expect(find.text('Putar Semua'), findsOneWidget);
    });
  });

  group('ArtistDetailScreen Tests', () {
    testWidgets('Renders artist hero portrait, discography, and popular songs', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(
        const MaterialApp(
          home: ArtistDetailScreen(artistName: 'Daft Punk'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Daft Punk'), findsWidgets);
      expect(find.text('Diskografi Album'), findsOneWidget);
      expect(find.text('Lagu Populer & Sering Diputar'), findsOneWidget);
    });
  });

  group('FolderBrowserScreen Tests', () {
    testWidgets('Renders breadcrumbs navigation and folder items', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(
        const MaterialApp(
          home: FolderBrowserScreen(
            initialPath: 'Penyimpanan Internal/Music/Hi-Res',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Hi-Res'), findsWidgets);
      expect(find.text('Putar Folder Ini'), findsOneWidget);
      expect(find.text('Tambah Antrian'), findsOneWidget);
    });
  });

  group('SettingsScreen Tests', () {
    testWidgets('Renders grouped insets, crossfade, and GitHub update dialog', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(
        MaterialApp(
          theme: FerroTheme.darkTheme,
          home: const SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Pengaturan'), findsOneWidget);
      expect(find.text('AUDIO & DSP'), findsOneWidget);
      expect(find.text('PUSTAKA & FILE MEDIA'), findsOneWidget);
      expect(find.text('TAMPILAN & ANTARMUKA'), findsOneWidget);
      expect(find.text('TENTANG & PEMBARUAN'), findsOneWidget);

      // Tap GitHub Update check
      await tester.tap(find.text('Periksa Pembaruan Aplikasi'));
      await tester.pumpAndSettle();

      expect(find.text('Pembaruan Tersedia!'), findsOneWidget);
      expect(find.text('Unduh APK (GitHub)'), findsOneWidget);
    });
  });
}
