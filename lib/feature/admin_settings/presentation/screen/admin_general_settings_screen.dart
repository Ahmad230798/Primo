import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/di/service_locator.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_button.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import '../cubit/admin_general_settings_cubit.dart';
import '../cubit/admin_general_settings_state.dart';
import '../cubit/admin_dollar_cubit.dart';
import '../cubit/admin_dollar_state.dart';

class AdminGeneralSettingsScreen extends StatefulWidget {
  const AdminGeneralSettingsScreen({super.key});

  @override
  State<AdminGeneralSettingsScreen> createState() => _AdminGeneralSettingsScreenState();
}

class _AdminGeneralSettingsScreenState extends State<AdminGeneralSettingsScreen> {
  final _supportPhoneController = TextEditingController();
  final _managerPhoneController = TextEditingController();
  final _facebookController = TextEditingController();
  final _workingHoursController = TextEditingController();
  final _addressController = TextEditingController();
  final _dollarController = TextEditingController();

  bool _initialized = false;
  bool _dollarInitialized = false;

  @override
  void dispose() {
    _supportPhoneController.dispose();
    _managerPhoneController.dispose();
    _facebookController.dispose();
    _workingHoursController.dispose();
    _addressController.dispose();
    _dollarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminGeneralSettingsCubit(getIt())..getGeneralSettings(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: MultiBlocListener(
            listeners: [
              BlocListener<AdminGeneralSettingsCubit, AdminGeneralSettingsState>(
                listener: (context, state) {
                  if (state is AdminGeneralSettingsSuccess) {
                    context.showSuccess(state.message);
                  } else if (state is AdminGeneralSettingsError) {
                    context.showError(state.message);
                  } else if (state is AdminGeneralSettingsLoaded && !_initialized) {
                    final model = state.model;
                    _supportPhoneController.text = model.supportPhone;
                    _managerPhoneController.text = model.managerPhone;
                    _facebookController.text = model.facebookAccount;
                    _workingHoursController.text = model.workingHours;
                    _addressController.text = model.address;
                    _initialized = true;
                  }
                },
              ),
              BlocListener<AdminDollarCubit, AdminDollarState>(
                listener: (context, state) {
                  if (state is AdminDollarLoaded && !_dollarInitialized) {
                    _dollarController.text = state.dollarValue.toString();
                    _dollarInitialized = true;
                  } else if (state is AdminDollarUpdateSuccess) {
                    context.showSuccess(state.message);
                  } else if (state is AdminDollarError) {
                    context.showError(state.message);
                  }
                },
              ),
            ],
            child: BlocBuilder<AdminDollarCubit, AdminDollarState>(
              builder: (context, dollarState) {
                if (dollarState is AdminDollarLoaded && !_dollarInitialized) {
                  _dollarController.text = dollarState.dollarValue.toString();
                  _dollarInitialized = true;
                } else if (_dollarController.text.isEmpty && context.read<AdminDollarCubit>().currentDollarValue > 0) {
                  _dollarController.text = context.read<AdminDollarCubit>().currentDollarValue.toString();
                }

                return BlocConsumer<AdminGeneralSettingsCubit, AdminGeneralSettingsState>(
                  listener: (context, state) {},
            builder: (context, state) {
              if (state is AdminGeneralSettingsLoaded && !_initialized) {
                final model = state.model;
                _supportPhoneController.text = model.supportPhone;
                _managerPhoneController.text = model.managerPhone;
                _facebookController.text = model.facebookAccount;
                _workingHoursController.text = model.workingHours;
                _addressController.text = model.address;
                _initialized = true;
              }

              if (state is AdminGeneralSettingsLoading && !_initialized) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              final isUpdating = state is AdminGeneralSettingsUpdating;

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    child: CustomAppBar(
                      title: "الإعدادات العامة للدعم",
                      showRightIcon: false,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField(
                            controller: _dollarController,
                            label: "سعر صرف الدولار (ل.س / \$)",
                            hint: "130",
                            isNumber: true,
                            prefixIcon: const Icon(Icons.attach_money_rounded, color: AppColors.primary),
                          ),
                          16.verticalSpace,
                          _buildTextField(
                            controller: _supportPhoneController,
                            label: "هاتف خدمة العملاء",
                            hint: "+963 999 000 111",
                            isNumber: true,
                          ),
                          16.verticalSpace,
                          _buildTextField(
                            controller: _managerPhoneController,
                            label: "هاتف الإدارة والمتابعة",
                            hint: "+963 999 000 222",
                            isNumber: true,
                          ),
                          16.verticalSpace,
                          _buildTextField(
                            controller: _facebookController,
                            label: "حساب فيسبوك",
                            hint: "facebook.com/primomarket",
                            isLtr: true,
                            prefixIcon: const Icon(Icons.facebook, color: Color(0xFF1877F2)),
                          ),
                          16.verticalSpace,
                          _buildTextField(
                            controller: _workingHoursController,
                            label: "أوقات العمل الرسمي",
                            hint: "يومياً من 9 صباحاً حتى 10 مساءً",
                          ),
                          16.verticalSpace,
                          _buildTextField(
                            controller: _addressController,
                            label: "العنوان الرئيسي للمتجر",
                            hint: "دمشق، سوريا",
                          ),
                          32.verticalSpace,
                          AppButton(
                            text: "حفظ التغييرات",
                            isLoading: isUpdating,
                            onPressed: () {
                              context.read<AdminGeneralSettingsCubit>().updateGeneralSettings(
                                    supportPhone: _supportPhoneController.text.trim(),
                                    managerPhone: _managerPhoneController.text.trim(),
                                    facebookAccount: _facebookController.text.trim(),
                                    workingHours: _workingHoursController.text.trim(),
                                    address: _addressController.text.trim(),
                                  );
                              final dollarVal = num.tryParse(_dollarController.text.trim());
                              if (dollarVal != null && dollarVal > 0) {
                                context.read<AdminDollarCubit>().updateDollarValue(dollarVal);
                              }
                            },
                          ),
                          40.verticalSpace,
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    ),
  ),
        ),
      );
    }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool isNumber = false,
    bool isLtr = false,
    Widget? prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.font14.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textMain,
          ),
        ),
        8.verticalSpace,
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
          textDirection: (isNumber || isLtr) ? TextDirection.ltr : TextDirection.rtl,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon,
            hintStyle: AppTextStyle.font14.copyWith(color: AppColors.greyMedium2),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.formBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.formBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
            ),
            filled: true,
            fillColor: AppColors.white,
          ),
          style: AppTextStyle.font14.copyWith(color: AppColors.textMain),
        ),
      ],
    );
  }
}
