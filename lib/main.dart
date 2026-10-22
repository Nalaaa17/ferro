import 'package:flutter/material.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/widgets.dart';

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
      home: const ComponentShowcaseScreen(),
    );
  }
}

class ComponentShowcaseScreen extends StatefulWidget {
  const ComponentShowcaseScreen({super.key});

  @override
  State<ComponentShowcaseScreen> createState() => _ComponentShowcaseScreenState();
}

class _ComponentShowcaseScreenState extends State<ComponentShowcaseScreen> {
  int _selectedChipIndex = 0;
  Duration _currentPosition = const Duration(minutes: 1, seconds: 24);
  final Duration _totalDuration = const Duration(minutes: 3, seconds: 56);
  final Duration _bufferedPosition = const Duration(minutes: 2, seconds: 15);

  final List<String> _chipLabels = ['Semua', 'FLAC', 'Hi-Res', 'Playlist', 'Folder'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FERRO Component Kit', style: FerroTypography.headline),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: FerroDimensions.space16,
          vertical: FerroDimensions.space20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Brand Header
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
                    'FERRO UI KIT',
                    style: FerroTypography.display.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: FerroDimensions.space4),
                  Text(
                    'Reusable Component Showcase — PRD §3.5',
                    style: FerroTypography.body.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: FerroDimensions.space24),

            // 2. FerroButton Variants
            Text('1. FerroButton (Pill 48dp)', style: FerroTypography.headline),
            const SizedBox(height: FerroDimensions.space12),
            Wrap(
              spacing: FerroDimensions.space12,
              runSpacing: FerroDimensions.space12,
              children: [
                FerroButton(
                  label: 'Putar Sekarang',
                  icon: Icons.play_arrow_rounded,
                  onPressed: () {},
                  variant: FerroButtonVariant.filled,
                ),
                FerroButton(
                  label: 'Antrian',
                  icon: Icons.queue_music_rounded,
                  onPressed: () {},
                  variant: FerroButtonVariant.outline,
                ),
                FerroButton(
                  label: 'Lihat Semua',
                  onPressed: () {},
                  variant: FerroButtonVariant.text,
                ),
                const FerroButton(
                  label: 'Memuat...',
                  isLoading: true,
                  onPressed: null,
                ),
              ],
            ),
            const SizedBox(height: FerroDimensions.space28),

            // 3. Filter Chips
            Text('2. FerroChip (Pill Filter)', style: FerroTypography.headline),
            const SizedBox(height: FerroDimensions.space12),
            Wrap(
              spacing: FerroDimensions.space8,
              runSpacing: FerroDimensions.space8,
              children: List.generate(_chipLabels.length, (index) {
                return FerroChip(
                  label: _chipLabels[index],
                  isSelected: _selectedChipIndex == index,
                  onTap: () => setState(() => _selectedChipIndex = index),
                );
              }),
            ),
            const SizedBox(height: FerroDimensions.space28),

            // 4. SeekBar (Gradient 3dp & Tabular Figures)
            Text('3. FerroSeekBar (3dp Gradient & Scrubbing)', style: FerroTypography.headline),
            const SizedBox(height: FerroDimensions.space12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(FerroDimensions.space16),
                child: FerroSeekBar(
                  position: _currentPosition,
                  duration: _totalDuration,
                  bufferedPosition: _bufferedPosition,
                  onChanged: (pos) => setState(() => _currentPosition = pos),
                  onChangeEnd: (pos) => setState(() => _currentPosition = pos),
                ),
              ),
            ),
            const SizedBox(height: FerroDimensions.space28),

            // 5. AlbumCard (1:1 Ratio 160dp with Hover Overlay)
            Text('4. AlbumCard (160dp 1:1 with Hover Play)', style: FerroTypography.headline),
            const SizedBox(height: FerroDimensions.space12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  AlbumCard(
                    title: 'Discovery (Daft Punk)',
                    subtitle: '2001 • 14 Lagu',
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
                    title: 'Abbey Road (Remastered)',
                    subtitle: 'The Beatles',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: FerroDimensions.space28),

            // 6. SongTile (64dp Height with Artwork & Controls)
            Text('5. SongTile (64dp Height & Active Playing State)', style: FerroTypography.headline),
            const SizedBox(height: FerroDimensions.space12),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: FerroDimensions.space4),
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
                      title: 'Harder, Better, Faster, Stronger',
                      artist: 'Daft Punk • Discovery',
                      durationText: '03:44',
                      onTap: () {},
                      onMoreTap: () {},
                    ),
                    const Divider(height: 1, indent: 72),
                    SongTile(
                      title: 'Something About Us',
                      artist: 'Daft Punk • Discovery',
                      durationText: '03:51',
                      onTap: () {},
                      onMoreTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: FerroDimensions.space28),

            // 7. EmptyState
            Text('6. EmptyState (Status Kosong & CTA)', style: FerroTypography.headline),
            const SizedBox(height: FerroDimensions.space12),
            Card(
              child: EmptyState(
                title: 'Pustaka Musik Kosong',
                description: 'Belum ada file musik yang ditemukan di perangkat Anda. Pindai folder sekarang.',
                actionLabel: 'Pindai Musik Sekarang',
                actionIcon: Icons.folder_open_rounded,
                onActionPressed: () {},
              ),
            ),
            const SizedBox(height: FerroDimensions.space32),
          ],
        ),
      ),
    );
  }
}
