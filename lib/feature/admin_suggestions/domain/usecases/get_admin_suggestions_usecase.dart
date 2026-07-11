import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/admin_home/data/models/admin_dashboard_model.dart';
import '../repo/admin_suggestions_repo.dart';

class GetAdminSuggestionsUseCase {
  final AdminSuggestionsRepo _repo;
  GetAdminSuggestionsUseCase(this._repo);

  Future<Either<Failure, List<SuggestionModel>>> call() async {
    return await _repo.getSuggestions();
  }
}
