// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';

import '../cubit/admin_offers_cubit.dart';
import '../cubit/admin_offers_state.dart';
import '../cubit/admin_offers_list_cubit.dart';
import '../widgets/calculation_card.dart';
import '../widgets/offer_type_toggle.dart';
import '../widgets/offer_product_dropdown.dart';
import '../widgets/offer_date_selection.dart';
import '../widgets/offer_submit_button.dart';

class CreateOfferScreen extends StatelessWidget {
  const CreateOfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AdminOffersCubit>();
    final isEditing = cubit.editingOfferId != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<AdminOffersCubit, AdminOffersState>(
          listenWhen: (prev, current) =>
              current is AdminOffersSuccess || current is AdminOffersError,
          listener: (context, state) {
            if (state is AdminOffersError) {
              context.showError(state.error);
            } else if (state is AdminOffersSuccess) {
              context.showSuccess(
                isEditing
                    ? "تم تعديل العرض بنجاح"
                    : "تم تفعيل العرض وإضافته بنجاح",
              );
              try {
                context.read<AdminOffersListCubit>().getOffers();
              } catch (_) {}
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Column(
                  children: [
                    _buildHeader(context, isEditing),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            24.verticalSpace,
                            const OfferProductDropdown(),
                            24.verticalSpace,

                            _buildSectionLabel("نوع الخصم"),
                            8.verticalSpace,
                            const OfferTypeToggle(),
                            24.verticalSpace,

                            _buildSectionLabel("قيمة الخصم"),
                            8.verticalSpace,
                            _buildDiscountField(cubit),
                            24.verticalSpace,

                            const OfferDateSelection(),
                            24.verticalSpace,

                            const CalculationCard(),
                            100.verticalSpace,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: BlocBuilder<AdminOffersCubit, AdminOffersState>(
                    builder: (context, state) {
                      final isLoading = state is AdminOffersLoading;
                      return OfferSubmitButton(
                        text: isEditing ? "حفظ التعديلات" : "تفعيل العرض",
                        onPressed: (){
                                if (isEditing) {
                                  cubit.updateOffer();
                                } else {
                                  cubit.createOffer();
                                }
                              }, isLoading: isLoading,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isEditing) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(99.r),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textMain,
                size: 24.sp,
              ),
            ),
          ),
          12.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? "تعديل العرض" : "إنشاء عرض جديد",
                style: AppTextStyle.font20.copyWith(
                  color: AppColors.textMain,
                  fontWeight: FontWeight.bold,
                ),
              ),
              2.verticalSpace,
              Text(
                isEditing
                    ? "تعديل إعدادات العرض وتواريخه"
                    : "قم بتعريف خصم جديد وربطه بالمنتجات",
                style: AppTextStyle.font12.copyWith(
                  color: AppColors.greyMedium3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String title) {
    return Text(
      title,
      style: AppTextStyle.font16.copyWith(
        color: AppColors.textMain,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDiscountField(AdminOffersCubit cubit) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: cubit.discountController,
        keyboardType: TextInputType.number,
        textDirection: TextDirection.ltr,
        onChanged: (val) => cubit.onDiscountInputChanged(),
        decoration: InputDecoration(
          hintText: "أدخل قيمة الخصم",
          hintStyle: AppTextStyle.font14.copyWith(color: AppColors.greyMedium3),
          filled: true,
          fillColor: AppColors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          suffixIcon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                cubit.isPercentage
                    ? "%"
                    : (cubit.selectedVariant?.isDollar == true ? "\$" : "ل.س"),
                style: AppTextStyle.font16.copyWith(
                  color: AppColors.greyDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
