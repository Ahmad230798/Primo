// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
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
  OrderState({super.key});

  // بيانات وهمية مطابقة للصورة لتجربة الواجهة
  final List<TrackingStepData> steps = [
    TrackingStepData(
      title: "تم تأكيد الطلب",
      description: "تم استلام طلبك بنجاح وجاري معالجته.",
      time: "10:35 ص",
      status: StepStatus.completed,
      upcomingIcon: Icons.check, // لن تظهر لأن الحالة مكتملة
    ),
    TrackingStepData(
      title: "قيد التجهيز",
      description: "يقوم فريقنا بتجهيز وتغليف طلبك بعناية.",
      time: "الآن",
      status: StepStatus.current,
      upcomingIcon: Icons.inventory_2_outlined,
    ),
    TrackingStepData(
      title: "قيد التوصيل / جاهز للاستلام",
      description: "سيكون طلبك في طريقه إليك قريباً.",
      status: StepStatus.upcoming,
      upcomingIcon: Icons.local_shipping_outlined,
    ),
    TrackingStepData(
      title: "تم التسليم",
      description: "وصل الطلب إليك بنجاح.",
      status: StepStatus.upcoming,
      upcomingIcon: Icons.inventory_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
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

// --- الويدجت المخصص لكل خطوة (Timeline Node) ---
class _TrackingStepTile extends StatelessWidget {
  final TrackingStepData data;
  final bool isLast;

  const _TrackingStepTile({required this.data, required this.isLast});

  @override
  Widget build(BuildContext context) {
    // IntrinsicHeight يضمن أن الخط العمودي يأخذ نفس ارتفاع النصوص تماماً
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.stretch, // لتمديد الأعمدة داخلياً
        children: [
          // 1. القسم الأيمن: الدائرة والخط العمودي
          Column(
            children: [
              _buildNode(),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2.w,
                    // لون الخط يعتمد على حالة الخطوة الحالية
                    color: data.status == StepStatus.completed
                        ? AppColors
                              .primary // أحمر داكن
                        : AppColors.greyLight,
                  ),
                ),
            ],
          ),
          16.horizontalSpace,

          // 2. القسم الأيسر: النصوص
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 32.h,
              ), // مسافة بين كل خطوة والتي تليها
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: AppTextStyle.font18.copyWith(
                      // عدل الخط حسب AppTextStyle لديك
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

  // --- دالة مساعدة لرسم الدائرة حسب الحالة ---
  Widget _buildNode() {
    switch (data.status) {
      case StepStatus.completed:
        return Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: AppColors.primary, // أحمر
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
            color: AppColors.greyBackground, // رمادي فاتح جداً
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
