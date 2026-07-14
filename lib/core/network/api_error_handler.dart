// ignore_for_file: unreachable_switch_default
import 'dart:io';
import 'package:dio/dio.dart';

abstract class Failure {
  final String errorMessage;
  const Failure(this.errorMessage);
}

class ServerFailure extends Failure {
  const ServerFailure(super.errorMessage);
  factory ServerFailure.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const ServerFailure("لا يوجد اتصال بالإنترنت");
      case DioExceptionType.badCertificate:
        return const ServerFailure("شهادة خادم غير صالحة");
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          dioError.response?.statusCode,
          dioError.response?.data,
        );
      case DioExceptionType.cancel:
        return const ServerFailure("تم إلغاء الطلب");
      case DioExceptionType.unknown:
        if (dioError.error is SocketException) {
          return const ServerFailure("لا يوجد اتصال بالإنترنت");
        }
        return const ServerFailure("لا يوجد اتصال بالإنترنت");
      default:
        return const ServerFailure(
          "Unexpected error occurred. Please try again",
        );
    }
  }
  factory ServerFailure.fromResponse(int? statusCode, dynamic responseData) {
    // تم التحديث لاستخدام صائد أخطاء Laravel
    final String extractedMessage = _extractLaravelError(responseData);

    switch (statusCode) {
      case 400: // Bad Request
        return ServerFailure(extractedMessage);
      case 401: // Unauthorized
        final serverMessage = (responseData is Map)
            ? responseData['message']
            : null;

        // 2. إرجاع ServerFailure بدلاً من Failure المجرد
        return ServerFailure(
          serverMessage?.toString() ?? "انتهت جلسة تسجيل الدخول، يرجى تسجيل الدخول مجدداً",
        );
      case 403: // Forbidden
        return const ServerFailure("ليس لديك صلاحية للقيام بهذا الإجراء");
      case 404: // Not Found
        return const ServerFailure("البيانات المطلوبة غير موجودة");
      case 422: // Unprocessable Entity (أخطاء التحقق - Validation Errors في لارافيل)
        return ServerFailure(extractedMessage);
      case 429: // Too Many Requests
        return const ServerFailure(
          "تم تجاوز حد الطلبات المسموح به، يرجى الانتظار",
        );
      case 500: // Internal Server Error
        return const ServerFailure("يوجد خلل في السيرفر، نعمل على حله");
      case 502: // Bad Gateway
        return const ServerFailure("بوابة اتصال خاطئة");
      case 503: // Service Unavailable
        return const ServerFailure("الخدمة غير متوفرة حالياً");
      case 504: // Gateway Timeout
        return const ServerFailure("انتهى وقت انتظار بوابة الاتصال");
      default:
        return ServerFailure(extractedMessage);
    }
  }

  // --- صائد أخطاء Laravel الذكي ---
  static String _extractLaravelError(dynamic data) {
    if (data == null) return "حدث خطأ غير معروف";

    // 1. إذا كان الخطأ عبارة عن نص مباشر
    if (data is String && data.isNotEmpty) {
      return data;
    }

    // 2. التعامل مع الـ JSON Object
    if (data is Map<String, dynamic>) {
      // الأولوية القصوى: البحث داخل كائن "errors" (الخاص بأخطاء الـ Validation في Laravel)
      if (data.containsKey('errors') && data['errors'] is Map) {
        final Map<String, dynamic> errors = data['errors'];

        // جلب أول مصفوفة أخطاء لأول حقل خاطئ
        if (errors.isNotEmpty) {
          final firstFieldErrors = errors.values.first;
          if (firstFieldErrors is List && firstFieldErrors.isNotEmpty) {
            return firstFieldErrors.first
                .toString(); // يرجع مثلاً: "هذا الإيميل مستخدم مسبقاً"
          }
        }
      }

      // إذا لم يكن هناك كائن "errors"، نبحث عن الرسالة العامة "message"
      if (data.containsKey('message') &&
          data['message'] != null &&
          data['message'].toString().isNotEmpty) {
        return data['message'].toString();
      }

      // مفاتيح احتياطية في حال قام مبرمج الباك إند بإرجاع صيغة مخصصة
      if (data.containsKey('error')) return data['error'].toString();
      if (data.containsKey('detail')) return data['detail'].toString();
    }

    return "حدث خطأ، يرجى مراجعة البيانات المدخلة";
  }
}
