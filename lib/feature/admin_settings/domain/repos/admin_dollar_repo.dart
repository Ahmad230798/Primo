import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';

abstract class AdminDollarRepo {
  Future<Either<Failure, num>> getDollarValue();
  Future<Either<Failure, void>> updateDollarValue(num dollarValue);
}
