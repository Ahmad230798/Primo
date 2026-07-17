// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/feature/admin_settings/presentation/cubit/admin_dollar_cubit.dart';
import 'package:primo/feature/admin_settings/presentation/cubit/admin_dollar_state.dart';

class AdminDollarCard extends StatelessWidget {
  const AdminDollarCard({super.key});

  void _showEditDialog(BuildContext context, num currentValue) {
    final controller = TextEditingController(text: currentValue.toString());
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            "تعديل سعر الصرف (\$)",
            style: AppTextStyle.font18.copyWith(
              color: AppColors.textMain,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "أدخل سعر صرف الدولار الجديد بالليرة السورية:",
                style: AppTextStyle.font14.copyWith(color: AppColors.greyDark),
              ),
              12.verticalSpace,
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                textDirection: TextDirection.ltr,
                decoration: InputDecoration(
                  hintText: "130",
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.formBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  suffixText: "ل.س",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                "إلغاء",
                style: AppTextStyle.font14.copyWith(color: AppColors.greyDark),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final valStr = controller.text.trim();
                final val = num.tryParse(valStr);
                if (val == null || val <= 0) {
                  context.showError("الرجاء إدخال رقم صحيح أكبر من الصفر");
                  return;
                }
                Navigator.pop(dialogContext);
                context.read<AdminDollarCubit>().updateDollarValue(val);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                "حفظ التغييرات",
                style: AppTextStyle.font14.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminDollarCubit, AdminDollarState>(
      listener: (context, state) {
        if (state is AdminDollarUpdateSuccess) {
          context.showSuccess(state.message);
        } else if (state is AdminDollarError) {
          context.showError(state.message);
        }
      },
      builder: (context, state) {
        num value = context.read<AdminDollarCubit>().currentDollarValue;
        if (state is AdminDollarLoaded) {
          value = state.dollarValue;
        }

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2A2D34), Color(0xFF1F2228)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.currency_exchange_rounded,
                      color: AppColors.primary,
                      size: 26.sp,
                    ),
                  ),
                  12.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "سعر صرف الدولار الحالي",
                        style: AppTextStyle.font14.copyWith(
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      4.verticalSpace,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          if (state is AdminDollarLoading)
                            SizedBox(
                              width: 16.w,
                              height: 16.h,
                              child: const CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 2,
                              ),
                            )
                          else
                            Text(
                              "$value",
                              style: AppTextStyle.font24.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          4.horizontalSpace,
                          Text(
                            "ل.س / \$",
                            style: AppTextStyle.font12.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: () => _showEditDialog(context, value),
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit_rounded,
                        color: AppColors.white,
                        size: 16.sp,
                      ),
                      6.horizontalSpace,
                      Text(
                        "تعديل",
                        style: AppTextStyle.font14.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
