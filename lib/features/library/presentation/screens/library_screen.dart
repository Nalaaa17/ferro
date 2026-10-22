import 'package:flutter/material.dart';
import 'package:ferro/app/theme/theme.dart';
import 'package:ferro/core/widgets/widgets.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final List<String> _tabs = ['Lagu', 'Album', 'Artis', 'Genre', 'Folder', 'Playlist'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FerroColors.background,
      appBar: AppBar(
        title: Text('Pustaka', style: FerroTypography.display.copyWith(fontSize: 22.0)),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz_rounded),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: FerroColors.primary,
          indicatorWeight: 2.5,
          labelColor: FerroColors.primary,
          unselectedLabelColor: FerroColors.onSurfaceMuted,
          labelStyle: FerroTypography.title.copyWith(fontSize: 14.0),
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Lagu tab
          ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: FerroDimensions.space16,
              vertical: FerroDimensions.space12,
            ),
            children: [
              SongTile(
                title: 'Around The World',
                artist: 'Daft Punk • Homework',
                durationText: '07:09',
                isPlaying: false,
                onTap: () {},
                onMoreTap: () {},
              ),
              const Divider(height: 1, indent: 72),
              SongTile(
                title: 'Instant Crush (feat. Julian Casablancas)',
                artist: 'Daft Punk • RAM',
                durationText: '05:37',
                onTap: () {},
                onMoreTap: () {},
              ),
            ],
          ),
          // Album tab
          GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(FerroDimensions.space16),
            mainAxisSpacing: FerroDimensions.space16,
            crossAxisSpacing: FerroDimensions.space16,
            childAspectRatio: 0.75,
            children: [
              AlbumCard(
                title: 'Discovery',
                subtitle: 'Daft Punk',
                width: double.infinity,
                onTap: () {},
              ),
              AlbumCard(
                title: 'Random Access Memories',
                subtitle: 'Daft Punk',
                width: double.infinity,
                onTap: () {},
              ),
            ],
          ),
          // Artis tab
          const Center(child: Text('Artis')),
          // Genre tab
          const Center(child: Text('Genre')),
          // Folder tab
          const Center(child: Text('Folder')),
          // Playlist tab
          const Center(child: Text('Playlist')),
        ],
      ),
    );
  }
}
