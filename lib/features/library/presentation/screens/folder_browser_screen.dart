import 'package:flutter/material.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/widgets.dart';
import 'package:ferro/data/sources/mock_catalog.dart';
import 'package:ferro/features/player/presentation/providers/player_controller.dart';

/// Hierarchical Folder Browser Screen with interactive breadcrumbs per PRD §4.3.
class FolderBrowserScreen extends StatefulWidget {
  const FolderBrowserScreen({
    super.key,
    this.initialPath = 'Penyimpanan Internal/Music/Hi-Res',
  });

  final String initialPath;

  @override
  State<FolderBrowserScreen> createState() => _FolderBrowserScreenState();
}

class _FolderBrowserScreenState extends State<FolderBrowserScreen> {
  final PlayerController _player = PlayerController.instance;
  late List<String> _breadcrumbs;

  // Mock folder sub-directories
  final Map<String, List<String>> _folderStructure = {
    'Penyimpanan Internal': ['Music', 'Download', 'Podcasts', 'Audiobooks'],
    'Music': ['Hi-Res', 'Soundtracks', 'Lossless Rock', 'Indie Koleksi'],
    'Hi-Res': ['Daft Punk - Discovery', 'The Beatles - 1969', 'Pink Floyd Master'],
    'Download': ['FLAC', 'MP3_Singles', 'Shared_AirDrop'],
  };

  @override
  void initState() {
    super.initState();
    _breadcrumbs = widget.initialPath.split('/');
  }

  void _navigateToBreadcrumb(int index) {
    setState(() {
      _breadcrumbs = _breadcrumbs.sublist(0, index + 1);
    });
  }

  void _openSubFolder(String folderName) {
    setState(() {
      _breadcrumbs.add(folderName);
    });
  }

  void _navigateUp() {
    if (_breadcrumbs.length > 1) {
      setState(() {
        _breadcrumbs.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentFolder = _breadcrumbs.last;
    final subFolders = _folderStructure[currentFolder] ?? ['Subfolder 1', 'Subfolder 2'];
    const audioFiles = MockCatalog.songs;

    return Scaffold(
      backgroundColor: FerroColors.background,
      appBar: AppBar(
        title: Text(currentFolder, style: FerroTypography.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.playlist_play_rounded),
            tooltip: 'Putar Seluruh Folder',
            onPressed: () {
              if (audioFiles.isNotEmpty) {
                _player.play(audioFiles.first);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Memutar seluruh folder "$currentFolder" (12 Lagu)')),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Breadcrumbs Navigation Bar (Horizontal Scroll)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: FerroDimensions.space16,
              vertical: FerroDimensions.space8,
            ),
            decoration: const BoxDecoration(
              color: FerroColors.surface,
              border: Border(
                bottom: BorderSide(color: FerroColors.divider, width: 1.0),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  InkWell(
                    onTap: _breadcrumbs.length > 1 ? _navigateUp : null,
                    borderRadius: BorderRadius.circular(4.0),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: Icon(
                        Icons.arrow_upward_rounded,
                        size: 18.0,
                        color: _breadcrumbs.length > 1 ? FerroColors.primary : FerroColors.onSurfaceMuted,
                      ),
                    ),
                  ),
                  for (var i = 0; i < _breadcrumbs.length; i++) ...[
                    if (i > 0)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          size: 16.0,
                          color: FerroColors.onSurfaceMuted,
                        ),
                      ),
                    InkWell(
                      onTap: () => _navigateToBreadcrumb(i),
                      borderRadius: BorderRadius.circular(4.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                        child: Text(
                          _breadcrumbs[i],
                          style: FerroTypography.captionBold.copyWith(
                            color: i == _breadcrumbs.length - 1
                                ? FerroColors.primary
                                : FerroColors.onSurfaceMuted,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // 2. Folder Quick Actions
          Padding(
            padding: const EdgeInsets.all(FerroDimensions.space16),
            child: Row(
              children: [
                Expanded(
                  child: FerroButton(
                    label: 'Putar Folder Ini',
                    icon: Icons.play_arrow_rounded,
                    height: 40.0,
                    onPressed: () {
                      if (audioFiles.isNotEmpty) {
                        _player.play(audioFiles.first);
                      }
                    },
                  ),
                ),
                const SizedBox(width: FerroDimensions.space12),
                Expanded(
                  child: FerroButton(
                    label: 'Tambah Antrian',
                    icon: Icons.queue_music_rounded,
                    variant: FerroButtonVariant.outline,
                    height: 40.0,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Semua lagu di "$currentFolder" ditambahkan ke antrian')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // 3. Hierarchical Content List (Subfolders then Files)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: FerroDimensions.space16),
              children: [
                if (subFolders.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: FerroDimensions.space8),
                    child: Text('Folder (${subFolders.length})', style: FerroTypography.captionBold),
                  ),
                  ...subFolders.map(
                    (folder) => Card(
                      margin: const EdgeInsets.only(bottom: FerroDimensions.space8),
                      child: ListTile(
                        leading: const Icon(
                          Icons.folder_rounded,
                          color: FerroColors.primaryLight,
                          size: 28.0,
                        ),
                        title: Text(folder, style: FerroTypography.title.copyWith(fontSize: 14.5)),
                        subtitle: Text('Direktori musik offline', style: FerroTypography.caption),
                        trailing: const Icon(Icons.chevron_right_rounded, color: FerroColors.onSurfaceMuted),
                        onTap: () => _openSubFolder(folder),
                      ),
                    ),
                  ),
                  const SizedBox(height: FerroDimensions.space12),
                ],

                Padding(
                  padding: const EdgeInsets.only(bottom: FerroDimensions.space8),
                  child: Text('File Audio (${audioFiles.length})', style: FerroTypography.captionBold),
                ),
                ...audioFiles.map(
                  (song) {
                    final isCurrent = _player.currentSong.id == song.id;

                    return Card(
                      margin: const EdgeInsets.only(bottom: FerroDimensions.space8),
                      child: ListTile(
                        leading: Container(
                          width: 44.0,
                          height: 44.0,
                          decoration: BoxDecoration(
                            color: isCurrent
                                ? FerroColors.primary.withValues(alpha: 0.2)
                                : FerroColors.surfaceHigh,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Icon(
                              isCurrent ? Icons.equalizer_rounded : Icons.audio_file_rounded,
                              color: isCurrent ? FerroColors.primary : FerroColors.primaryLight,
                              size: 22.0,
                            ),
                          ),
                        ),
                        title: Text(
                          song.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: FerroTypography.title.copyWith(
                            color: isCurrent ? FerroColors.primary : FerroColors.onSurface,
                            fontSize: 14.0,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0),
                              decoration: BoxDecoration(
                                color: FerroColors.primary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                              child: Text(
                                song.format,
                                style: FerroTypography.captionBold.copyWith(
                                  color: FerroColors.primaryLight,
                                  fontSize: 9.5,
                                ),
                              ),
                            ),
                            const SizedBox(width: FerroDimensions.space6),
                            Text(
                              '${song.quality} • ${song.durationString}',
                              style: FerroTypography.caption,
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.more_vert_rounded, size: 20.0),
                          color: FerroColors.onSurfaceMuted,
                          onPressed: () {},
                        ),
                        onTap: () => _player.play(song),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 100.0), // Spacing for MiniPlayer
              ],
            ),
          ),
        ],
      ),
    );
  }
}
