import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_consumer.dart';
import 'package:primo/core/network/api_constant.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/admin_settings/domain/repos/admin_dollar_repo.dart';

class AdminDollarRepoImpl implements AdminDollarRepo {
  final ApiConsumer _apiConsumer;

  AdminDollarRepoImpl(this._apiConsumer);

  @override
  Future<Either<Failure, num>> getDollarValue() async {
    try {
      final response = await _apiConsumer.get(path: ApiConstant.adminDollarValue);
      final data = response['data'] ?? response;
      if (data is Map<String, dynamic> && data.containsKey('dollar_value')) {
        final val = data['dollar_value'];
        if (val != null) {
          final parsed = num.tryParse(val.toString()) ?? 0;
          if (parsed > 0) return Right(parsed);
        }
      } else if (response is Map<String, dynamic> && response.containsKey('dollar_value')) {
        final val = response['dollar_value'];
        if (val != null) {
          final parsed = num.tryParse(val.toString()) ?? 0;
          if (parsed > 0) return Right(parsed);
        }
      }
      return Left(ServerFailure("فشل في جلب سعر الصرف"));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> updateDollarValue(num dollarValue) async {
    try {
      await _apiConsumer.post(
        path: ApiConstant.adminDollarValue,
        body: {
          '_method': 'PATCH',
          'dollar_value': dollarValue.toString(),
        },
      );
      return const Right(null);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: $e"));
    }
  }
}
