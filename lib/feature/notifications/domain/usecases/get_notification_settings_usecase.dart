import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/notifications/data/models/notification_settings_model.dart';
import 'package:primo/feature/notifications/domain/repos/notification_settings_repo.dart';

class GetNotificationSettingsUseCase {
  final NotificationSettingsRepo _repo;

  GetNotificationSettingsUseCase(this._repo);

  Future<Either<Failure, NotificationSettingsModel>> call() async {
    return await _repo.getNotificationSettings();
  }
}
