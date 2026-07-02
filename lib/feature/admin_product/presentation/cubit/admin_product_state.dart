import 'package:equatable/equatable.dart';

sealed class AdminProductState extends Equatable {
  const AdminProductState();
  @override
  List<Object?> get props => [];
}

final class AdminProductInitial extends AdminProductState {}

final class AdminProductLoading extends AdminProductState {}

final class AdminProductSuccess extends AdminProductState {
  final String message;
  const AdminProductSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

final class AdminProductError extends AdminProductState {
  final String error;
  const AdminProductError(this.error);
  @override
  List<Object?> get props => [error];
}

// لتحديث الواجهة عند إضافة/حذف نوع، أو اختيار صورة، أو جلب الأقسام
final class AdminProductUIChanged extends AdminProductState {
  final int timestamp; // لضمان إجبار الـ UI على التحديث
  const AdminProductUIChanged(this.timestamp);
  @override
  List<Object?> get props => [timestamp];
}
