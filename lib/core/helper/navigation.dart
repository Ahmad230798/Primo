import 'package:flutter/material.dart';

extension Navigation on BuildContext {
  // التنقل العادي
  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  // استبدال الشاشة الحالية
  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return Navigator.of(
      this,
    ).pushReplacementNamed(routeName, arguments: arguments);
  }

  // تنظيف الـ Stack
  Future<dynamic> pushNamedAndRemoveUntil(
    String routeName, {
    Object? arguments,
    RoutePredicate? predicate,
  }) {
    return Navigator.of(this).pushNamedAndRemoveUntil(
      
      routeName,
      predicate ?? (route) => false,
      arguments: arguments,
    );
  }

  // العودة للخلف مع دعم التحقق
  void pop() {
    if (Navigator.of(this).canPop()) {
      Navigator.of(this).pop();
    }
  }

  // ميزة إضافية: التنقل مع التأكد من حذف المسارات السابقة حتى الوصول للمسار المطلوب
  Future<dynamic> pushNamedAndRemoveUntilRoute(
    String routeName,
    String untilRoute,
  ) {
    return Navigator.of(
      this,
    ).pushNamedAndRemoveUntil(routeName, ModalRoute.withName(untilRoute));
  }
}
