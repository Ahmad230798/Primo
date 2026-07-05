// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/models/order_model.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

enum StepStatus { completed, current, upcoming }

class TrackingStepData {
  final String title;
  final String description;
  final String? time;
  final StepStatus status;
  final IconData upcomingIcon;

  TrackingStepData({
    required this.title,
    required this.description,
    this.time,
    required this.status,
    required this.upcomingIcon,
  });
}

class OrderState extends StatelessWidget {
  final OrderModel? order;
  const OrderState({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    final status = order?.status.toLowerCase() ?? 'pending';
    
    int currentStepIndex = 0;
    if (status == 'processing') currentStepIndex = 1;
    if (status == 'shipping' || status == 'delivering') currentStepIndex = 2;
    if (status == 'completed' || status == 'delivered') currentStepIndex = 3;

    StepStatus getStatus(int index) {
      if (index < currentStepIndex) return StepStatus.completed;
      if (index == currentStepIndex) {
        return currentStepIndex == 3 ? StepStatus.completed : StepStatus.current;
      }
      return StepStatus.upcoming;
    }

    final List<TrackingStepData> steps = [
      TrackingStepData(
        title: "تم تأكيد الطلب",
        description: "تم استلام طلبك بنجاح وجاري معالجته.",
        time: order?.formattedDate,
        status: getStatus(0),
        upcomingIcon: Icons.check,
      ),
      TrackingStepData(
        title: "قيد التجهيز",
        description: "يقوم فريقنا بتجهيز وتغليف طلبك بعناية.",
        status: getStatus(1),
        upcomingIcon: Icons.inventory_2_outlined,
      ),
      TrackingStepData(
        title: order?.isDelivery == true
            ? "قيد التوصيل"
            : "جاهز للاستلام",
        description: order?.isDelivery == true
            ? "سيكون طلبك في طريقه إليك قريباً."
            : "طلبك جاهز في المتجر لاستلامه.",
        status: getStatus(2),
        upcomingIcon: Icons.local_shipping_outlined,
      ),
      TrackingStepData(
        title: order?.isDelivery == true ? "تم التسليم" : "تم الاستلام",
        description: "وصل الطلب إليك بنجاح.",
        status: getStatus(3),
        upcomingIcon: Icons.inventory_outlined,
      ),
    ];

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.formBorder),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: steps.length,
        itemBuilder: (context, index) {
          return _TrackingStepTile(
            data: steps[index],
            isLast: index == steps.length - 1,
          );
        },
      ),
    );
  }
}

class _TrackingStepTile extends StatelessWidget {
  final TrackingStepData data;
  final bool isLast;

  const _TrackingStepTile({required this.data, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              _buildNode(),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2.w,
                    color: data.status == StepStatus.completed
                        ? AppColors.primary
                        : AppColors.greyLight,
                  ),
                ),
            ],
          ),
          16.horizontalSpace,
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 32.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: AppTextStyle.font18.copyWith(
                      fontWeight: FontWeight.bold,
                      color: data.status == StepStatus.upcoming
                          ? AppColors.greyLight
                          : (data.status == StepStatus.current
                              ? AppColors.primary
                              : AppColors.textMain),
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    data.description,
                    style: AppTextStyle.font14.copyWith(
                      color: data.status == StepStatus.upcoming
                          ? AppColors.greyLight
                          : AppColors.greyMedium3,
                    ),
                  ),
                  if (data.time != null) ...[
                    4.verticalSpace,
                    Text(
                      data.time!,
                      style: AppTextStyle.font14.copyWith(
                        fontWeight: FontWeight.bold,
                        color: data.status == StepStatus.current
                            ? AppColors.primary
                            : AppColors.greyMedium3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNode() {
    switch (data.status) {
      case StepStatus.completed:
        return Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(Icons.check, color: AppColors.white, size: 24.sp),
        );

      case StepStatus.current:
        return Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.15),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );

      case StepStatus.upcoming:
        return Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: AppColors.greyBackground,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.greyLight),
          ),
          child: Icon(
            data.upcomingIcon,
            color: AppColors.greyLight,
            size: 20.sp,
          ),
        );
    }
  }
}
