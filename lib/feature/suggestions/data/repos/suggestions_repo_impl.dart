import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_consumer.dart';
import 'package:primo/core/network/api_constant.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/suggestions/domain/repos/suggestions_repo.dart';

class SuggestionsRepoImpl implements SuggestionsRepo {
  final ApiConsumer _apiConsumer;

  SuggestionsRepoImpl(this._apiConsumer);

  @override
  Future<Either<Failure, String>> sendSuggestion({
    required String name,
    required String description,
  }) async {
    try {
      final response = await _apiConsumer.post(
        path: ApiConstant.userSuggestions,
        body: {
          'name': name,
          'description': description,
        },
      );
      final msg = response is Map<String, dynamic>
          ? (response['message']?.toString() ?? "تم إرسال اقتراحك بنجاح")
          : "تم إرسال اقتراحك بنجاح";
      return Right(msg);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع أثناء إرسال الاقتراح: $e"));
    }
  }
}
