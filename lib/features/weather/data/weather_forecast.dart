/// Weather forecast + farming advisory for a district.
class WeatherForecast {
  const WeatherForecast({
    required this.district,
    required this.todayHigh,
    required this.todayLow,
    required this.condition,
    required this.humidity,
    required this.rainChance,
    required this.advisoryBn,
    required this.advisoryEn,
    required this.alerts,
    required this.daily,
  });

  final String district;
  final int todayHigh;
  final int todayLow;
  final String condition;
  final int humidity;
  final int rainChance;

  /// Farming advisory in Bangla (site style: explained, not just numbers).
  final String advisoryBn;
  final String advisoryEn;

  /// Active warnings (cyclone/flood/heat) — empty when all clear.
  final List<String> alerts;
  final List<DailyForecast> daily;

  factory WeatherForecast.fromJson(Map<String, dynamic> json) =>
      WeatherForecast(
        district: json['district'] as String,
        todayHigh: json['todayHigh'] as int,
        todayLow: json['todayLow'] as int,
        condition: json['condition'] as String,
        humidity: json['humidity'] as int,
        rainChance: json['rainChance'] as int,
        advisoryBn: json['advisoryBn'] as String,
        advisoryEn: json['advisoryEn'] as String,
        alerts: [...(json['alerts'] as List<dynamic>).cast<String>()],
        daily: [
          for (final d in json['daily'] as List<dynamic>)
            DailyForecast.fromJson(d as Map<String, dynamic>),
        ],
      );
}

class DailyForecast {
  const DailyForecast({
    required this.day,
    required this.high,
    required this.low,
    required this.icon,
  });

  final String day;
  final int high;
  final int low;

  /// Simple condition key: "sun", "rain", "cloud", "storm".
  final String icon;

  factory DailyForecast.fromJson(Map<String, dynamic> json) => DailyForecast(
        day: json['day'] as String,
        high: json['high'] as int,
        low: json['low'] as int,
        icon: json['icon'] as String,
      );
}
