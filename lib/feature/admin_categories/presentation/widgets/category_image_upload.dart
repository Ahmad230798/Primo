// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'dart:ui';

import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/admin_category_cubit.dart';
import '../cubit/admin_category_state.dart';

class CategoryImageUpload extends StatelessWidget {
  const CategoryImageUpload({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCategoryCubit, AdminCategoryState>(
      builder: (context, state) {
        final cubit = context.read<AdminCategoryCubit>();
        final File? image = cubit.selectedImage;

        return InkWell(
          onTap: () {
            cubit.pickImage(); // استدعاء دالة اختيار الصورة
          },
          borderRadius: BorderRadius.circular(16.r),
          child: CustomPaint(
            foregroundPainter: DashedRectPainter(
              color: const Color(0xFFE6BDB8),
              strokeWidth: 1.5,
              radius: 16.r,
              dashPattern: const [8, 4],
            ),
            child: Container(
              width: double.infinity,
              height: 160.h, // تحديد ارتفاع ثابت للصندوق
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16.r),
                // إذا تم اختيار صورة، اجعلها خلفية للصندوق
                image: image != null
                    ? DecorationImage(
                        image: FileImage(image),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: image == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 64.w,
                          height: 64.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFDAD6).withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.photo_camera_rounded,
                              color: AppColors.primary,
                              size: 32.sp,
                            ),
                          ),
                        ),
                        16.verticalSpace,
                        Text(
                          "ارفع صورة القسم",
                          style: AppTextStyle.font16.copyWith(
                            color: AppColors.greyMedium2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        4.verticalSpace,
                        Text(
                          "PNG, JPG, GIF up to 5MB",
                          style: AppTextStyle.font12.copyWith(
                            color: AppColors.greyLight,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(), // إخفاء النصوص والأيقونة إذا تم اختيار صورة
            ),
          ),
        );
      },
    );
  }
}
// اترك الـ DashedRectPainter كما هو

// ---------------------------------------------------------
// كلاس مساعد لرسم الحدود المتقطعة (تم استخدامه سابقاً)
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

    final Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
      );

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
    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
