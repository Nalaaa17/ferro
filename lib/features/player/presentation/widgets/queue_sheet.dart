import 'package:flutter/material.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/widgets.dart';
import 'package:ferro/features/player/presentation/providers/player_controller.dart';

/// QueueSheet bottom sheet modal (70% height) per PRD §4.9.
class QueueSheet extends StatefulWidget {
  const QueueSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: FerroColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: FerroDimensions.radiusSheetTop,
        side: BorderSide(color: FerroColors.divider, width: 1.0),
      ),
      builder: (context) => const QueueSheet(),
    );
  }

  @override
  State<QueueSheet> createState() => _QueueSheetState();
}

class _QueueSheetState extends State<QueueSheet> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final PlayerController _player = PlayerController.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _player.addListener(_onPlayerStateChanged);
  }

  @override
  void dispose() {
    _player.removeListener(_onPlayerStateChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onPlayerStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.70, // 70% height per PRD §4.9
      child: Column(
        children: [
          // Drag Handle bar
          Center(
            child: Container(
              width: 36.0,
              height: 4.0,
              margin: const EdgeInsets.symmetric(vertical: FerroDimensions.space12),
              decoration: BoxDecoration(
                color: FerroColors.divider,
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),

          // Header with count & save action
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: FerroDimensions.space20,
              vertical: FerroDimensions.space4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('Antrian', style: FerroTypography.headline),
                    const SizedBox(width: FerroDimensions.space8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                      decoration: const BoxDecoration(
                        color: FerroColors.surfaceHigh,
                        borderRadius: FerroDimensions.radiusPillAll,
                      ),
                      child: Text(
                        '${_player.queue.length} Lagu',
                        style: FerroTypography.captionBold.copyWith(
                          color: FerroColors.primary,
                          fontSize: 11.0,
                        ),
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  icon: const Icon(Icons.playlist_add_rounded, size: 18.0),
                  label: const Text('Simpan Playlist'),
                  style: TextButton.styleFrom(
                    foregroundColor: FerroColors.primary,
                    textStyle: FerroTypography.captionBold,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Antrian berhasil disimpan ke Playlist')),
                    );
                  },
                ),
              ],
            ),
          ),

          // Tab Toggle: Antrian vs Riwayat
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: FerroDimensions.space20),
            child: Container(
              height: 36.0,
              decoration: const BoxDecoration(
                color: FerroColors.surfaceHigh,
                borderRadius: FerroDimensions.radiusPillAll,
              ),
              child: TabBar(
                controller: _tabController,
                indicator: const BoxDecoration(
                  gradient: FerroColors.primaryGradient,
                  borderRadius: FerroDimensions.radiusPillAll,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: FerroColors.onSurfaceMuted,
                labelStyle: FerroTypography.captionBold,
                tabs: const [
                  Tab(text: 'Antrian Berikutnya'),
                  Tab(text: 'Riwayat Pemutaran'),
                ],
              ),
            ),
          ),
          const SizedBox(height: FerroDimensions.space12),

          // Content Tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 1. Antrian Berikutnya Tab
                _buildQueueTab(),

                // 2. Riwayat Tab
                _buildHistoryTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueTab() {
    final currentSong = _player.currentSong;
    final queue = _player.queue;

    return CustomScrollView(
      slivers: [
        // Sedang Diputar (Now Playing Highlight Section)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: FerroDimensions.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SEDANG DIPUTAR',
                  style: FerroTypography.captionBold.copyWith(
                    color: FerroColors.primary,
                    letterSpacing: 1.0,
                    fontSize: 10.5,
                  ),
                ),
                const SizedBox(height: FerroDimensions.space6),
                Container(
                  padding: const EdgeInsets.all(FerroDimensions.space12),
                  decoration: BoxDecoration(
                    color: FerroColors.surfaceHigh,
                    borderRadius: FerroDimensions.radiusCardAll,
                    border: Border.all(color: FerroColors.primary, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: FerroColors.primary.withValues(alpha: 0.15),
                        blurRadius: 12.0,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const ArtworkPlaceholder(size: 44.0),
                      const SizedBox(width: FerroDimensions.space12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentSong.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: FerroTypography.title.copyWith(
                                color: FerroColors.primary,
                                fontSize: 14.5,
                              ),
                            ),
                            const SizedBox(height: FerroDimensions.space2),
                            Text(
                              '${currentSong.artist} • ${currentSong.format}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: FerroTypography.caption,
                            ),
                          ],
                        ),
                      ),
                      // Mini Animated Equalizer Visualizer Bars
                      _buildEqualizerBarVisualizer(),
                    ],
                  ),
                ),
                const SizedBox(height: FerroDimensions.space16),
                Text(
                  'BERIKUTNYA DALAM ANTRIAN',
                  style: FerroTypography.captionBold.copyWith(
                    color: FerroColors.onSurfaceMuted,
                    letterSpacing: 1.0,
                    fontSize: 10.5,
                  ),
                ),
                const SizedBox(height: FerroDimensions.space6),
              ],
            ),
          ),
        ),

        // Reorderable Queue List
        SliverReorderableList(
          itemCount: queue.length,
          onReorderItem: _player.reorderQueueItem,
          itemBuilder: (context, index) {
            final song = queue[index];
            final isPlayingThis = song.id == currentSong.id;

            return Dismissible(
              key: ValueKey('queue-${song.id}-$index'),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20.0),
                color: FerroColors.error,
                child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
              ),
              onDismissed: (_) => _player.removeFromQueue(index),
              child: ReorderableDelayedDragStartListener(
                index: index,
                child: Material(
                  color: Colors.transparent,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: FerroDimensions.space16,
                      vertical: FerroDimensions.space2,
                    ),
                    leading: const ArtworkPlaceholder(size: 40.0),
                    title: Text(
                      song.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FerroTypography.title.copyWith(
                        fontSize: 14.0,
                        color: isPlayingThis ? FerroColors.primary : FerroColors.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      '${song.artist} • ${song.durationString}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FerroTypography.caption,
                    ),
                    trailing: const Icon(
                      Icons.drag_handle_rounded,
                      color: FerroColors.onSurfaceMuted,
                      size: 20.0,
                    ),
                    onTap: () => _player.playSong(song),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHistoryTab() {
    final history = _player.history;

    if (history.isEmpty) {
      return const EmptyState(
        title: 'Belum Ada Riwayat',
        description: 'Lagu yang sudah selesai diputar akan muncul di sini.',
        icon: Icons.history_rounded,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: FerroDimensions.space16),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final song = history[index];
        return ListTile(
          leading: const ArtworkPlaceholder(size: 40.0),
          title: Text(song.title, style: FerroTypography.title.copyWith(fontSize: 14.0)),
          subtitle: Text('${song.artist} • ${song.durationString}', style: FerroTypography.caption),
          trailing: IconButton(
            icon: const Icon(Icons.play_circle_outline_rounded, color: FerroColors.primary),
            onPressed: () => _player.playSong(song),
          ),
        );
      },
    );
  }

  Widget _buildEqualizerBarVisualizer() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _VisualizerBar(height: 18.0, durationMs: 450),
        SizedBox(width: 2.5),
        _VisualizerBar(height: 24.0, durationMs: 350),
        SizedBox(width: 2.5),
        _VisualizerBar(height: 14.0, durationMs: 600),
        SizedBox(width: 2.5),
        _VisualizerBar(height: 20.0, durationMs: 400),
      ],
    );
  }
}

class _VisualizerBar extends StatefulWidget {
  const _VisualizerBar({required this.height, required this.durationMs});

  final double height;
  final int durationMs;

  @override
  State<_VisualizerBar> createState() => _VisualizerBarState();
}

class _VisualizerBarState extends State<_VisualizerBar> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.durationMs),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 4.0, end: widget.height).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Container(
          width: 3.0,
          height: _animation.value,
          decoration: BoxDecoration(
            color: FerroColors.primary,
            borderRadius: BorderRadius.circular(1.5),
          ),
        );
      },
    );
  }
}
