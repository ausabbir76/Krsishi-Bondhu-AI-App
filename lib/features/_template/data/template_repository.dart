import '../../../core/errors/app_exception.dart';
import '../../../core/errors/result.dart';
import '../../../core/network/api_client.dart';
import 'template_item.dart';

/// Repository for the template feature.
///
/// This is THE pattern for all data access in the app:
/// - takes the [ApiClient] (or a storage interface) as a constructor dep
/// - returns `Result<T>` — never throws to the caller
/// - maps raw payloads to domain models here, not in the UI
class TemplateRepository {
  TemplateRepository(this._api);

  final ApiClient _api;

  /// Fetches items from the API.
  Future<Result<List<TemplateItem>>> fetchItems() {
    return _api.get<List<TemplateItem>>(
      '/items',
      decode: (data) => (data as List<dynamic>)
          .map((e) => TemplateItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Local mock variant — handy before the backend exists. Swap the
  /// provider in providers.dart between this and [fetchItems].
  Future<Result<List<TemplateItem>>> fetchMockItems() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return const Success([
      TemplateItem(id: '1', title: 'First item', subtitle: 'From the mock repo'),
      TemplateItem(id: '2', title: 'Second item', subtitle: 'Swap me for a real API'),
      TemplateItem(id: '3', title: 'Third item', subtitle: 'One provider change away'),
    ]);
  }
}

// A typed failure you might return from custom logic:
// return Failure(NetworkException('offline'));
// (see core/errors/app_exception.dart for the full hierarchy)
typedef TemplateFailure = AppException;
