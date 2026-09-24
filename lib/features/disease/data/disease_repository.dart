import 'package:dio/dio.dart';

import '../../../core/errors/result.dart';
import '../../../core/network/api_client.dart';
import 'disease_result.dart';

/// Sends crop photos to the disease-detection backend.
///
/// Backend not live yet — [analyzeMock] is active. When the vision API
/// ships, swap to [analyze] in providers.dart (contract: docs/api_contract.md).
class DiseaseRepository {
  DiseaseRepository(this._api);

  final ApiClient _api;

  /// POST /disease/detect — multipart image upload to the real endpoint.
  /// Free-text fields in the response come back in [locale].
  Future<Result<DiseaseResult>> analyze(String imagePath,
      {String locale = 'en'}) async {
    final form = FormData.fromMap({
      'image': await MultipartFile.fromFile(imagePath),
      'locale': locale,
    });
    final detection = await _api.post<Map<String, dynamic>>(
      '/disease/detect',
      data: form,
      decode: (data) => data as Map<String, dynamic>,
    );
    return switch (detection) {
      Success(:final value) => Success(
          DiseaseResult.fromJson(await _withAiAdvice(value, locale: locale)),
        ),
      Failure(:final error) => Failure(error),
    };
  }

  Future<Map<String, dynamic>> _withAiAdvice(
    Map<String, dynamic> detectionJson, {
    required String locale,
  }) async {
    final adviceResult = await _api.post<Map<String, dynamic>>(
      '/advise',
      data: detectionJson,
      decode: (data) => data as Map<String, dynamic>,
    );
    return switch (adviceResult) {
      Success(:final value) => {
          ...detectionJson,
          'advice': _localizedAdvice(value['advice'], locale),
        },
      Failure() => detectionJson,
    };
  }

  String? _localizedAdvice(Object? advice, String locale) {
    if (advice is String && advice.trim().isNotEmpty) return advice.trim();
    if (advice is Map<String, dynamic>) {
      final preferred = advice[locale];
      if (preferred is String && preferred.trim().isNotEmpty) {
        return preferred.trim();
      }
      final fallback = advice['en'] ?? advice['bn'] ?? advice['text'];
      if (fallback is String && fallback.trim().isNotEmpty) {
        return fallback.trim();
      }
    }
    return null;
  }

  /// Mock analysis until the vision backend exists.
  Future<Result<DiseaseResult>> analyzeMock(String imagePath,
      {String locale = 'en'}) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    final bn = locale == 'bn';
    return Success(
      DiseaseResult(
        disease: bn ? 'ধানের ব্লাস্ট রোগ' : 'Rice Blast',
        scientificName: 'Magnaporthe oryzae',
        confidence: 0.95,
        severity: bn ? 'মাঝারি' : 'Moderate',
        organicTreatment: bn
            ? 'আক্রান্ত পাতায় প্রতি ৫–৭ দিন পরপর নিম তেলের দ্রবণ (৫ মিলি/লিটার) '
                'স্প্রে করুন। মারাত্মক আক্রান্ত গাছ তুলে পুড়িয়ে ফেলুন।'
            : 'Spray neem oil solution (5 ml/L) on affected leaves every 5–7 '
                'days. Remove and burn heavily infected plants.',
        chemicalTreatment: bn
            ? '৩ দিনের মধ্যে ট্রাইসাইক্লাজল ৭৫ ডব্লিউপি (০.৬ গ্রাম/লিটার) প্রয়োগ '
                'করুন। দাগ থেকে গেলে ১০–১২ দিন পর আবার দিন।'
            : 'Apply Tricyclazole 75 WP (0.6 g/L) within 3 days. Repeat after '
                '10–12 days if lesions persist.',
        prevention: bn
            ? 'প্রতিরোধী জাত ব্যবহার করুন, অতিরিক্ত নাইট্রোজেন এড়িয়ে চলুন এবং '
                'রাতে জমিতে দাঁড়ানো পানি রাখবেন না।'
            : 'Use resistant varieties (BRRI dhan28 alternatives), avoid excess '
                'nitrogen, and keep the field free of standing water at night.',
      ),
    );
  }
}
