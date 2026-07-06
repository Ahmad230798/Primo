import 'dart:async';
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
  static bool _isRefreshing = false;
  static Completer<bool>? _refreshCompleter;

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
            final refreshToken = await AppStorage.getRefreshToken();

            if (refreshToken != null && refreshToken.isNotEmpty) {
              if (_isRefreshing) {
                final success =
                    await (_refreshCompleter?.future ?? Future.value(false));
                if (success) {
                  final newAccessToken = await AppStorage.getAccessToken();
                  final options = error.requestOptions;
                  options.headers['Authorization'] = 'Bearer $newAccessToken';
                  try {
                    final retryResponse = await _dio?.fetch(options);
                    return handler.resolve(retryResponse!);
                  } catch (e) {
                    return handler.reject(error);
                  }
                } else {
                  return handler.reject(error);
                }
              }

              _isRefreshing = true;
              _refreshCompleter = Completer<bool>();

              try {
                final refreshDio = Dio(
                  BaseOptions(
                    baseUrl: ApiConstant.baseUrl,
                    headers: {'Accept': 'application/json'},
                  ),
                );

                final response = await refreshDio.post(
                  ApiConstant.refreshToken,
                  data: {'refresh_token': refreshToken},
                );

                if (response.statusCode == 200 || response.statusCode == 201) {
                  final responseData = response.data;
                  String? newAccessToken;
                  String? newRefreshToken;

                  if (responseData is Map<String, dynamic>) {
                    if (responseData['data'] is Map<String, dynamic>) {
                      newAccessToken = responseData['data']['access_token'];
                      newRefreshToken = responseData['data']['refresh_token'];
                    } else {
                      newAccessToken =
                          responseData['access_token'] ??
                          responseData['access'];
                      newRefreshToken =
                          responseData['refresh_token'] ??
                          responseData['refresh'];
                    }
                  }

                  if (newAccessToken != null && newAccessToken.isNotEmpty) {
                    if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
                      await AppStorage.saveTokens(
                        accessToken: newAccessToken,
                        refreshToken: newRefreshToken,
                      );
                    } else {
                      await AppStorage.setAccessToken(newAccessToken);
                    }

                    _isRefreshing = false;
                    _refreshCompleter?.complete(true);

                    final options = error.requestOptions;
                    options.headers['Authorization'] = 'Bearer $newAccessToken';
                    final retryResponse = await _dio?.fetch(options);
                    return handler.resolve(retryResponse!);
                  }
                }

                _isRefreshing = false;
                if (!(_refreshCompleter?.isCompleted ?? true)) {
                  _refreshCompleter?.complete(false);
                }
                await _performLogout();
                return handler.reject(error);
              } catch (e) {
                _isRefreshing = false;
                if (!(_refreshCompleter?.isCompleted ?? true)) {
                  _refreshCompleter?.complete(false);
                }
                await _performLogout();
                return handler.reject(error);
              }
            } else {
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
