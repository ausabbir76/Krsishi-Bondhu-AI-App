import '../../../core/errors/result.dart';
import '../../../core/network/api_client.dart';
import 'satellite_analysis.dart';

/// Fetches satellite-derived field intelligence.
///
/// Backend not live yet — [fetchMock] is active. Swap to [fetch] in
/// providers.dart when the Earth Engine API ships (docs/api_contract.md).
class SatelliteRepository {
  SatelliteRepository(this._api);

  final ApiClient _api;

  /// GET /satellite/analysis?district=&locale= — the real endpoint.
  /// Free-text fields in the response come back in [locale].
  Future<Result<SatelliteAnalysis>> fetch(String district,
      {String locale = 'en'}) {
    return _api.get<SatelliteAnalysis>(
      '/satellite/analysis',
      queryParameters: {'district': district, 'locale': locale},
      decode: (data) =>
          SatelliteAnalysis.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Mock analysis until the backend exists.
  Future<Result<SatelliteAnalysis>> fetchMock(String district,
      {String locale = 'en'}) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final bn = locale == 'bn';
    return Success(
      SatelliteAnalysis(
        district: district,
        ndvi: 0.74,
        cropHealth: bn ? 'সুস্থ' : 'Healthy',
        waterStress: bn
            ? 'কম — সাম্প্রতিক বৃষ্টিপাত পর্যাপ্ত'
            : 'Low — recent rainfall adequate',
        floodRisk: bn
            ? 'আগামী ৭ দিনে ঝুঁকি সামান্য'
            : 'Minimal for the next 7 days',
        yieldEstimate: bn
            ? 'প্রক্ষেপিত ৬.১ টন/হেক্টর (ধান)'
            : '6.1 t/ha projected (rice)',
      ),
    );
  }
}
