import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../repositories/currency_repository.dart';

class ConvertCurrency {
  final CurrencyRepository repository;

  ConvertCurrency(this.repository);

  Future<Either<Failure, double>> call({
    required String from,
    required String to,
    required double amount,
  }) async {
    final ratesResult = await repository.getCachedRates();
    
    return ratesResult.fold(
      (failure) => Left(failure),
      (rates) {
        try {
          final result = rates.convert(from, to, amount);
          return Right(result);
        } catch (e) {
          return const Left(CacheFailure('Conversion failed'));
        }
      },
    );
  }
}