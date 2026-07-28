/// Satellite analysis for one district.
class SatelliteAnalysis {
  const SatelliteAnalysis({
    required this.district,
    required this.ndvi,
    required this.cropHealth,
    required this.waterStress,
    required this.floodRisk,
    required this.yieldEstimate,
  });

  final String district;

  /// Normalized Difference Vegetation Index, 0–1.
  final double ndvi;

  /// e.g. "Excellent", "Healthy", "Stressed".
  final String cropHealth;
  final String waterStress;
  final String floodRisk;
  final String yieldEstimate;

  factory SatelliteAnalysis.fromJson(Map<String, dynamic> json) =>
      SatelliteAnalysis(
        district: json['district'] as String,
        ndvi: (json['ndvi'] as num).toDouble(),
        cropHealth: json['cropHealth'] as String,
        waterStress: json['waterStress'] as String,
        floodRisk: json['floodRisk'] as String,
        yieldEstimate: json['yieldEstimate'] as String,
      );
}
