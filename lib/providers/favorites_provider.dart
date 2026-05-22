import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:am_i_cooked/service/auth_service.dart';
import 'package:dio/dio.dart';
import '../utils/favorites_scrapper.dart';

final bookmarksProvider = FutureProvider.family<List<int>, int>(
  (ref, userId) async {
    final favoriteScreapper = FavoriteScreapper();
    try {
      final bookmarks = await favoriteScreapper.fetchUserFavorites(userId);

      final List<int> recipeIds = [];

      for (final item in bookmarks) {
        int? id;

        if (item is int) {
          id = item;
        }
        else if (item is String) {
          id = int.tryParse(item);
        }
        else if (item is Map<String, dynamic>) {
          id = item['id_recipe'] is int
            ? item['id_recipe']
            : int.tryParse(item['id_recipe'].toString());
        }

        if (id != null) {
          recipeIds.add(id);
        }
      }

      print('Favorites retrieved: $recipeIds');
      return recipeIds;
    } catch (e) {
      print('Error fetching favorites: $e');
      return <int>[];
    }
  },
);

final bookmarkActionsProvider = Provider.family<BookmarkActions, int>(
  (ref, userId) => BookmarkActions(userId, ref),
);

class BookmarkActions {
  final int userId;
  final Ref ref;
  late final FavoriteScreapper _favoriteScreapper;

  BookmarkActions(this.userId, this.ref) {
    _favoriteScreapper = FavoriteScreapper();
  }

  Future<void> toggleBookmark(int recipeId) async {
    try {
      print('[BookmarkActions] Starting toggleBookmark for recipe $recipeId, userId=$userId');

      final result = await _favoriteScreapper.toggleFavorite(userId, recipeId);
      print('[BookmarkActions] Toggle API result: $result');

      print('[BookmarkActions] Invalidating bookmarks provider for user $userId');
      ref.invalidate(bookmarksProvider(userId));

      await Future.delayed(const Duration(milliseconds: 250));

      try {
        final newBookmarks = await ref.read(bookmarksProvider(userId).future);
        print('[BookmarkActions] New bookmarks after toggle: $newBookmarks');
      } catch (e) {
        print('[BookmarkActions] Error reading new bookmarks: $e');
      }

      print('[BookmarkActions] toggleBookmark completed successfully');
    } catch (e) {
      print('[BookmarkActions] Error in toggleBookmark: $e');
      ref.invalidate(bookmarksProvider(userId));
      rethrow;
    }
  }

  Future<void> refresh() async {
    print('Refreshing bookmarks for user $userId');
    ref.invalidate(bookmarksProvider(userId));
    ref.read(bookmarksProvider(userId));
    await Future.delayed(const Duration(milliseconds: 100));
    print('Bookmarks refresh completed');
  }
}

final userIdProvider = FutureProvider<int?>(
  (ref) async {
    final authService = AuthService(Dio());
    final sessionId = await authService.getSessionId();
    return sessionId != null ? int.tryParse(sessionId) : null;
  },
);

