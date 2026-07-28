import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/disease/presentation/disease_scan_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/satellite/presentation/satellite_screen.dart';
import '../../features/soil/presentation/soil_screen.dart';
import '../../features/weather/presentation/weather_screen.dart';
import 'routes.dart';

/// The app router.
///
/// Every screen is a named route — navigate with:
/// ```dart
/// context.pushNamed(Routes.diseaseScan);
/// ```
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.homePath,
    debugLogDiagnostics: false,
    routes: [
      _route(Routes.home, path: Routes.homePath, child: const HomeScreen()),

      // ── AI tool screens ───────────────────────────────────────────
      _route(Routes.diseaseScan, child: const DiseaseScanScreen()),
      _route(Routes.satellite, child: const SatelliteScreen()),
      _route(Routes.soil, child: const SoilScreen()),
      _route(Routes.weather, child: const WeatherScreen()),
    ],
  );
});

/// Builds a named [GoRoute] with a standard native Material page transition.
GoRoute _route(String name, {String? path, required Widget child}) {
  return GoRoute(
    name: name,
    path: path ?? Routes.pathOf(name),
    pageBuilder: (context, state) =>
        MaterialPage<void>(key: state.pageKey, child: child),
  );
}
