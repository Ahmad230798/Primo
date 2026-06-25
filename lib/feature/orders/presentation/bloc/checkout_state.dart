import 'package:equatable/equatable.dart';

// استخدام sealed يغلق الكلاس ويجبر المترجم على التحقق من كل الحالات
sealed class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

// 1. الحالة الابتدائية
final class CheckoutInitial extends CheckoutState {}

// 2. حالة التحديث (يجب أن تحمل المتغيرات معها ليقارنها Equatable)
final class CheckoutUpdated extends CheckoutState {
  final int selectedDeliveryMethod;
  final String selectedAddressId;

  const CheckoutUpdated({
    required this.selectedDeliveryMethod,
    required this.selectedAddressId,
  });

  // هنا السحر: نخبر Equatable أن يقارن بناءً على هذه المتغيرات فقط
  @override
  List<Object?> get props => [selectedDeliveryMethod, selectedAddressId];
}

// 3. حالة التحميل
final class CheckoutLoading extends CheckoutState {}

// 4. حالة النجاح
final class CheckoutSuccess extends CheckoutState {}

// 5. حالة الخطأ (تحمل رسالة الخطأ معها)
final class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError(this.message);

  @override
  List<Object?> get props => [message];
}