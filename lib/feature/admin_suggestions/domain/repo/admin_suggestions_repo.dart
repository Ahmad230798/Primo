import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/admin_home/data/models/admin_dashboard_model.dart';

abstract class AdminSuggestionsRepo {
  Future<Either<Failure, List<SuggestionModel>>> getSuggestions();
  Future<Either<Failure, String>> updateSuggestionStatus(int suggestionId, String status);
}
