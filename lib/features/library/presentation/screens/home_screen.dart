import 'package:flutter/material.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FerroColors.background,
      appBar: AppBar(
        title: Text('Selamat Datang', style: FerroTypography.display.copyWith(fontSize: 22.0)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: FerroDimensions.space16,
          right: FerroDimensions.space16,
          top: FerroDimensions.space8,
          bottom: FerroDimensions.space32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Putar Lagi Cepat Header
            Text('Putar Lagi Cepat', style: FerroTypography.headline),
            const SizedBox(height: FerroDimensions.space12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  AlbumCard(
                    title: 'Discovery',
                    subtitle: 'Daft Punk',
                    onTap: () {},
                  ),
                  const SizedBox(width: FerroDimensions.space16),
                  AlbumCard(
                    title: 'Random Access Memories',
                    subtitle: 'FLAC 96kHz/24bit',
                    onTap: () {},
                  ),
                  const SizedBox(width: FerroDimensions.space16),
                  AlbumCard(
                    title: 'Abbey Road',
                    subtitle: 'The Beatles',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: FerroDimensions.space28),

            // Baru Ditambahkan
            Text('Baru Ditambahkan', style: FerroTypography.headline),
            const SizedBox(height: FerroDimensions.space12),
            Card(
              child: Column(
                children: [
                  SongTile(
                    title: 'One More Time',
                    artist: 'Daft Punk • Discovery',
                    durationText: '05:20',
                    isPlaying: true,
                    onTap: () {},
                    onMoreTap: () {},
                  ),
                  const Divider(height: 1, indent: 72),
                  SongTile(
                    title: 'Get Lucky',
                    artist: 'Daft Punk • RAM',
                    durationText: '04:08',
                    onTap: () {},
                    onMoreTap: () {},
                  ),
                  const Divider(height: 1, indent: 72),
                  SongTile(
                    title: 'Come Together',
                    artist: 'The Beatles • Abbey Road',
                    durationText: '04:19',
                    onTap: () {},
                    onMoreTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
