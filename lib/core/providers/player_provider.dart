import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferro/data/sources/mock_catalog.dart';
import 'package:ferro/features/player/presentation/providers/player_controller.dart';

/// Riverpod Provider exposing the global PlayerController per PRD §5.2.
final playerProvider = Provider<PlayerController>((ref) {
  return PlayerController.instance;
});

/// Specific selector provider for current playing song
final currentSongProvider = Provider<MockSong>((ref) {
  final player = ref.watch(playerProvider);
  return player.currentSong;
});

/// Specific selector provider for playback status
final isPlayingProvider = Provider<bool>((ref) {
  final player = ref.watch(playerProvider);
  return player.isPlaying;
});
