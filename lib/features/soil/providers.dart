import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/result.dart';
import '../../core/network/api_client.dart';
import '../settings/providers.dart';
import 'data/soil_analysis.dart';
import 'data/soil_repository.dart';

final soilRepositoryProvider = Provider<SoilRepository>(
  (ref) => SoilRepository(ref.watch(apiClientProvider)),
);

/// Soil analysis flow: idle until the user submits a location.
class SoilController extends Notifier<AsyncValue<SoilAnalysis?>> {
  @override
  AsyncValue<SoilAnalysis?> build() => const AsyncData(null);

  /// Swap `analyzeMock` for `analyze` when the backend is live.
  Future<void> analyze(String location) async {
    if (location.trim().isEmpty) return;
    state = const AsyncLoading();
    final result = await ref.read(soilRepositoryProvider).analyzeMock(
        location.trim(),
        locale: ref.read(languageControllerProvider));
    state = switch (result) {
      Success(:final value) => AsyncData(value),
      Failure(:final error) => AsyncError(error, StackTrace.current),
    };
  }

  void reset() => state = const AsyncData(null);
}

final soilControllerProvider = NotifierProvider.autoDispose<SoilController,
    AsyncValue<SoilAnalysis?>>(SoilController.new);
