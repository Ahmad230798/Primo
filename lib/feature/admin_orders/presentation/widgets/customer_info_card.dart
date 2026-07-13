// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/models/order_model.dart';

class CustomerInfoCard extends StatelessWidget {
  final OrderModel? order;
  const CustomerInfoCard({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    final fullName = order?.user?.name ??
        order?.address?.name ??
        "عميل بريمو #${order?.userId ?? ''}";
    final phone =
        order?.user?.phone ?? order?.address?.phone ?? "غير متوفر";
    final addressLine = order?.address != null
        ? ((order?.address?.description?.isNotEmpty == true)
            ? order!.address!.description!
            : (order?.address?.name ?? "عنوان غير متوفر"))
        : "عنوان غير متوفر";
    final isDelivery = order?.isDelivery ?? true;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.formBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان والشارة (توصيل للعنوان)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "بيانات العميل",
                style: AppTextStyle.font16.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.greyBackground,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      isDelivery
                          ? Icons.local_shipping_outlined
                          : Icons.storefront_outlined,
                      size: 16.sp,
                      color: AppColors.textMain,
                    ),
                    4.horizontalSpace,
                    Text(
                      isDelivery ? "توصيل للعنوان" : "استلام من الفرع",
                      style: AppTextStyle.font12.copyWith(
                        color: AppColors.textMain,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          16.verticalSpace,

          // الاسم
          _buildInfoRow(
            Icons.person_outline_rounded,
            fullName,
            isLink: false,
          ),
          8.verticalSpace,
          Divider(color: AppColors.formBorder, height: 1),
          8.verticalSpace,

          // رقم الهاتف (بلون أحمر)
          _buildInfoRow(Icons.call_outlined, phone, isLink: true),
          8.verticalSpace,
          Divider(color: AppColors.formBorder, height: 1),
          8.verticalSpace,

          // العنوان
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 20.sp,
                color: AppColors.greyDark,
              ),
              8.horizontalSpace,
              Expanded(
                child: Text(
                  addressLine,
                  style: AppTextStyle.font14.copyWith(
                    color: AppColors.greyMedium3,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {required bool isLink}) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: AppColors.greyDark),
        8.horizontalSpace,
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.font14.copyWith(
              color: isLink ? AppColors.primary : AppColors.textMain,
              fontWeight: isLink ? FontWeight.bold : FontWeight.w500,
            ),
            textDirection: isLink ? TextDirection.ltr : null,
          ),
        ),
      ],
    );
  }
}
