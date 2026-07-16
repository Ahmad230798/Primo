

import 'package:primo/feature/notifications/data/repos/notification_settings_repo_impl.dart';

class SaveLastSeenNotificationUseCase {
  final NotificationSettingsRepoImpl _repo;

  SaveLastSeenNotificationUseCase(this._repo);

  Future<void> call(int id) async {
    return await _repo.saveLastSeenNotificationId(id);
  }
}