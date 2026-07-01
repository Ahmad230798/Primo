import 'package:dio/dio.dart';
import 'package:primo/core/network/api_error_handler.dart';

class ApiConsumer {
  final Dio _dio;

  ApiConsumer(this._dio);

  /// GET
  Future<dynamic> get({
    required String path,
    Map<String, dynamic>? queryParameters, // إضافة هامة جداً للبحث والفلترة
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw ServerFailure.fromDioError(e);
    }
  }

  /// POST
  Future<dynamic> post({
    required String path,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ), // سيعتمد على الـ Headers الافتراضية في DioFactory
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw ServerFailure.fromDioError(e);
    }
  }

  /// POST FORM DATA (لرفع الصور مثل صورة الملف الشخصي أو المنتج)
  Future<dynamic> postFormData({
    required String path,
    required FormData formData,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: Options(
          headers: {
            // هنا فقط نحتاج لإجبار السيرفر على استقبال ملفات
            'Content-Type': 'multipart/form-data',
            ...?headers,
          },
        ),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      print("TYPE: ${e.type}");
      print("ERROR: ${e.error}");
      print("MESSAGE: ${e.message}");
      print("URI: ${e.requestOptions.uri}");
      print("HEADERS: ${e.requestOptions.headers}");
      throw ServerFailure.fromDioError(e);
    }
  }

  /// PUT (لتحديث كائن بالكامل)
  Future<dynamic> put({
    required String path,
    required dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.put(
        // تم تصحيح الاستدعاء من patch إلى put
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw ServerFailure.fromDioError(e);
    }
  }

  /// PATCH (لتحديث حقل واحد في كائن)
  Future<dynamic> patch({
    required String path,
    required dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw ServerFailure.fromDioError(e);
    }
  }

  /// DELETE
  Future<dynamic> delete({
    required String path,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw ServerFailure.fromDioError(e);
    }
  }

  // الدالة أصبحت داخل الكلاس وتتعامل مع الاستجابة بشكل آمن
  dynamic _handleResponse(Response response) {
    if ([200, 201, 202, 204].contains(response.statusCode)) {
      return response.data;
    } else {
      // إذا رد السيرفر بكود غريب (غير متوقع من DioException)
      throw ServerFailure.fromResponse(response.statusCode, response.data);
    }
  }
}
