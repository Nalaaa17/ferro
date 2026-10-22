import 'package:flutter/material.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/widgets.dart';
import 'package:ferro/data/sources/mock_catalog.dart';
import 'package:ferro/features/player/presentation/providers/player_controller.dart';

/// Playlist Detail Screen with 2x2 cover collage, track reordering, and create/edit sheet per PRD §4.3.
class PlaylistDetailScreen extends StatefulWidget {
  const PlaylistDetailScreen({
    super.key,
    required this.playlistTitle,
    this.description = 'Playlist musik offline lokal',
    this.initialSongs,
  });

  final String playlistTitle;
  final String description;
  final List<MockSong>? initialSongs;

  static void showCreatePlaylistSheet(
    BuildContext context, {
    void Function(String name, String desc)? onCreate,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: FerroColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: FerroDimensions.radiusSheetTop,
        side: BorderSide(color: FerroColors.divider, width: 1.0),
      ),
      builder: (context) => _CreatePlaylistSheet(onCreate: onCreate),
    );
  }

  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  final PlayerController _player = PlayerController.instance;
  late List<MockSong> _songs;
  late String _title;
  late String _description;

  @override
  void initState() {
    super.initState();
    _title = widget.playlistTitle;
    _description = widget.description;
    _songs = widget.initialSongs != null
        ? List.from(widget.initialSongs!)
        : List.from(_player.allSongs);
  }

  void _onReorderItem(int oldIndex, int newIndex) {
    setState(() {
      final item = _songs.removeAt(oldIndex);
      _songs.insert(newIndex, item);
    });
  }

  void _removeSong(int index) {
    final removed = _songs[index];
    setState(() {
      _songs.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${removed.title}" dihapus dari playlist'),
        action: SnackBarAction(
          label: 'BATAL',
          textColor: FerroColors.primaryLight,
          onPressed: () {
            setState(() {
              _songs.insert(index, removed);
            });
          },
        ),
      ),
    );
  }

  void _editPlaylistDetails() {
    PlaylistDetailScreen.showCreatePlaylistSheet(
      context,
      onCreate: (newName, newDesc) {
        setState(() {
          _title = newName;
          _description = newDesc;
        });
      },
    );
  }

  String get _totalDurationString {
    final totalSeconds = _songs.fold<int>(0, (sum, s) => sum + s.duration.inSeconds);
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    if (hours > 0) {
      return '$hours jam $minutes mnt';
    }
    return '$minutes menit';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FerroColors.background,
      appBar: AppBar(
        title: Text(_title, style: FerroTypography.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Ubah Info Playlist',
            onPressed: _editPlaylistDetails,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opsi playlist: Bagikan, Ekspor .m3u8')),
              );
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Header Section: 2x2 Collage, Title, Meta, and Action Buttons
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(FerroDimensions.space16),
              child: Column(
                children: [
                  // 2x2 Collage Artwork (140dp x 140dp)
                  _build2x2CoverCollage(),
                  const SizedBox(height: FerroDimensions.space16),

                  // Title & Subtitle
                  Text(
                    _title,
                    textAlign: TextAlign.center,
                    style: FerroTypography.display.copyWith(fontSize: 22.0),
                  ),
                  const SizedBox(height: FerroDimensions.space4),
                  Text(
                    _description,
                    textAlign: TextAlign.center,
                    style: FerroTypography.caption.copyWith(color: FerroColors.onSurfaceMuted),
                  ),
                  const SizedBox(height: FerroDimensions.space4),
                  Text(
                    '${_songs.length} Lagu • $_totalDurationString',
                    style: FerroTypography.captionBold.copyWith(color: FerroColors.primary),
                  ),
                  const SizedBox(height: FerroDimensions.space16),

                  // Action Buttons: Play All & Shuffle
                  Row(
                    children: [
                      Expanded(
                        child: FerroButton(
                          label: 'Putar Semua',
                          icon: Icons.play_arrow_rounded,
                          variant: FerroButtonVariant.filled,
                          onPressed: () {
                            if (_songs.isNotEmpty) {
                              _player.play(_songs.first);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: FerroDimensions.space12),
                      Expanded(
                        child: FerroButton(
                          label: 'Acak',
                          icon: Icons.shuffle_rounded,
                          variant: FerroButtonVariant.outline,
                          onPressed: () {
                            if (_songs.isNotEmpty) {
                              _player.toggleShuffle();
                              _player.play(_songs.first);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: FerroDimensions.space16),
                  const Divider(height: 1.0),
                ],
              ),
            ),
          ),

          // Reorderable Track List
          SliverReorderableList(
            itemCount: _songs.length,
            onReorderItem: _onReorderItem,
            itemBuilder: (context, index) {
              final song = _songs[index];
              final isCurrent = _player.currentSong.id == song.id;

              return ReorderableDelayedDragStartListener(
                key: ValueKey(song.id),
                index: index,
                child: Dismissible(
                  key: ValueKey('dismiss_${song.id}'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: FerroDimensions.space20),
                    color: FerroColors.error.withValues(alpha: 0.8),
                    child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
                  ),
                  onDismissed: (_) => _removeSong(index),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: FerroDimensions.space16,
                      vertical: FerroDimensions.space4,
                    ),
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
                        child: isCurrent
                            ? const Icon(Icons.equalizer_rounded, color: FerroColors.primary, size: 22.0)
                            : Text(
                                '${index + 1}',
                                style: FerroTypography.monoTimer.copyWith(
                                  color: FerroColors.onSurfaceMuted,
                                ),
                              ),
                      ),
                    ),
                    title: Text(
                      song.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FerroTypography.title.copyWith(
                        color: isCurrent ? FerroColors.primary : FerroColors.onSurface,
                        fontSize: 14.5,
                      ),
                    ),
                    subtitle: Text(
                      '${song.artist} • ${song.durationString}',
                      style: FerroTypography.caption,
                    ),
                    trailing: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.drag_handle_rounded, color: FerroColors.onSurfaceMuted),
                      ],
                    ),
                    onTap: () => _player.play(song),
                  ),
                ),
              );
            },
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 100.0), // Spacing for MiniPlayer
          ),
        ],
      ),
    );
  }

  /// 2x2 Collage Artwork Container with 4 quadrant cells
  Widget _build2x2CoverCollage() {
    return Container(
      width: 140.0,
      height: 140.0,
      decoration: BoxDecoration(
        color: FerroColors.surfaceHigh,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: FerroColors.primary.withValues(alpha: 0.25),
            blurRadius: 20.0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 1.5,
            crossAxisSpacing: 1.5,
          ),
          itemCount: 4,
          itemBuilder: (context, i) {
            final song = i < _songs.length ? _songs[i] : null;
            final color = song?.accentColor ?? FerroColors.primary;

            return Container(
              color: color.withValues(alpha: 0.35),
              child: Center(
                child: Icon(
                  i == 0
                      ? Icons.music_note_rounded
                      : i == 1
                          ? Icons.album_rounded
                          : i == 2
                              ? Icons.headphones_rounded
                              : Icons.favorite_rounded,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 24.0,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Sheet to create or edit playlist details
class _CreatePlaylistSheet extends StatefulWidget {
  const _CreatePlaylistSheet({this.onCreate});

  final void Function(String name, String desc)? onCreate;

  @override
  State<_CreatePlaylistSheet> createState() => _CreatePlaylistSheetState();
}

class _CreatePlaylistSheetState extends State<_CreatePlaylistSheet> {
  final TextEditingController _nameController = TextEditingController(text: 'Playlist Baru');
  final TextEditingController _descController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      widget.onCreate?.call(name, _descController.text.trim());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: FerroDimensions.space16,
        right: FerroDimensions.space16,
        top: FerroDimensions.space20,
        bottom: MediaQuery.of(context).viewInsets.bottom + FerroDimensions.space20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Buat / Edit Playlist', style: FerroTypography.headline.copyWith(fontSize: 18.0)),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(height: 20.0),
          Text('Nama Playlist', style: FerroTypography.captionBold),
          const SizedBox(height: FerroDimensions.space8),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Contoh: Road Trip, Santai Sore, Workout Mix',
              prefixIcon: Icon(Icons.playlist_play_rounded, color: FerroColors.primaryLight),
            ),
          ),
          const SizedBox(height: FerroDimensions.space16),
          Text('Deskripsi (Opsional)', style: FerroTypography.captionBold),
          const SizedBox(height: FerroDimensions.space8),
          TextField(
            controller: _descController,
            decoration: const InputDecoration(
              hintText: 'Koleksi audio lokal pilihan...',
              prefixIcon: Icon(Icons.description_outlined, color: FerroColors.onSurfaceMuted),
            ),
          ),
          const SizedBox(height: FerroDimensions.space20),
          Row(
            children: [
              Expanded(
                child: FerroButton(
                  label: 'Batal',
                  variant: FerroButtonVariant.outline,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: FerroDimensions.space12),
              Expanded(
                child: FerroButton(
                  label: 'Simpan',
                  variant: FerroButtonVariant.filled,
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
