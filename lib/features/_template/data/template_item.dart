/// Domain model for the template feature.
///
/// Replace with your real entity. Keep models immutable with `const`
/// constructors and value equality where practical.
class TemplateItem {
  const TemplateItem({
    required this.id,
    required this.title,
    required this.subtitle,
  });

  final String id;
  final String title;
  final String subtitle;

  /// Example JSON factory for when this comes from an API.
  factory TemplateItem.fromJson(Map<String, dynamic> json) => TemplateItem(
        id: json['id'] as String,
        title: json['title'] as String,
        subtitle: json['subtitle'] as String? ?? '',
      );
}
