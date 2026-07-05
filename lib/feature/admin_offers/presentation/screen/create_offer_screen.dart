// كود شاشة CreateOfferScreen النهائي والجاهز للتشغيل
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/admin_drawer.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';

import '../cubit/admin_offers_cubit.dart';
import '../cubit/admin_offers_state.dart';
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

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AdminDrawer(currentRoute: Routes.adminOffers),
      body: SafeArea(
        child: BlocConsumer<AdminOffersCubit, AdminOffersState>(
          listenWhen: (prev, current) =>
              current is AdminOffersSuccess || current is AdminOffersError,
          listener: (context, state) {
            if (state is AdminOffersError) {
              context.showError(state.error);
            } else if (state is AdminOffersSuccess) {
              context.showSuccess("تم تفعيل العرض وإضافته بنجاح");
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Column(
                  children: [
                    _buildHeader(context),
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
                            140.verticalSpace, // مساحة للزر السفلي
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
                  child: state is AdminOffersLoading
                      ? Container(
                          color: AppColors.white,
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      // أزلنا كلمة const من هنا، وصححنا اسم الدالة
                      : OfferSubmitButton(onPressed: () => cubit.createOffer()),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // --- باقي الـ Helper Widgets كما هي ---
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.formBorder, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Navigator.pushNamed(context, Routes.notifications),
            borderRadius: BorderRadius.circular(99.r),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.textMain,
                size: 28,
              ),
            ),
          ),
          Text(
            "إدارة العروض والخصومات",
            style: AppTextStyle.font18.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Builder(
            builder: (innerContext) => InkWell(
              onTap: () => Scaffold.of(innerContext).openDrawer(),
              borderRadius: BorderRadius.circular(99.r),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: const Icon(
                  Icons.menu_rounded,
                  color: AppColors.textMain,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: AppTextStyle.font12.copyWith(
        color: AppColors.greyDark,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildDiscountField(AdminOffersCubit cubit) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
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
              // الشارة تتغير تلقائياً بناءً على نوع الخصم لتعطي شكلاً احترافياً (ر.س أو %)
              Text(
                cubit.isPercentage ? "%" : "ر.س",
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
