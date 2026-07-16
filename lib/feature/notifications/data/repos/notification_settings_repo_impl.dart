import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_consumer.dart';
import 'package:primo/core/network/api_constant.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/core/network/app_storage.dart';
import 'package:primo/feature/notifications/data/models/notification_model.dart';
import 'package:primo/feature/notifications/data/models/notification_settings_model.dart';
import 'package:primo/feature/notifications/domain/repos/notification_settings_repo.dart';

class NotificationSettingsRepoImpl implements NotificationSettingsRepo {
  final ApiConsumer _apiConsumer;

  NotificationSettingsRepoImpl(this._apiConsumer);

  @override
  Future<Either<Failure, NotificationSettingsModel>>
  getNotificationSettings() async {
    try {
      final response = await _apiConsumer.get(
        path: ApiConstant.userNotifications,
      );
      final data =
          response is Map<String, dynamic> && response.containsKey('data')
          ? response['data'] as Map<String, dynamic>
          : (response as Map<String, dynamic>? ?? {});
      return Right(NotificationSettingsModel.fromJson(data));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(
        ServerFailure("حدث خطأ غير متوقع أثناء جلب إعدادات الإشعارات: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, NotificationSettingsModel>> updateNotificationSettings(
    NotificationSettingsModel settings,
  ) async {
    try {
      final response = await _apiConsumer.patch(
        path: ApiConstant.userNotifications,
        body: settings.toJson(),
      );
      final data =
          response is Map<String, dynamic> && response.containsKey('data')
          ? response['data'] as Map<String, dynamic>
          : (response as Map<String, dynamic>? ?? settings.toJson());
      return Right(NotificationSettingsModel.fromJson(data));
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(
        ServerFailure("حدث خطأ غير متوقع أثناء تحديث إعدادات الإشعارات: $e"),
      );
    }
  }

  List<NotificationModel> _parseNotifications(dynamic responseData) {
    final list = responseData is List
        ? responseData
        : (responseData['data'] as List? ?? []);
    return list
        .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Either<Failure, List<NotificationModel>>> getNotifications() async {
    try {
      // 1. جلب البيانات من السيرفر
      final response = await _apiConsumer.get(path: ApiConstant.notifications);

      // 💡 2. الحل هنا: تمرير البيانات مباشرة لدالة التحليل بدون استخدام compute
      final list = _parseNotifications(response);

      return Right(list);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure("حدث خطأ في جلب الإشعارات: $e"));
    }
  }
  @override
  Future<void> saveLastSeenNotificationId(int id) async {
    await AppStorage.saveLastSeenNotificationId(id);
  }

  @override
  Future<int> getLastSeenNotificationId() async {
    return await AppStorage.getLastSeenNotificationId();
  }
}
