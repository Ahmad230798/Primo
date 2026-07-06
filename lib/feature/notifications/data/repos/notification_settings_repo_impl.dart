import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_consumer.dart';
import 'package:primo/core/network/api_constant.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/notifications/data/models/notification_settings_model.dart';
import 'package:primo/feature/notifications/domain/repos/notification_settings_repo.dart';

class NotificationSettingsRepoImpl implements NotificationSettingsRepo {
  final ApiConsumer _apiConsumer;

  NotificationSettingsRepoImpl(this._apiConsumer);

  @override
  Future<Either<Failure, NotificationSettingsModel>> getNotificationSettings() async {
    try {
      final response = await _apiConsumer.get(path: ApiConstant.userNotifications);
      final data = response is Map<String, dynamic> && response.containsKey('data')
          ? response['data'] as Map<String, dynamic>
          : (response as Map<String, dynamic>? ?? {});
      return Right(NotificationSettingsModel.fromJson(data));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع أثناء جلب إعدادات الإشعارات: $e"));
    }
  }

  @override
  Future<Either<Failure, NotificationSettingsModel>> updateNotificationSettings(NotificationSettingsModel settings) async {
    try {
      final response = await _apiConsumer.patch(
        path: ApiConstant.userNotifications,
        body: settings.toJson(),
      );
      final data = response is Map<String, dynamic> && response.containsKey('data')
          ? response['data'] as Map<String, dynamic>
          : (response as Map<String, dynamic>? ?? settings.toJson());
      return Right(NotificationSettingsModel.fromJson(data));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع أثناء تحديث إعدادات الإشعارات: $e"));
    }
  }
}
