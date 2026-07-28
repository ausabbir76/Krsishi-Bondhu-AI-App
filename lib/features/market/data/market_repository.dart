import '../../../core/errors/result.dart';
import '../../../core/network/api_client.dart';
import 'market_price.dart';

/// Marketplace backend calls.
///
/// Backend not live yet — [fetchMockPrices] is active. Swap to [fetchPrices]
/// in providers.dart when the API ships (docs/api_contract.md).
class MarketRepository {
  MarketRepository(this._api);

  final ApiClient _api;

  /// GET /market/prices — the real endpoint.
  Future<Result<List<MarketPrice>>> fetchPrices() {
    return _api.get<List<MarketPrice>>(
      '/market/prices',
      decode: (data) => [
        for (final e in data as List<dynamic>)
          MarketPrice.fromJson(e as Map<String, dynamic>),
      ],
    );
  }

  /// Mock daily prices until the backend exists.
  Future<Result<List<MarketPrice>>> fetchMockPrices() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return const Success([
      MarketPrice(name: 'Rice (coarse)', nameBn: 'চাল (মোটা)', emoji: '🌾', category: 'Grains', pricePerKg: 32.50, changePercent: 1.4),
      MarketPrice(name: 'Wheat', nameBn: 'গম', emoji: '🌾', category: 'Grains', pricePerKg: 38.00, changePercent: 0.5),
      MarketPrice(name: 'Maize', nameBn: 'ভুট্টা', emoji: '🌽', category: 'Grains', pricePerKg: 28.75, changePercent: -0.3),
      MarketPrice(name: 'Potato', nameBn: 'আলু', emoji: '🥔', category: 'Vegetables', pricePerKg: 22.00, changePercent: -0.8),
      MarketPrice(name: 'Tomato', nameBn: 'টমেটো', emoji: '🍅', category: 'Vegetables', pricePerKg: 45.00, changePercent: 3.2),
      MarketPrice(name: 'Onion', nameBn: 'পেঁয়াজ', emoji: '🧅', category: 'Vegetables', pricePerKg: 58.00, changePercent: 2.5),
      MarketPrice(name: 'Chili (green)', nameBn: 'কাঁচা মরিচ', emoji: '🌶️', category: 'Vegetables', pricePerKg: 120.00, changePercent: -4.1),
      MarketPrice(name: 'Eggplant', nameBn: 'বেগুন', emoji: '🍆', category: 'Vegetables', pricePerKg: 35.00, changePercent: 0.9),
      MarketPrice(name: 'Jute', nameBn: 'পাট', emoji: '🌱', category: 'Cash crops', pricePerKg: 65.00, changePercent: 2.1),
      MarketPrice(name: 'Mustard', nameBn: 'সরিষা', emoji: '🫘', category: 'Cash crops', pricePerKg: 92.00, changePercent: 0.0),
      MarketPrice(name: 'Lentil (masur)', nameBn: 'মসুর ডাল', emoji: '🫛', category: 'Pulses', pricePerKg: 135.00, changePercent: 1.1),
      MarketPrice(name: 'Banana (dozen)', nameBn: 'কলা (ডজন)', emoji: '🍌', category: 'Fruits', pricePerKg: 110.00, changePercent: -1.5),
    ]);
  }
}
