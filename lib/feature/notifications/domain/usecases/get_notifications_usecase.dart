import 'package:dartz/dartz.dart';
import 'package:primo/core/network/api_error_handler.dart';
import 'package:primo/feature/notifications/data/repos/notification_settings_repo_impl.dart';
import '../../data/models/notification_model.dart';

class GetNotificationsUseCase {
  final NotificationSettingsRepoImpl _repo;

  GetNotificationsUseCase(this._repo);

  Future<Either<Failure, List<NotificationModel>>> call() async {
    return await _repo.getNotifications();
  }
}
