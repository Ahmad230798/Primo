import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:primo/core/network/api_constant.dart';
import 'package:primo/core/network/app_storage.dart';
import 'package:primo/core/routing/app_routes.dart';
import 'package:primo/core/routing/routes.dart';

class DioFactory {
  DioFactory._();
  static Dio? _dio;
  static const Duration _timeOut = Duration(seconds: 30);

  static Dio getDio() {
    if (_dio == null) {
      _dio = Dio(
        BaseOptions(
          baseUrl: ApiConstant.baseUrl,
          connectTimeout: _timeOut,
          receiveTimeout: _timeOut,
          sendTimeout: _timeOut,
          headers: {'Accept': 'application/json'},
        ),
      );
      _addDioInterceptor();
    }
    return _dio!;
  }

  static void _addDioInterceptor() {
    _dio?.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await AppStorage.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          if (error.requestOptions.path.contains(ApiConstant.login)) {
            return handler.next(error);
          }
          if (error.response?.statusCode == 401) {
            final refreshToken = await AppStorage.getRefreshToken();

            if (refreshToken != null && refreshToken.isNotEmpty) {
              try {
                // 💡 التعديل الجوهري: إنشاء Dio جديدة نظيفة لطلب التجديد
                final refreshDio = Dio(
                  BaseOptions(baseUrl: ApiConstant.baseUrl),
                );

                final response = await refreshDio.post(
                  ApiConstant.refreshToken,
                  data: {'refresh': refreshToken}, // متوافق مع Django JWT
                );

                if (response.statusCode == 200) {
                  final newAccessToken = response.data['access'];
                  // إذا كان السيرفر يعيد Refresh Token جديداً أيضاً، قم بحفظه هنا
                  await AppStorage.setAccessToken(newAccessToken);

                  // إعادة إرسال الطلب الأصلي
                  final options = error.requestOptions;
                  options.headers['Authorization'] = 'Bearer $newAccessToken';

                  // هنا نستخدم _dio الأساسية لأننا نريد اعتراض الطلب لو فشل لسبب آخر
                  final retryResponse = await _dio?.fetch(options);
                  return handler.resolve(retryResponse!);
                }
              } catch (e) {
                // 💡 إذا فشل التجديد (الـ Refresh منتهي أيضاً)، يجب طرد المستخدم
                await _performLogout();
                return handler.reject(error);
              }
            } else {
              // لا يوجد Refresh Token من الأساس
              await _performLogout();
              return handler.reject(error);
            }
          }
          return handler.next(error);
        },
      ),
    );

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

  // دالة مساعدة لتسجيل الخروج
  static Future<void> _performLogout() async {
    await AppStorage.clearTokens(); // حذف بيانات المستخدم
    // التوجيه إلى شاشة تسجيل الدخول باستخدام الـ GlobalKey للـ Navigator
    AppRoutes.navigatorKey.currentState?.pushNamedAndRemoveUntil(
      Routes.login,
      (route) => false,
    );
  }
}
