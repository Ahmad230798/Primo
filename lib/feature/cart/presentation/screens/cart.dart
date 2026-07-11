import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/helper/navigation.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_button.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:primo/feature/cart/presentation/cubit/cart_state.dart';
import 'package:primo/feature/cart/presentation/widgets/cart_item_list.dart';

class Cart extends StatelessWidget {
  final bool isFromBottomNav;
  const Cart({super.key, required this.isFromBottomNav});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<CartCubit, CartState>(
          listener: (context, state) {
            if (state is CartLoaded && state.actionMessage != null) {
              context.showSuccess(state.actionMessage!);
            } else if (state is CartError) {
              context.showError(state.errorMessage);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: CustomAppBar(
                    title: "Primo",
                    suffixsIcon: isFromBottomNav ? const SizedBox() : null,
                    icon: Icon(
                      Icons.notifications_none,
                      color: AppColors.greyMedium1,
                    ),
                    onRightIconTap: () =>
                        context.pushNamed(Routes.notifications),
                  ),
                ),
                20.verticalSpace,
                Expanded(child: _buildBody(context, state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, CartState state) {
    if (state is CartLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is CartError &&
        context.read<CartCubit>().currentItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.errorMessage,
              style: AppTextStyle.font16.copyWith(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            16.verticalSpace,
            ElevatedButton(
              onPressed: () => context.read<CartCubit>().getCart(),
              child: const Text("إعادة المحاولة"),
            ),
          ],
        ),
      );
    }

    final cubit = context.read<CartCubit>();
    final items = cubit.currentItems;
    final totalPrice = cubit.calculateTotal(items);

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80.sp,
              color: AppColors.greyMedium2,
            ),
            16.verticalSpace,
            Text(
              "السلة فارغة حالياً",
              style: AppTextStyle.font20.copyWith(
                color: AppColors.greyMedium2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          Row(
            children: [
              Text("عربة التسوق", style: AppTextStyle.font20),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.formBorder,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  "${items.length} عناصر",
                  style: AppTextStyle.font14.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.greyMedium2,
                  ),
                ),
              ),
            ],
          ),
          16.verticalSpace,
          CartItemList(items: items),
          24.verticalSpace,
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.formBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "الإجمالي:",
                  style: AppTextStyle.font18.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMain,
                  ),
                ),
                Text(
                  "$totalPrice ل.س",
                  style: AppTextStyle.font20.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          24.verticalSpace,
          AppButton(
            text: "متابعة للدفع",
            icon: Icons.arrow_forward,
            onPressed: () {
              context.pushNamed(Routes.checkoutScreen);
            },
          ),
          32.verticalSpace,
        ],
      ),
    );
  }
}
