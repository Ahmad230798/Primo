import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/feature/notifications/presentation/cubit/notificatins_state.dart';
import '../../domain/usecases/get_notifications_usecase.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase _getNotificationsUseCase;

  NotificationsCubit(this._getNotificationsUseCase)
    : super(NotificationsInitial());

  Future<void> getNotifications() async {
    if (!isClosed) emit(NotificationsLoading());

    final result = await _getNotificationsUseCase.call();

    result.fold(
      (failure) {
        if (!isClosed) emit(NotificationsError(failure.errorMessage));
      },
      (notifications) {
        if (!isClosed) emit(NotificationsLoaded(notifications));
      },
    );
  }
}
