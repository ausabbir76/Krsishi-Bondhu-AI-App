import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../core/errors/result.dart';
import '../../core/network/api_client.dart';
import '../settings/providers.dart';
import 'data/weather_forecast.dart';
import 'data/weather_repository.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>(
  (ref) => WeatherRepository(ref.watch(apiClientProvider)),
);

/// Currently selected district for the forecast.
final weatherDistrictProvider = StateProvider<String>((ref) => 'Dhaka');

/// Forecast for the selected district from the live backend. Refetches when
/// the app language changes.
final weatherForecastProvider =
    FutureProvider.autoDispose<WeatherForecast>((ref) async {
  final district = ref.watch(weatherDistrictProvider);
  final locale = ref.watch(languageControllerProvider);
  final result = await ref
      .watch(weatherRepositoryProvider)
      .fetch(district, locale: locale);
  return switch (result) {
    Success(:final value) => value,
    Failure(:final error) => throw error,
  };
});
