import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';

abstract class SuggestionsRepo {
  Future<Either<Failure, String>> sendSuggestion({
    required String name,
    required String description,
  });
}
