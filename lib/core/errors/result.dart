import 'app_exception.dart';

/// A typed result — either [Success] with a value or [Failure] with an
/// [AppException]. Repositories return this so callers never need
/// try/catch at the UI layer.
///
/// ```dart
/// final result = await repository.fetchArticles();
/// switch (result) {
///   case Success(:final value): showArticles(value);
///   case Failure(:final error): showError(error.message);
/// }
/// ```
sealed class Result<T> {
  const Result();

  /// Transforms the success value, passing failures through unchanged.
  Result<R> map<R>(R Function(T value) transform) => switch (this) {
        Success(:final value) => Success(transform(value)),
        Failure(:final error) => Failure(error),
      };

  /// Returns the value or null.
  T? get valueOrNull =>
      switch (this) { Success(:final value) => value, Failure() => null };

  bool get isSuccess => this is Success<T>;
}

final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

final class Failure<T> extends Result<T> {
  const Failure(this.error);
  final AppException error;
}
