import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  // 1. منع إنشاء كائن من الكلاس (لأننا سنستخدم دوال Static للحفاظ على الذاكرة)
  AppStorage._();

  static SharedPreferences? _prefs;
  // إعداد التخزين المشفر
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(), // زيادة التشفير للأندرويد
  );

  // دالة التهيئة (تُستدعى في main.dart قبل runApp)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ================= الثوابت =================
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _deviceIdKey = 'device_id';
  static const String _roleKey = 'user_role';
  static const String _isFirstTimeKey = 'is_first_time';

  // =====================================
  // 1. إدارة التوكنز (تخزين مشفر - Secure Storage)
  // =====================================
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _secureStorage.write(key: _accessTokenKey, value: accessToken);
    await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
  }

  static Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  static Future<void> clearTokens() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    await _prefs?.remove(_roleKey);
  }

  // =====================================
  // 2. إعدادات التطبيق (تخزين عادي - SharedPreferences)
  // =====================================
  static bool isFirstTime() {
    // لا نحتاج لـ Future هنا لأننا هيأنا SharedPreferences في البداية
    return _prefs?.getBool(_isFirstTimeKey) ?? true;
  }

  static Future<void> setFirstTimeNotified() async {
    await _prefs?.setBool(_isFirstTimeKey, false);
  }

  // =====================================
  // 3. إدارة معرف الجهاز
  // =====================================
  static Future<String> getDeviceId() async {
    String? deviceId = _prefs?.getString(_deviceIdKey);

    if (deviceId == null) {
      deviceId = 'device_${DateTime.now().millisecondsSinceEpoch}';
      await _prefs?.setString(_deviceIdKey, deviceId);
    }
    return deviceId;
  }

  // =====================================
  // 4. إدارة الصلاحيات
  // =====================================
  static Future<void> saveUserRole(int role) async {
    await _prefs?.setInt(_roleKey, role);
  }

  static int getUserRole() {
    return _prefs?.getInt(_roleKey) ?? 0;
  }
}
