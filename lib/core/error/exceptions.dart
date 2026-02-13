class ServerException implements Exception {
  final String message;

  const ServerException(this.message);

  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  final String message;

  const CacheException(this.message);

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, [this.statusCode]);

  @override
  String toString() =>
      'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class InvalidApiKeyException implements Exception {
  final String message;

  const InvalidApiKeyException([this.message = 'Invalid API key']);

  @override
  String toString() => 'InvalidApiKeyException: $message';
}

class DataNotFoundException implements Exception {
  final String message;

  const DataNotFoundException([this.message = 'Data not found']);

  @override
  String toString() => 'DataNotFoundException: $message';
}

class BiometricException implements Exception {
  final String message;

  const BiometricException(this.message);

  @override
  String toString() => 'BiometricException: $message';
}

class StorageException implements Exception {
  final String message;

  const StorageException(this.message);

  @override
  String toString() => 'StorageException: $message';
}

class ValidationException implements Exception {
  final String message;

  const ValidationException(this.message);

  @override
  String toString() => 'ValidationException: $message';
}

class UnknownException implements Exception {
  final String message;

  const UnknownException([this.message = 'An unknown error occurred']);

  @override
  String toString() => 'UnknownException: $message';
}

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}
