import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

// تأكد من مسارات ملفات الـ Core الخاصة بك
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

extension SnackBarExtension on BuildContext {
  void showError(String message) {
    // استخدمنا لون أحمر أو يمكنك إضافة لون خاص بالأخطاء في AppColors
    _show(message, AppColors.primary);
  }

  void showSuccess(String message) {
    // لون أخضر للنجاح
    _show(message, AppColors.green);
  }

  void showInfo(String message) {
    // استخدم اللون الرئيسي للتطبيق للإشعارات العادية
    _show(message, AppColors.primary);
  }

  void _show(String message, Color color) {
    // 1. مسح أي إشعار سابق من الشاشة فوراً لمنع التراكم (تريك احترافي مهم جداً)
    ScaffoldMessenger.of(this).clearSnackBars();

    // 2. إظهار الإشعار الجديد
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          // استخدام خطوط التطبيق لضمان التناسق
          style: AppTextStyle.font14.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        // إضافة حواف دائرية تتناسب مع تصميم تطبيق Primo
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(16.w), // إبعاد الإشعار عن حواف الشاشة
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
