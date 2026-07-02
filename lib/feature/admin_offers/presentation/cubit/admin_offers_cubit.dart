import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/models/create_offer_request_body.dart';
import '../../domain/usecases/create_offer_usecase.dart';
import 'admin_offers_state.dart';

class AdminOffersCubit extends Cubit<AdminOffersState> {
  final CreateOfferUseCase _createOfferUseCase;

  AdminOffersCubit(this._createOfferUseCase) : super(AdminOffersInitial());

  final TextEditingController discountController = TextEditingController();
  String selectedVariantId = "1"; // مؤقت للتجربة
  bool isPercentage = true;

  DateTime? startDate;
  DateTime? endDate;

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  // 1. تصحيح أسماء الـ Getters لتطابق ملف offer_date_selection
  String get startDateText =>
      startDate != null ? _dateFormat.format(startDate!) : "mm/dd/yyyy";
  String get endDateText =>
      endDate != null ? _dateFormat.format(endDate!) : "mm/dd/yyyy";

  void changeOfferType(bool percentage) {
    isPercentage = percentage;
    _emitUIChange();
  }

  void setStartDate(DateTime date) {
    startDate = date;
    _emitUIChange();
  }

  void setEndDate(DateTime date) {
    endDate = date;
    _emitUIChange();
  }

  void _emitUIChange() {
    emit(
      AdminOffersUIChanged(
        isPercentage: isPercentage,
        fromDate: startDateText,
        toDate: endDateText,
      ),
    );
  }

  // 2. توحيد اسم دالة الإرسال مع الشاشة (createOffer)
  void createOffer() async {
    if (discountController.text.trim().isEmpty) {
      emit(const AdminOffersError("حقل قيمة الخصم مطلوب"));
      return;
    }
    if (startDate == null || endDate == null) {
      emit(const AdminOffersError("يرجى تحديد تواريخ العرض كاملة"));
      return;
    }

    emit(AdminOffersLoading());

    // 3. تصحيح أسماء المتغيرات (fromDate و toDate) لتطابق ملف المودل
    final body = CreateOfferRequestBody(
      variantId: selectedVariantId,
      fromDate: startDateText,
      toDate: endDateText,
      discountPercentage: isPercentage ? discountController.text.trim() : null,
      discountValue: !isPercentage ? discountController.text.trim() : null,
    );

    final response = await _createOfferUseCase.execute(body);

    response.fold((failure) => emit(AdminOffersError(failure.errorMessage)), (
      success,
    ) {
      _resetForm();
      emit(AdminOffersSuccess(success.message ?? "تم إضافة العرض بنجاح"));
    });
  }

  void _resetForm() {
    discountController.clear();
    startDate = null;
    endDate = null;
    isPercentage = true;
  }

  @override
  Future<void> close() {
    discountController.dispose();
    return super.close();
  }
}
