import '../../../core/errors/result.dart';
import '../../../core/network/api_client.dart';
import 'soil_analysis.dart';

/// Soil intelligence backend calls.
///
/// Backend not live yet — [analyzeMock] is active. Swap to [analyze] in
/// providers.dart when the API ships (docs/api_contract.md).
class SoilRepository {
  SoilRepository(this._api);

  final ApiClient _api;

  /// POST /soil/analyze — the real endpoint.
  /// Free-text fields in the response come back in [locale].
  Future<Result<SoilAnalysis>> analyze(String location,
      {String locale = 'en'}) {
    return _api.post<SoilAnalysis>(
      '/soil/analyze',
      data: {'location': location, 'locale': locale},
      decode: (data) => SoilAnalysis.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Mock analysis until the backend exists.
  Future<Result<SoilAnalysis>> analyzeMock(String location,
      {String locale = 'en'}) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final bn = locale == 'bn';
    return Success(
      SoilAnalysis(
        location: location,
        ph: 6.4,
        nitrogen: bn ? 'মাঝারি' : 'Medium',
        phosphorus: bn ? 'বেশি' : 'High',
        potassium: bn ? 'কম' : 'Low',
        recommendedCrop: bn ? 'ধান (ব্রি ধান২৯)' : 'Rice (BRRI dhan29)',
        fertilizerAdvice: bn
            ? 'পটাশিয়ামের ঘাটতি পূরণে হেক্টরপ্রতি ৭০ কেজি এমওপি প্রয়োগ করুন। '
                'ইউরিয়া স্বাভাবিক মাত্রায় দিন; ফসফরাস ইতিমধ্যে বেশি থাকায় '
                'এই মৌসুমে অতিরিক্ত টিএসপি লাগবে না।'
            : 'Apply MoP 70 kg/ha to correct low potassium. Urea at standard '
                'rate; skip additional TSP this season — phosphorus is already high.',
        expectedYield: bn ? '৬.২ টন/হেক্টর' : '6.2 t/ha',
      ),
    );
  }
}
