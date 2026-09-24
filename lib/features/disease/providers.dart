import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/result.dart';
import '../../core/network/api_client.dart';
import '../settings/providers.dart';
import 'data/disease_repository.dart';
import 'data/disease_result.dart';

/// Repository provider for the live disease-detection backend.
final diseaseRepositoryProvider = Provider<DiseaseRepository>(
  (ref) => DiseaseRepository(ref.watch(apiClientProvider)),
);

/// Scan flow state: picked image + analysis progress/result.
class ScanState {
  const ScanState({this.imagePath, this.result, this.analyzing = false, this.error});

  final String? imagePath;
  final DiseaseResult? result;
  final bool analyzing;
  final String? error;

  ScanState copyWith({
    String? imagePath,
    DiseaseResult? result,
    bool? analyzing,
    String? error,
  }) =>
      ScanState(
        imagePath: imagePath ?? this.imagePath,
        result: result,
        analyzing: analyzing ?? this.analyzing,
        error: error,
      );
}

class ScanController extends Notifier<ScanState> {
  @override
  ScanState build() => const ScanState();

  void setImage(String path) => state = ScanState(imagePath: path);

  void reset() => state = const ScanState();

  Future<void> analyze() async {
    final path = state.imagePath;
    if (path == null || state.analyzing) return;

    state = state.copyWith(analyzing: true);
    final result = await ref.read(diseaseRepositoryProvider).analyze(
        path,
        locale: ref.read(languageControllerProvider));
    state = switch (result) {
      Success(:final value) =>
        ScanState(imagePath: path, result: value),
      Failure(:final error) =>
        ScanState(imagePath: path, error: error.message),
    };
  }
}

final scanControllerProvider =
    NotifierProvider.autoDispose<ScanController, ScanState>(ScanController.new);
