import '../api/api_client.dart';
import '../api/api_utils.dart';
import '../../shared/models/listing_model.dart';
import 'listing_service.dart';

/// Real, listing-based favourites (saving). Backed by the API's
/// /users/me/favourites endpoints.
class FavouritesService {
  final ApiClient _api;
  FavouritesService({ApiClient? api}) : _api = api ?? ApiClient();

  /// The user's favourited listings (products & services).
  Future<List<ListingModel>> list() async {
    final res = await _api.dio.get('/users/me/favourites');
    ensureOk(res);
    final rows = res.data as List? ?? const [];
    return rows
        .map((r) => (r as Map)['listing'])
        .whereType<Map>()
        .map((l) => ListingService.mapListing(Map<String, dynamic>.from(l)))
        .toList();
  }

  /// Set of favourited listing ids — handy for initialising heart state.
  Future<Set<String>> favouriteIds() async {
    final items = await list();
    return items.map((l) => l.id).toSet();
  }

  Future<void> add(String listingId) async {
    final res = await _api.dio.post('/users/me/favourites/$listingId');
    ensureOk(res);
  }

  Future<void> remove(String listingId) async {
    final res = await _api.dio.delete('/users/me/favourites/$listingId');
    ensureOk(res);
  }

  /// Toggles and returns the new state (true = now favourited).
  Future<bool> toggle(String listingId, bool currentlyFav) async {
    if (currentlyFav) {
      await remove(listingId);
      return false;
    }
    await add(listingId);
    return true;
  }
}
