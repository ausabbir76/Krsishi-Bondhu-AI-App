import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/result.dart';
import '../../core/network/api_client.dart';
import 'data/template_item.dart';
import 'data/template_repository.dart';

/// Repository provider — the single place where the data source is chosen.
/// Swap `fetchMockItems` for `fetchItems` when the backend is ready.
final templateRepositoryProvider = Provider<TemplateRepository>(
  (ref) => TemplateRepository(ref.watch(apiClientProvider)),
);

/// Async list of items for the screen.
///
/// `ref.watch(templateItemsProvider)` in a ConsumerWidget gives you
/// an `AsyncValue<List<TemplateItem>>` with loading/error/data states for free.
final templateItemsProvider =
    FutureProvider.autoDispose<List<TemplateItem>>((ref) async {
  final result =
      await ref.watch(templateRepositoryProvider).fetchMockItems();
  return switch (result) {
    Success(:final value) => value,
    Failure(:final error) => throw error,
  };
});
