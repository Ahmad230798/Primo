import 'package:flutter/material.dart';

class AppColors {
  // --- الألوان الأساسية ---
  static const Color primary = Color(0xFFBB0013); // الأحمر الأساسي
  static const Color textMain = Color(
    0xFF1A1C1C,
  ); // اللون الداكن للنصوص الرئيسية
  static const Color white = Color(0xFFFFFFFF); // الأبيض

  // --- ألوان الخلفيات ---
  static const Color background = Color(
    0xFFF9F9F9,
  ); // لون الخلفية الفاتح (100%)
  // للون F9F9F9 بشفافية 80%، نستخدم 0xCC كبادئة (CC تمثل 80%)
  static const Color background80 = Color(0xCCF9F9F9);

  // --- تدرجات الرمادي (تستخدم للنصوص الفرعية، الأيقونات، الحدود) ---
  static const Color greyDark = Color(0xFF5A5C5D);
  static const Color greyMedium1 = Color(0xFF625D5C);
  static const Color greyMedium2 = Color(0xFF5D3F3C); // يميل للبني قليلاً
  static const Color greyMedium3 = Color(0xFF6B7280);
  static const Color greyLight = Color(
    0xFFCCC5C3,
  ); // لون ممتاز للحدود (Borders) أو الفواصل (Dividers)

  // --- ألوان مخصصة ---
  // هذا اللون الوردي/الرمادي الفاتح غالباً مستخدم كخلفية لعداد الكمية (+ 1 -)
  static const Color quantityBackground = Color(0xFFE6BDB8);
  static const Color greyBackground = Color(0xffF3F3F4);
  // --- اللون الشفاف ---
  // في الصورة يوجد لون 000000 بشفافية 0%، وهذا ببساطة يعني لون شفاف
  static const Color transparent = Colors.transparent;
  static const Color splashBackGround = Color(0xFF2F3131);
  static const Color formBorder = Color(0xFFE2E2E2);
  static const Color secondaryBorder = Color(0xFF916F6B);
}
