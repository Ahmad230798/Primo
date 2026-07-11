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
  static const String _lastOtpTimeKey = 'last_otp_time';

  // حفظ وقت آخر محاولة إرسال
  static Future<void> saveLastOtpTime() async {
    final currentTime = DateTime.now().toIso8601String();
    await _secureStorage.write(key: _lastOtpTimeKey, value: currentTime);
  }

  // جلب وقت آخر محاولة
  static Future<String?> getLastOtpTime() async {
    return await _secureStorage.read(key: _lastOtpTimeKey);
  }

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

  static Future<void> setAccessToken(String token) async {
    await _secureStorage.write(key: _accessTokenKey, value: token);
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

  static Future<void> clearAllData() async {
    await clearTokens();
    await _secureStorage.deleteAll();
    await _prefs?.clear();
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

  static const String _userNameKey = 'user_name';
  static const String _userPhoneKey = 'user_phone';
  static const String _userAvatarKey = 'user_avatar';

  static Future<void> saveUserData({
    String? name,
    String? phone,
    String? avatar,
  }) async {
    if (name != null) await _prefs?.setString(_userNameKey, name);
    if (phone != null) await _prefs?.setString(_userPhoneKey, phone);
    if (avatar != null) await _prefs?.setString(_userAvatarKey, avatar);
  }

  static String getUserName() =>
      _prefs?.getString(_userNameKey) ?? 'مدير النظام';
  static String getUserPhone() =>
      _prefs?.getString(_userPhoneKey) ?? 'الإدارة الرئيسية';
  static String? getUserAvatar() => _prefs?.getString(_userAvatarKey);

  // داخل ملف AppStorage
  static const String _defaultAddressKey = 'default_address_id';

  // دالة حفظ العنوان الافتراضي
  static Future<void> saveDefaultAddressId(int addressId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_defaultAddressKey, addressId);
  }

  // دالة جلب العنوان الافتراضي
  static Future<int?> getDefaultAddressId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_defaultAddressKey);
  }

  // دالة مسح العنوان الافتراضي (عند تسجيل الخروج مثلاً)
  static Future<void> removeDefaultAddressId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_defaultAddressKey);
  }

  static Future<void> cacheData(String key, String jsonString) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonString);
  }

  static Future<String?> getCachedData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}
