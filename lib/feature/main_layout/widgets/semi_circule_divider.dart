import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class SemiCircleDividerPainter extends CustomPainter {
  final double animationValue;

  SemiCircleDividerPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
          .withValues(alpha: 0.3) // لون الخط الفاصل وشفافيته
      ..strokeWidth = 1.2
          .w // سماكة الخط
      ..style = PaintingStyle.stroke;

    // نقطة البداية (المركز في أسفل المنتصف)
    final Offset center = Offset(size.width / 2, size.height);
    final double radius = size.height; // نصف القطر الافتراضي يساوي الارتفاع

    // الزوايا الوسطية بين العناصر الأربعة تماماً
    final List<double> dividerAngles = [
      math.pi * 0.74, // بين الباقات والخدمات الخاصة
      math.pi * 0.50, // في المنتصف تماماً (زاوية 90) بين الخدمات الخاصة والعروض
      math.pi * 0.26, // بين العروض والخدمات العامة
    ];

    for (var angle in dividerAngles) {
      // حساب نقطة النهاية لكل خط مع مراعاة قيمة الأنميشن ليتمدد الخط بشكل سلس
      final double currentRadius = radius * animationValue;
      final double x = center.dx + currentRadius * math.cos(angle);
      final double y = center.dy - currentRadius * math.sin(angle);

      canvas.drawLine(center, Offset(x, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant SemiCircleDividerPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
