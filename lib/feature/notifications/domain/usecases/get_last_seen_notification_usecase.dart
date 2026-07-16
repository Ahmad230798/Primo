

import 'package:primo/feature/notifications/data/repos/notification_settings_repo_impl.dart';

class GetLastSeenNotificationUseCase {
  final NotificationSettingsRepoImpl _repo;

  GetLastSeenNotificationUseCase(this._repo);

  Future<int> call() async {
    return await _repo.getLastSeenNotificationId();
  }
}