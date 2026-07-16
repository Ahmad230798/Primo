import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/core/models/order_model.dart';
// 💡 تم إزالة استدعاء AppStorage من هنا تماماً
import 'package:primo/feature/addresses/data/models/address_model.dart';
import 'package:primo/feature/orders/domain/usecases/confirm_order_usecase.dart';
import 'package:primo/feature/orders/domain/usecases/get_order_price_usecase.dart';
import 'package:primo/feature/orders/presentation/bloc/checkout_state.dart';
// 💡 استيراد الـ UseCases الجديدة (تأكد من تعديل المسار إذا كان مختلفاً لديك)
import 'package:primo/feature/addresses/domain/usecases/get_default_address_usecase.dart';
import 'package:primo/feature/addresses/domain/usecases/save_default_address_usecase.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final GetOrderPriceUseCase _getOrderPriceUseCase;
  final ConfirmOrderUseCase _confirmOrderUseCase;

  // 💡 حقن الـ UseCases الجديدة الخاصة بالعنوان الافتراضي
  final GetDefaultAddressUseCase _getDefaultAddressUseCase;
  final SaveDefaultAddressUseCase _saveDefaultAddressUseCase;

  CheckoutCubit(
    this._getOrderPriceUseCase,
    this._confirmOrderUseCase,
    this._getDefaultAddressUseCase,
    this._saveDefaultAddressUseCase,
  ) : super(CheckoutInitial());

  // 0 = توصيل للعنوان (is_delivery: 1), 1 = استلام من المتجر (is_delivery: 0)
  int selectedDeliveryMethod = 0;
  String? selectedAddressId;
  OrderPriceModel? currentPrice;

  double get subTotal => currentPrice?.itemPrice.toDouble() ?? 0.0;
  double get deliveryFee =>
      currentPrice?.deliveryPrice.toDouble() ??
      (selectedDeliveryMethod == 0 ? 0.0 : 0.0);
  double get total =>
      currentPrice?.totalPrice.toDouble() ?? (subTotal + deliveryFee);

  Future<void> initCheckout(String? defaultAddressId) async {
    selectedAddressId = defaultAddressId;
    await calculatePrice();
  }

  Future<void> calculatePrice() async {
    // إيقاف استدعاء الـ API إذا كان التوصيل للمنزل ولم يتم اختيار عنوان بعد لتفادي 0.00
    if (selectedDeliveryMethod == 0 &&
        (selectedAddressId == null || selectedAddressId!.isEmpty)) {
      currentPrice = null;
      emit(
        CheckoutUpdated(
          selectedDeliveryMethod: selectedDeliveryMethod,
          selectedAddressId: selectedAddressId,
          priceModel: null,
        ),
      );
      return;
    }

    emit(CheckoutPriceLoading());
    final isDeliveryParam = selectedDeliveryMethod == 0 ? 1 : 0;
    final result = await _getOrderPriceUseCase(
      isDeliveryParam,
      selectedAddressId,
    );

    result.fold(
      (failure) {
        emit(CheckoutError(failure.errorMessage));
        emit(
          CheckoutUpdated(
            selectedDeliveryMethod: selectedDeliveryMethod,
            selectedAddressId: selectedAddressId,
            priceModel: currentPrice,
          ),
        );
      },
      (priceModel) {
        currentPrice = priceModel;
        emit(
          CheckoutUpdated(
            selectedDeliveryMethod: selectedDeliveryMethod,
            selectedAddressId: selectedAddressId,
            priceModel: priceModel,
          ),
        );
      },
    );
  }

  void changeDeliveryMethod(int method) {
    if (selectedDeliveryMethod == method) return;
    selectedDeliveryMethod = method;
    calculatePrice();
  }

  // الدالة القديمة (فقط تغير العنوان محلياً وتحسب السعر)
  void changeAddress(String id) {
    if (selectedAddressId == id) return;
    selectedAddressId = id;
    calculatePrice();
  }

  // 💡 الدالة الجديدة (تُستدعى من الـ UI عند نقر المستخدم على العنوان)
  Future<void> changeAddressAndSaveDefault(String idStr, int idNum) async {
    changeAddress(idStr); // تحديث الـ UI وحساب السعر
    await _saveDefaultAddressUseCase.call(
      idNum,
    ); // حفظ العنوان في الذاكرة بأمان
  }

  Future<void> submitOrder() async {
    if (selectedDeliveryMethod == 0 &&
        (selectedAddressId == null || selectedAddressId!.isEmpty)) {
      emit(const CheckoutError("الرجاء اختيار عنوان التوصيل أولاً"));
      return;
    }

    emit(CheckoutLoading());
    final isDeliveryParam = selectedDeliveryMethod == 0 ? 1 : 0;
    final result = await _confirmOrderUseCase(
      isDeliveryParam,
      selectedAddressId,
    );

    result.fold(
      (failure) {
        emit(CheckoutError(failure.errorMessage));
        emit(
          CheckoutUpdated(
            selectedDeliveryMethod: selectedDeliveryMethod,
            selectedAddressId: selectedAddressId,
            priceModel: currentPrice,
          ),
        );
      },
      (order) {
        emit(CheckoutSuccess(order: order));
      },
    );
  }

  // 💡 دالة جلب العنوان الافتراضي (تُستدعى عند فتح الشاشة)
  Future<void> loadDefaultAddress(List<AddressModel> userAddresses) async {
    if (userAddresses.isEmpty) return;

    // 1. استخدام الـ UseCase بدلاً من AppStorage مباشرة
    final savedAddressId = await _getDefaultAddressUseCase.call();

    if (savedAddressId != null) {
      // 2. التحقق مما إذا كان العنوان المحفوظ لا يزال موجوداً
      final exists = userAddresses.any(
        (addr) => addr.id.toString() == savedAddressId.toString(),
      );

      if (exists) {
        changeAddress(savedAddressId.toString());
        return;
      }
    }

    // 3. احتياطياً: اختيار أول عنوان
    changeAddress(userAddresses.first.id.toString());
  }
}
