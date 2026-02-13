import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class ApiFailure extends Failure {
  final int? statusCode;

  const ApiFailure(super.message, [this.statusCode]);

  @override
  List<Object?> get props => [message, statusCode];
}

class InvalidApiKeyFailure extends Failure {
  const InvalidApiKeyFailure([super.message = 'Invalid API key']);
}

class DataNotFoundFailure extends Failure {
  const DataNotFoundFailure([super.message = 'Data not found']);
}

class BiometricFailure extends Failure {
  const BiometricFailure(super.message);
}

class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unknown error occurred']);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}
