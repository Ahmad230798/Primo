import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/feature/notifications/domain/usecases/get_last_seen_notification_usecase.dart';
import 'package:primo/feature/notifications/domain/usecases/save_last_seen_notification_usecase.dart';
import 'package:primo/feature/notifications/presentation/cubit/notificatins_state.dart';
import '../../domain/usecases/get_notifications_usecase.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final GetLastSeenNotificationUseCase _getLastSeenUseCase;
  final SaveLastSeenNotificationUseCase _saveLastSeenUseCase;

  NotificationsCubit(
    this._getNotificationsUseCase,
    this._getLastSeenUseCase,
    this._saveLastSeenUseCase,
  ) : super(NotificationsInitial());
  bool hasUnreadNotifications = false;
  int _inMemoryLastSeenId = 0;
  Future<void> getNotifications() async {
    if (!isClosed) emit(NotificationsLoading());

    try {
      final result = await _getNotificationsUseCase.call();

      result.fold(
        (failure) {
          if (!isClosed) emit(NotificationsError(failure.errorMessage));
        },
        (notifications) async {
          if (notifications.isNotEmpty) {
            if (_inMemoryLastSeenId == 0) {
              _inMemoryLastSeenId = await _getLastSeenUseCase.call();
            }

            final int latestIdFromApi = notifications.first.id;
            hasUnreadNotifications = latestIdFromApi > _inMemoryLastSeenId;
          } else {
            hasUnreadNotifications = false;
          }

          if (!isClosed) emit(NotificationsLoaded(notifications));
        },
      );
    } catch (e) {
      if (!isClosed) emit(NotificationsError(e.toString()));
    }
  }

  // 💡 دالة تُستدعى عند فتح المستخدم لشاشة الإشعارات لإخفاء النقطة وحفظ الـ ID الجديد
  // دالة تُستدعى عند فتح المستخدم لشاشة الإشعارات لإخفاء النقطة وحفظ الـ ID الجديد
  Future<void> markAllAsRead() async {
    // 1. لا تفعل شيئاً إذا لم تكن هناك نقطة حمراء أصلاً
    if (!hasUnreadNotifications) return;

    // 2. تحديث المتغير فوراً لإخفاء النقطة
    hasUnreadNotifications = false; // إخفاء النقطة فوراً
    // 3. تحديث التخزين المحلي والواجهة
    if (state is NotificationsLoaded) {
      final notifications = (state as NotificationsLoaded).notifications;

      if (notifications.isNotEmpty) {
        _inMemoryLastSeenId = notifications.first.id;
        // حفظ أحدث رقم في التخزين المحلي
        await _saveLastSeenUseCase.call(_inMemoryLastSeenId);
      }

      // 💡 السر هنا: استخدام List.from لإنشاء قائمة جديدة في الذاكرة وإجبار الـ UI على التحديث
      if (!isClosed) {
        emit(NotificationsLoaded(List.from(notifications)));
      }
    } else {
      // 💡 احتياطياً: إذا تم النقر بينما الكيوبت في حالة أخرى، نجبره على التحديث بحالة مبدئية
      if (!isClosed) {
        emit(NotificationsInitial());
      }
    }
  }
}
