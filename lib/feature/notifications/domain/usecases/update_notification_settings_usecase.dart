import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/notifications/data/models/notification_settings_model.dart';
import 'package:primo/feature/notifications/domain/repos/notification_settings_repo.dart';

class UpdateNotificationSettingsUseCase {
  final NotificationSettingsRepo _repo;

  UpdateNotificationSettingsUseCase(this._repo);

  Future<Either<Failure, NotificationSettingsModel>> call(NotificationSettingsModel settings) async {
    return await _repo.updateNotificationSettings(settings);
  }
}
