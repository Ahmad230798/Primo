// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final bool isUnread;

  const NotificationCard({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    this.isUnread = false, // افتراضياً مقروء
  });

  @override
  Widget build(BuildContext context) {
    // الألوان الديناميكية بناءً على حالة القراءة
    final bgColor = isUnread
        ? const Color(0xFFFEF2F2)
        : AppColors.white; // أحمر فاتح جداً أو أبيض
    final borderColor = isUnread
        ? AppColors.primary.withOpacity(0.1)
        : AppColors.formBorder;
    final iconBgColor = isUnread ? AppColors.white : AppColors.greyBackground;
    final iconColor = isUnread ? AppColors.primary : AppColors.textMain;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
        boxShadow: [
          if (!isUnread) // الظل يظهر فقط للبطاقات البيضاء كما في التصميم
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // النقطة الحمراء للإشعار غير المقروء (متموضعة في أقصى اليمين)
          if (isUnread)
            Positioned(
              right: -4.w,
              top: 16.h, // لضبط النقطة في المنتصف عمودياً بجانب الأيقونة
              child: Container(
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الأيقونة الدائرية (يمين)
              Container(
                width: 48.w,
                height: 48.w,
                margin: EdgeInsets.only(
                  right: isUnread ? 12.w : 0,
                ), // مساحة إضافية للنقطة الحمراء إن وجدت
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    if (isUnread) // توهج أحمر حول الأيقونة إذا كان غير مقروء
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Icon(icon, color: iconColor, size: 24.sp),
              ),
              16.horizontalSpace,

              // المحتوى النصي (يسار)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // العنوان والوقت
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: AppTextStyle.font14.copyWith(
                              color: AppColors.textMain,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        8.horizontalSpace,
                        Text(
                          time,
                          style: AppTextStyle.font12.copyWith(
                            color: AppColors.greyMedium3,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    4.verticalSpace,
                    // الوصف
                    Text(
                      description,
                      style: AppTextStyle.font14.copyWith(
                        color: AppColors.greyDark,
                        height: 1.4, // تباعد الأسطر المريح للقراءة
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
