import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class ImageUploadWidget extends StatelessWidget {
  const ImageUploadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: فتح استوديو الصور (Image Picker)
      },
      borderRadius: BorderRadius.circular(16.r),
      child: CustomPaint(
        // استخدمنا foregroundPainter لضمان رسم الخطوط فوق الخلفية البيضاء
        foregroundPainter: DashedRectPainter(
          color: AppColors.greyLight,
          strokeWidth: 1.5,
          radius: 16.r,
          dashPattern: const [8, 4], // طول الخط 8، والفراغ 4
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 32.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                color: AppColors.greyMedium2,
                size: 40.sp,
              ),
              12.verticalSpace,
              Text(
                "اضغط هنا لرفع صور المنتج",
                style: AppTextStyle.font16.copyWith(
                  color: AppColors.greyMedium2,
                  fontWeight: FontWeight.w500,
                ),
              ),
              4.verticalSpace,
              Text(
                "الحد الأقصى 5 صور بصيغة JPG أو PNG",
                style: AppTextStyle.font12.copyWith(
                  color: AppColors.greyMedium3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// كلاس مساعد لرسم الحدود المتقطعة (Dashed Border) برمجياً
// ---------------------------------------------------------
class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;
  final List<double> dashPattern;

  DashedRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
    required this.dashPattern,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // إنشاء مسار (Path) بشكل المستطيل مع الحواف الدائرية
    final Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
      );

    // تقطيع المسار إلى خطوط وفراغات
    final Path dashedPath = Path();
    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double dash = dashPattern[0];
        final double space = dashPattern[1];
        dashedPath.addPath(
          metric.extractPath(distance, distance + dash),
          Offset.zero,
        );
        distance += dash + space;
      }
    }

    // رسم المسار المتقطع النهائي
    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
