import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:primo/core/network/dio_factory.dart';

class GoogleMapsService {
  // 📍 إحداثيات المتجر الرئيسية (ملاحظة: سيتم تزويدك بالإحداثيات الرسمية لاحقاً)
  static const double storeLat = 34.7706; // الحواش كمركز مفترض للمتجر
  static const double storeLng = 36.3206;

  // 🔑 المفتاح الخاص بـ Google Maps / Directions API
  static const String apiKey = 'YOUR_API_KEY';

  final Dio _dio;

  GoogleMapsService({Dio? dio}) : _dio = dio ?? DioFactory.getDio();

  /// تقوم بحساب المسافة الحقيقية للقيادة (Routing Distance) بالأمتار بين موقع المتجر وموقع الزبون
  /// عبر Google Directions API. في حال عدم إدخال الـ API Key أو حدوث خطأ في الشبكة،
  /// تقوم الدالة تلقائياً بحساب مسافة الخط المستقيم بالأمتار لضمان استقرار التطبيق.
  Future<int> getRoutingDistanceInMeters({
    required double destinationLat,
    required double destinationLng,
    double? originLat,
    double? originLng,
  }) async {
    final double startLat = originLat ?? storeLat;
    final double startLng = originLng ?? storeLng;

    // إذا كان الـ Key لا يزال نصاً افتراضياً، نستخدم الحساب التلقائي المباشر
    if (apiKey == 'YOUR_API_KEY' || apiKey.trim().isEmpty) {
      log('GoogleMapsService: Using fallback straight-line distance calculation because API Key is placeholder.');
      return _calculateFallbackDistance(startLat, startLng, destinationLat, destinationLng);
    }

    try {
      final String url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=$startLat,$startLng&destination=$destinationLat,$destinationLng&key=$apiKey';

      final response = await _dio.get(url);

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final String status = data['status']?.toString() ?? '';

        if (status == 'OK' &&
            data['routes'] is List &&
            (data['routes'] as List).isNotEmpty) {
          final firstRoute = (data['routes'] as List)[0] as Map<String, dynamic>;
          if (firstRoute['legs'] is List &&
              (firstRoute['legs'] as List).isNotEmpty) {
            final firstLeg = (firstRoute['legs'] as List)[0] as Map<String, dynamic>;
            final distanceObj = firstLeg['distance'];
            if (distanceObj is Map<String, dynamic> &&
                distanceObj['value'] != null) {
              final int distanceInMeters =
                  num.tryParse(distanceObj['value'].toString())?.toInt() ?? 0;
              log('GoogleMapsService: Directions API routing distance = $distanceInMeters meters');
              return distanceInMeters;
            }
          }
        } else {
          log('GoogleMapsService: Directions API response status: $status');
        }
      }
    } catch (e) {
      log('GoogleMapsService: Exception calling Directions API: $e');
    }

    // Fallback في حال حدوث أي خطأ في الاتصال
    return _calculateFallbackDistance(startLat, startLng, destinationLat, destinationLng);
  }

  /// حساب المسافة الحسابية المباشرة بالأمتار كبديل احتياطي
  int _calculateFallbackDistance(
    double startLat,
    double startLng,
    double destLat,
    double destLng,
  ) {
    final double distanceInMeters = Geolocator.distanceBetween(
      startLat,
      startLng,
      destLat,
      destLng,
    );
    return distanceInMeters.round();
  }
}
