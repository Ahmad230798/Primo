import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:primo/core/network/api_constant.dart';
import 'package:primo/core/network/app_storage.dart';
import 'package:primo/core/routing/app_routes.dart';
import 'package:primo/core/routing/routes.dart';

class DioFactory {
  DioFactory._();
  static Dio? _dio;
  static const Duration _timeOut = Duration(seconds: 15);

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
      QueuedInterceptorsWrapper(
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
          final authPaths = [
            ApiConstant.login,
            ApiConstant.register,
            ApiConstant.verifyRegister,
            ApiConstant.forgotPassword,
            ApiConstant.confirmForgotPassword,
            ApiConstant.resetPassword,
            ApiConstant.resendOtp,
            '/confirm-login',
          ];
          if (authPaths.any(
            (path) => error.requestOptions.path.contains(path),
          )) {
            return handler.next(error);
          }

          if (error.response?.statusCode == 401) {
            await _performLogout();
            return handler.reject(error);
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

  // دالة مساعدة لتسجيل الخروج عند انتهاء الصلاحية
  static Future<void> _performLogout() async {
    await AppStorage.clearAllData();
    final context = AppRoutes.navigatorKey.currentContext;
    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("انتهت صلاحية الجلسة، يرجى تسجيل الدخول مجدداً"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    AppRoutes.navigatorKey.currentState?.pushNamedAndRemoveUntil(
      Routes.login,
      (route) => false,
    );
  }
}

