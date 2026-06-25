import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/feature/orders/presentation/bloc/checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  // ==========================================
  // 1. المتغيرات الحالية (State Variables)
  // ==========================================

  // 0 = توصيل للعنوان, 1 = استلام من المتجر (القيمة الافتراضية توصيل)
  int selectedDeliveryMethod = 0;

  // معرف العنوان الافتراضي (سيتم جلبه لاحقاً من API العناوين)
  String selectedAddressId = "1";

  // (هذه القيمة ستأتي لاحقاً من CartBloc، نضعها هنا مؤقتاً للتجربة)
  final double subTotal = 245.00;

  // ==========================================
  // 2. العمليات الحسابية (Getters)
  // ==========================================

  // رسوم التوصيل تتغير تلقائياً بناءً على طريقة الاستلام المختارة
  double get deliveryFee => selectedDeliveryMethod == 0 ? 15.00 : 0.00;

  // الإجمالي يحسب نفسه تلقائياً
  double get total => subTotal + deliveryFee;

  // ==========================================
  // 3. دوال تحديث الواجهة (Events/Actions)
  // ==========================================

  /// تغيير طريقة الاستلام
  void changeDeliveryMethod(int method) {
    // إذا ضغط المستخدم على نفس الطريقة المحددة مسبقاً، لا تفعل شيئاً (توفير للأداء)
    if (selectedDeliveryMethod == method) return;

    selectedDeliveryMethod = method;

    // إصدار حالة التحديث مع القيم الجديدة لكي يكتشفها Equatable ويعيد رسم الشاشة
    emit(
      CheckoutUpdated(
        selectedDeliveryMethod: selectedDeliveryMethod,
        selectedAddressId: selectedAddressId,
      ),
    );
  }

  /// تغيير عنوان التوصيل
  void changeAddress(String id) {
    if (selectedAddressId == id) return;

    selectedAddressId = id;

    emit(
      CheckoutUpdated(
        selectedDeliveryMethod: selectedDeliveryMethod,
        selectedAddressId: selectedAddressId,
      ),
    );
  }

  // ==========================================
  // 4. دوال إرسال البيانات (API Calls)
  // ==========================================

  /// إرسال الطلب النهائي
  Future<void> submitOrder() async {
    // 1. إظهار مؤشر التحميل في الواجهة
    emit(CheckoutLoading());

    try {
      // 2. محاكاة الاتصال بالسيرفر (انتظار ثانيتين)
      // TODO: استدعاء الـ Repository لإرسال بيانات الطلب الفعلية لاحقاً
      await Future.delayed(const Duration(seconds: 2));

      // 3. إذا نجح الطلب
      emit(CheckoutSuccess());
    } catch (e) {
      // 4. إذا حدث خطأ (انقطاع إنترنت مثلاً)
      emit(
        const CheckoutError(
          "حدث خطأ أثناء تأكيد الطلب، يرجى المحاولة مرة أخرى.",
        ),
      );
    }
  }
}
