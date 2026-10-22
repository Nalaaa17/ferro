import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ferro/data/sources/mock_catalog.dart';
import 'package:ferro/features/library/presentation/screens/library_screen.dart';

/// Notifier holding the active search filter query
class LibrarySearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

final librarySearchQueryProvider =
    NotifierProvider<LibrarySearchQueryNotifier, String>(LibrarySearchQueryNotifier.new);

/// Notifier holding the active sort option
class LibrarySortOptionNotifier extends Notifier<SortOption> {
  @override
  SortOption build() => SortOption.titleAZ;

  void setSort(SortOption sort) => state = sort;
}

final librarySortOptionProvider =
    NotifierProvider<LibrarySortOptionNotifier, SortOption>(LibrarySortOptionNotifier.new);

/// Notifier holding the active multi-select song IDs
class LibraryMultiSelectNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => <String>{};

  void toggle(String id) {
    if (state.contains(id)) {
      state = {...state}..remove(id);
    } else {
      state = {...state, id};
    }
  }

  void selectAll(List<String> ids) => state = ids.toSet();

  void clear() => state = <String>{};
}

final libraryMultiSelectProvider =
    NotifierProvider<LibraryMultiSelectNotifier, Set<String>>(LibraryMultiSelectNotifier.new);

/// Computed provider returning filtered and sorted songs in real-time per PRD §5.2
final filteredSongsProvider = Provider<List<MockSong>>((ref) {
  final query = ref.watch(librarySearchQueryProvider).trim().toLowerCase();
  final sort = ref.watch(librarySortOptionProvider);

  var songs = MockCatalog.songs.where((song) {
    if (query.isEmpty) return true;
    return song.title.toLowerCase().contains(query) ||
        song.artist.toLowerCase().contains(query) ||
        song.album.toLowerCase().contains(query) ||
        song.genre.toLowerCase().contains(query) ||
        song.format.toLowerCase().contains(query);
  }).toList();

  switch (sort) {
    case SortOption.titleAZ:
      songs.sort((a, b) => a.title.compareTo(b.title));
      break;
    case SortOption.titleZA:
      songs.sort((a, b) => b.title.compareTo(a.title));
      break;
    case SortOption.artist:
      songs.sort((a, b) => a.artist.compareTo(b.artist));
      break;
    case SortOption.duration:
      songs.sort((a, b) => b.duration.compareTo(a.duration));
      break;
    case SortOption.dateAdded:
      songs.sort((a, b) => b.playCount.compareTo(a.playCount));
      break;
  }

  return songs;
});
