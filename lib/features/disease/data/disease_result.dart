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
    this.aiAdvice,
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
  final String? aiAdvice;

  factory DiseaseResult.fromJson(Map<String, dynamic> json) => DiseaseResult(
        disease: json['disease'] as String,
        scientificName: json['scientificName'] as String? ?? '',
        confidence: (json['confidence'] as num).toDouble(),
        severity: json['severity'] as String,
        organicTreatment: json['organicTreatment'] as String,
        chemicalTreatment: json['chemicalTreatment'] as String,
        prevention: json['prevention'] as String,
        aiAdvice: _readAdvice(json),
      );
}

String? _readAdvice(Map<String, dynamic> json) {
  final advice = json['advice'] ?? json['aiAdvice'] ?? json['aiSuggestions'];
  if (advice is String && advice.trim().isNotEmpty) return advice.trim();
  if (advice is Map<String, dynamic>) {
    final text = advice['text'] ?? advice['message'] ?? advice['en'] ?? advice['bn'];
    if (text is String && text.trim().isNotEmpty) return text.trim();
  }
  return null;
}
