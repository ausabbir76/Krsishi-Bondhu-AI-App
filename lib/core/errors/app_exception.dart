/// Application exception hierarchy.
///
/// All errors surfaced to the UI layer should be an [AppException] so
/// screens can `switch` on the concrete type and show the right message.
sealed class AppException implements Exception {
  const AppException(this.message, {this.cause, this.stackTrace});

  /// Human-readable, safe-to-display message.
  final String message;

  /// The underlying error, if any.
  final Object? cause;

  final StackTrace? stackTrace;

  @override
  String toString() => message;
}

/// Network-level failure (no connection, timeout, DNS...).
final class NetworkException extends AppException {
  const NetworkException(super.message, {super.cause, super.stackTrace});
}

/// Server responded with an error status code.
final class ServerException extends AppException {
  const ServerException(super.message,
      {this.statusCode, super.cause, super.stackTrace});

  final int? statusCode;
}

/// Authentication / authorization failure (401/403).
final class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message, {super.cause, super.stackTrace});
}

/// Response could not be parsed into the expected model.
final class ParsingException extends AppException {
  const ParsingException(super.message, {super.cause, super.stackTrace});
}

/// Local storage / cache failure.
final class StorageException extends AppException {
  const StorageException(super.message, {super.cause, super.stackTrace});
}

/// Anything that doesn't fit the categories above.
final class UnknownException extends AppException {
  const UnknownException(super.message, {super.cause, super.stackTrace});
}
