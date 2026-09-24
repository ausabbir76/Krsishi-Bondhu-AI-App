import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../core/errors/result.dart';
import '../../core/network/api_client.dart';
import 'data/market_price.dart';
import 'data/market_repository.dart';

final marketRepositoryProvider = Provider<MarketRepository>(
  (ref) => MarketRepository(ref.watch(apiClientProvider)),
);

/// Selected category filter; null = all.
final marketCategoryProvider = StateProvider<String?>((ref) => null);

/// Daily prices from the live backend.
final marketPricesProvider = FutureProvider.autoDispose<List<MarketPrice>>((
  ref,
) async {
  final result = await ref.watch(marketRepositoryProvider).fetchPrices();
  return switch (result) {
    Success(:final value) => value,
    Failure(:final error) => throw error,
  };
});

/// Prices filtered by the selected category.
final filteredPricesProvider =
    Provider.autoDispose<AsyncValue<List<MarketPrice>>>((ref) {
      final category = ref.watch(marketCategoryProvider);
      return ref
          .watch(marketPricesProvider)
          .whenData(
            (prices) => category == null
                ? prices
                : [
                    for (final p in prices)
                      if (p.category == category) p,
                  ],
          );
    });
