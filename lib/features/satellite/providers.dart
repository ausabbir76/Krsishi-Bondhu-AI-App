import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../core/errors/result.dart';
import '../../core/network/api_client.dart';
import '../settings/providers.dart';
import 'data/satellite_analysis.dart';
import 'data/satellite_repository.dart';

final satelliteRepositoryProvider = Provider<SatelliteRepository>(
  (ref) => SatelliteRepository(ref.watch(apiClientProvider)),
);

/// Currently selected district for satellite analysis.
final satelliteDistrictProvider = StateProvider<String>((ref) => 'Rangpur');

/// Analysis for the selected district — swap `fetchMock` for `fetch` when
/// the backend is live. Refetches when the app language changes so the
/// free-text fields come back in the right language.
final satelliteAnalysisProvider =
    FutureProvider.autoDispose<SatelliteAnalysis>((ref) async {
  final district = ref.watch(satelliteDistrictProvider);
  final locale = ref.watch(languageControllerProvider);
  final result = await ref
      .watch(satelliteRepositoryProvider)
      .fetchMock(district, locale: locale);
  return switch (result) {
    Success(:final value) => value,
    Failure(:final error) => throw error,
  };
});
