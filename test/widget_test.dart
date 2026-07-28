import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:krishi_bondhu_ai_app/app/app.dart';
import 'package:krishi_bondhu_ai_app/core/storage/key_value_storage.dart';

/// In-memory storage fake for tests.
class _FakeStorage implements KeyValueStorage {
  final Map<String, Object> _data = {};

  @override
  String? getString(String key) => _data[key] as String?;

  @override
  Future<bool> setString(String key, String value) async {
    _data[key] = value;
    return true;
  }

  @override
  bool? getBool(String key) => _data[key] as bool?;

  @override
  Future<bool> setBool(String key, {required bool value}) async {
    _data[key] = value;
    return true;
  }

  @override
  int? getInt(String key) => _data[key] as int?;

  @override
  Future<bool> setInt(String key, int value) async {
    _data[key] = value;
    return true;
  }

  @override
  Future<bool> remove(String key) async {
    _data.remove(key);
    return true;
  }
}

void main() {
  testWidgets('App boots and shows the home screen', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [keyValueStorageProvider.overrideWithValue(_FakeStorage())],
        child: const App(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    // Root Cupertino app is present and home content rendered.
    expect(find.byType(CupertinoApp), findsOneWidget);
    expect(find.text('KrishiBondhu AI'), findsWidgets);
  });
}
