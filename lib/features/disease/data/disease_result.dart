/// Result of analyzing a crop photo for disease.
class DiseaseResult {
  const DiseaseResult({
    required this.disease,
    required this.scientificName,
    required this.confidence,
    required this.severity,
    required this.organicTreatment,
    required this.chemicalTreatment,
    required this.prevention,
  });

  final String disease;
  final String scientificName;

  /// 0–1 model confidence.
  final double confidence;

  /// e.g. "Mild", "Moderate", "Severe".
  final String severity;
  final String organicTreatment;
  final String chemicalTreatment;
  final String prevention;

  factory DiseaseResult.fromJson(Map<String, dynamic> json) => DiseaseResult(
        disease: json['disease'] as String,
        scientificName: json['scientificName'] as String? ?? '',
        confidence: (json['confidence'] as num).toDouble(),
        severity: json['severity'] as String,
        organicTreatment: json['organicTreatment'] as String,
        chemicalTreatment: json['chemicalTreatment'] as String,
        prevention: json['prevention'] as String,
      );
}
