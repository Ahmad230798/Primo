import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // نحتاجها للـ kDebugMode
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:primo/core/network/api_constant.dart';
import 'package:primo/core/network/app_storage.dart';

class DioFactory {
  // 1. جعلنا المتغيرات private لضمان عدم التلاعب بها من خارج الكلاس
  DioFactory._();
  static Dio? _dio;

  // 2. توحيد مدة الانتظار (المعيار 30 ثانية لتجنب مشاكل الشبكات الضعيفة)
  static const Duration _timeOut = Duration(seconds: 30);

  static Dio getDio() {
    if (_dio == null) {
      _dio = Dio(
        BaseOptions(
          baseUrl: ApiConstant.baseUrl,
          connectTimeout: _timeOut,
          receiveTimeout: _timeOut,
          sendTimeout: _timeOut,
          headers: {
            'Accept': 'application/json',
            // 'Accept-Language': 'ar', // 3. إخبار السيرفر أن لغة التطبيق عربية
          },
        ),
      );
      _addDioInterceptor();
    }
    return _dio!;
  }

  static void _addDioInterceptor() {
    _dio?.interceptors.add(
      InterceptorsWrapper(
        // --- قبل إرسال الطلب ---
        onRequest: (options, handler) async {
          final token = await AppStorage.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },

        // --- عند استقبال رد ناجح ---
        onResponse: (response, handler) {
          return handler.next(response);
        },

        // --- عند حدوث خطأ (التعديل الأهم للـ Django JWT) ---
        onError: (DioException error, handler) async {
          // إذا كان الخطأ 401 (التوكن منتهي الصلاحية)
          if (error.response?.statusCode == 401) {
            // TODO: استدعاء دالة refreshToken() هنا، ثم إعادة إرسال الطلب (Retry)
            // سنقوم ببرمجتها لاحقاً عندما نصل لإدارة الـ Auth
          }
          return handler.next(error);
        },
      ),
    );

    // 4. حماية أمنية: تشغيل الـ Logger فقط في وضع التطوير (Debug)
    if (kDebugMode) {
      _dio?.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
    }
  }
}
