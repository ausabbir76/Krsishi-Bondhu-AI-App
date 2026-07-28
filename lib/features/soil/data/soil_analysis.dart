/// Soil analysis result for a location or uploaded report.
class SoilAnalysis {
  const SoilAnalysis({
    required this.location,
    required this.ph,
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.recommendedCrop,
    required this.fertilizerAdvice,
    required this.expectedYield,
  });

  final String location;
  final double ph;

  /// Levels as "Low" / "Medium" / "High".
  final String nitrogen;
  final String phosphorus;
  final String potassium;
  final String recommendedCrop;
  final String fertilizerAdvice;
  final String expectedYield;

  factory SoilAnalysis.fromJson(Map<String, dynamic> json) => SoilAnalysis(
        location: json['location'] as String,
        ph: (json['ph'] as num).toDouble(),
        nitrogen: json['nitrogen'] as String,
        phosphorus: json['phosphorus'] as String,
        potassium: json['potassium'] as String,
        recommendedCrop: json['recommendedCrop'] as String,
        fertilizerAdvice: json['fertilizerAdvice'] as String,
        expectedYield: json['expectedYield'] as String,
      );
}
