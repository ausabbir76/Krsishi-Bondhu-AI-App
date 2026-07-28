import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:krishi_bondhu_ai_app/app/router/app_router.dart';
import 'package:krishi_bondhu_ai_app/app/router/routes.dart';

void main() {
  test('every route name is registered in the router', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final router = container.read(routerProvider);

    final registered = router.configuration.routes
        .map((r) => r.toString())
        .join('\n');

    const names = [
      Routes.home,
      Routes.diseaseScan,
      Routes.satellite,
      Routes.soil,
      Routes.weather,
    ];

    for (final name in names) {
      expect(
        registered,
        contains(name),
        reason: 'route "$name" missing from router',
      );
    }
  });
}
