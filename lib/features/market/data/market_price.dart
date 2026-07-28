/// One commodity's daily market price.
class MarketPrice {
  const MarketPrice({
    required this.name,
    required this.nameBn,
    required this.emoji,
    required this.category,
    required this.pricePerKg,
    required this.changePercent,
  });

  final String name;

  /// Bangla display name (backend returns both; UI picks by locale).
  final String nameBn;
  final String emoji;

  /// e.g. "Grains", "Vegetables", "Cash crops".
  final String category;

  /// Price in BDT per kg.
  final double pricePerKg;

  /// Day-over-day change; negative means the price fell.
  final double changePercent;

  /// Display name for the given locale code ('bn' → Bangla).
  String nameFor(String locale) => locale == 'bn' ? nameBn : name;

  factory MarketPrice.fromJson(Map<String, dynamic> json) => MarketPrice(
        name: json['name'] as String,
        nameBn: json['nameBn'] as String? ?? json['name'] as String,
        emoji: json['emoji'] as String? ?? '',
        category: json['category'] as String,
        pricePerKg: (json['pricePerKg'] as num).toDouble(),
        changePercent: (json['changePercent'] as num).toDouble(),
      );
}
