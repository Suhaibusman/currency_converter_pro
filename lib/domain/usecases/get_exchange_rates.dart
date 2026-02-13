import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/currency_rate.dart';
import '../repositories/currency_repository.dart';

class GetExchangeRates {
  final CurrencyRepository repository;

  GetExchangeRates(this.repository);

  Future<Either<Failure, CurrencyRate>> call(String baseCurrency) async {
    return await repository.getExchangeRates(baseCurrency);
  }
}