import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/notifications/data/models/notification_model.dart';
import 'package:primo/feature/notifications/data/models/notification_settings_model.dart';

abstract class NotificationSettingsRepo {
  Future<Either<Failure, NotificationSettingsModel>> getNotificationSettings();
  Future<Either<Failure, NotificationSettingsModel>> updateNotificationSettings(NotificationSettingsModel settings);
  Future<Either<Failure, List<NotificationModel>>> getNotifications();
}
