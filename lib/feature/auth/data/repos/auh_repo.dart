import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/auth/data/models/register_request_body.dart';
import 'package:primo/feature/auth/data/models/register_response_body.dart';

abstract class AuthRepo {
  // الدالة الآن تعد بإرجاع "إما خطأ أو نجاح"
  Future<Either<Failure, RegisterResponseBody>> register(RegisterRequestBody registerRequestBody);
}
