import '../../../core/errors/result.dart';
import '../../../core/network/api_client.dart';
import 'weather_forecast.dart';

/// Weather intelligence backend calls (BMD + NASA + OpenWeather fused
/// server-side).
///
/// Backend not live yet — [fetchMock] is active. Swap to [fetch] in
/// providers.dart when the API ships (docs/api_contract.md).
class WeatherRepository {
  WeatherRepository(this._api);

  final ApiClient _api;

  /// GET /weather/forecast?district=&locale= — the real endpoint.
  /// `condition` comes back in [locale]; `advisoryBn`/`advisoryEn` always
  /// carry both languages.
  Future<Result<WeatherForecast>> fetch(String district,
      {String locale = 'en'}) {
    return _api.get<WeatherForecast>(
      '/weather/forecast',
      queryParameters: {'district': district, 'locale': locale},
      decode: (data) =>
          WeatherForecast.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Mock forecast until the backend exists.
  Future<Result<WeatherForecast>> fetchMock(String district,
      {String locale = 'en'}) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final bn = locale == 'bn';
    return Success(
      WeatherForecast(
        district: district,
        todayHigh: 31,
        todayLow: 24,
        condition: bn ? 'আংশিক মেঘলা' : 'Partly cloudy',
        humidity: 78,
        rainChance: 65,
        advisoryBn:
            'আগামীকাল ভারী বৃষ্টির সম্ভাবনা রয়েছে। আজকে সেচ না দিলেও চলবে।',
        advisoryEn:
            'Heavy rain is likely tomorrow — you can skip irrigation today.',
        alerts: const [],
        daily: [
          DailyForecast(
              day: bn ? 'সোম' : 'Mon', high: 31, low: 24, icon: 'rain'),
          DailyForecast(
              day: bn ? 'মঙ্গল' : 'Tue', high: 29, low: 23, icon: 'storm'),
          DailyForecast(
              day: bn ? 'বুধ' : 'Wed', high: 30, low: 24, icon: 'cloud'),
          DailyForecast(
              day: bn ? 'বৃহঃ' : 'Thu', high: 32, low: 25, icon: 'sun'),
        ],
      ),
    );
  }
}
