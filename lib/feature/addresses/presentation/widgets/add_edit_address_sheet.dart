import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/helper/navigation.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_button.dart';
import 'package:primo/feature/addresses/data/models/address_model.dart';
import 'package:primo/feature/addresses/presentation/screen/map_picker_screen.dart';
import '../bloc/adresses_cubit.dart';
import '../bloc/adresses_state.dart';

class AddEditAddressSheet extends StatefulWidget {
  final AddressModel? address;

  const AddEditAddressSheet({super.key, this.address});

  @override
  State<AddEditAddressSheet> createState() => _AddEditAddressSheetState();
}

class _AddEditAddressSheetState extends State<AddEditAddressSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _latController;
  late TextEditingController _lngController;
  bool _isLocationSelected = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.address?.name ?? '');
    _descController = TextEditingController(
      text: widget.address?.description ?? '',
    );
    final initialLat = widget.address?.locationLat?.isNotEmpty == true
        ? widget.address!.locationLat!
        : '24.7136';
    final initialLng = widget.address?.locationLng?.isNotEmpty == true
        ? widget.address!.locationLng!
        : '46.6753';
    _latController = TextEditingController(text: initialLat);
    _lngController = TextEditingController(text: initialLng);
    _isLocationSelected =
        widget.address?.locationLat?.isNotEmpty == true &&
        widget.address?.locationLng?.isNotEmpty == true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_isLocationSelected) {
      context.pop();
      context.showError("الرجاء تحديد الموقع على الخريطة أولاً");
      return;
    }
    if (_formKey.currentState!.validate()) {
      final cubit = context.read<AddressesCubit>();
      if (widget.address != null && widget.address!.id != null) {
        cubit.updateAddress(
          id: widget.address!.id!,
          name: _nameController.text.trim(),
          description: _descController.text.trim(),
          locationLat: _latController.text.trim(),
          locationLng: _lngController.text.trim(),
        );
      } else {
        cubit.createAddress(
          name: _nameController.text.trim(),
          description: _descController.text.trim(),
          locationLat: _latController.text.trim(),
          locationLng: _lngController.text.trim(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.address != null;
    return BlocConsumer<AddressesCubit, AddressesState>(
      listener: (context, state) {
        if (state is AddressActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else if (state is AddressActionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AddressActionLoading;
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 24.w,
              right: 24.w,
              top: 24.h,
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isEditing ? "تعديل العنوان" : "إضافة عنوان جديد",
                          style: AppTextStyle.font20.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    16.verticalSpace,
                    Text(
                      "اسم العنوان (مثل: المنزل، العمل)",
                      style: AppTextStyle.font14.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    8.verticalSpace,
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: "المنزل",
                        filled: true,
                        fillColor: AppColors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(
                            color: AppColors.formBorder,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(
                            color: AppColors.formBorder,
                          ),
                        ),
                      ),
                      validator: (val) => val == null || val.trim().isEmpty
                          ? "الرجاء إدخال اسم العنوان"
                          : null,
                    ),
                    16.verticalSpace,
                    Text(
                      "تفاصيل العنوان (الشارع، الحي، رقم المبنى)",
                      style: AppTextStyle.font14.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    8.verticalSpace,
                    TextFormField(
                      controller: _descController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "شارع الملك فهد، حي العليا...",
                        filled: true,
                        fillColor: AppColors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(
                            color: AppColors.formBorder,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(
                            color: AppColors.formBorder,
                          ),
                        ),
                      ),
                      validator: (val) => val == null || val.trim().isEmpty
                          ? "الرجاء إدخال تفاصيل العنوان"
                          : null,
                    ),
                    16.verticalSpace,
                    Text(
                      "موقع العنوان على الخريطة (إجباري)",
                      style: AppTextStyle.font14.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    8.verticalSpace,
                    InkWell(
                      onTap: () async {
                        final selectedLatLng = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MapPickerScreen(
                              initialLat:
                                  double.tryParse(_latController.text) ??
                                  24.7136,
                              initialLng:
                                  double.tryParse(_lngController.text) ??
                                  46.6753,
                            ),
                          ),
                        );
                        if (selectedLatLng != null) {
                          setState(() {
                            _latController.text = selectedLatLng.latitude
                                .toString();
                            _lngController.text = selectedLatLng.longitude
                                .toString();
                            _isLocationSelected = true;
                          });
                        }
                      },
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          color: _isLocationSelected
                              ? AppColors.white
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: _isLocationSelected
                                ? Colors.green
                                : AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isLocationSelected
                                  ? Icons.location_on
                                  : Icons.map_outlined,
                              color: _isLocationSelected
                                  ? Colors.green
                                  : AppColors.primary,
                              size: 26.sp,
                            ),
                            12.horizontalSpace,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _isLocationSelected
                                        ? "تم تحديد الموقع على الخريطة بنجاح"
                                        : "اضغط لتحديد الموقع على الخريطة",
                                    style: AppTextStyle.font14.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: _isLocationSelected
                                          ? Colors.green.shade800
                                          : AppColors.textMain,
                                    ),
                                  ),
                                  4.verticalSpace,
                                  Text(
                                    _isLocationSelected
                                        ? "Lat: ${_latController.text.substring(0, _latController.text.length.clamp(0, 8))} , Lng: ${_lngController.text.substring(0, _lngController.text.length.clamp(0, 8))}"
                                        : "لا تقم بكتابة الإحداثيات يدوياً، استخدم الخريطة التفاعلية",
                                    style: AppTextStyle.font12.copyWith(
                                      color: AppColors.greyMedium3,
                                    ),
                                    textDirection: TextDirection.ltr,
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: _isLocationSelected
                                  ? Colors.green
                                  : AppColors.primary,
                              size: 16.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                    24.verticalSpace,
                    AppButton(
                      text: isEditing ? "حفظ التعديلات" : "إضافة العنوان",
                      isLoading: isLoading,
                      onPressed: isLoading ? null : _submit,
                    ),
                    24.verticalSpace,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
