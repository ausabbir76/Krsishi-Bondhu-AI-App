import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Streams the device's connectivity status.
///
/// ```dart
/// final isOnline = ref.watch(isOnlineProvider);
/// ```
final connectivityStreamProvider = StreamProvider<List<ConnectivityResult>>(
  (ref) => Connectivity().onConnectivityChanged,
);

/// `true` while the device has any network transport available.
final isOnlineProvider = Provider<bool>((ref) {
  final results = ref.watch(connectivityStreamProvider).asData?.value;
  if (results == null) return true; // assume online until first event
  return results.any((r) => r != ConnectivityResult.none);
});
