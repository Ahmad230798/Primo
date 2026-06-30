class AppValidators {
  AppValidators._();

  // 1. التحقق من الاسم
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "الاسم مطلوب";
    }
    if (value.trim().length < 3) {
      return "الاسم يجب أن يكون 3 أحرف على الأقل";
    }
    return null;
  }

  // 2. التحقق من البريد الإلكتروني
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "البريد الإلكتروني مطلوب";
    }
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return "أدخل بريداً إلكترونياً صحيحاً";
    }
    return null;
  }

  // 3. التحقق من كلمة المرور (الأساسية)
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "كلمة المرور مطلوبة";
    }
    if (value.length < 6) {
      return "كلمة المرور يجب أن تكون 6 أحرف على الأقل";
    }
    return null;
  }

  // 4. [جديد] التحقق من تطابق كلمتي المرور (لشاشة التسجيل)
  static String? validateConfirmPassword(
    String? value,
    String? originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return "تأكيد كلمة المرور مطلوب";
    }
    if (value != originalPassword) {
      return "كلمتا المرور غير متطابقتين";
    }
    return null;
  }

  // 5. [مُحسن] التحقق من رقم الجوال (يدعم علامة + الدولية)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "رقم الجوال مطلوب";
    }
    // هذا الـ Regex يسمح بوجود علامة + اختيارية في البداية، متبوعة بـ 9 إلى 15 رقم
    final phoneRegex = RegExp(r'^\+?[0-9]{9,15}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return "أدخل رقم جوال صحيح (مثال: 966500000000+)";
    }
    return null;
  }

  // 6. [جديد] التحقق من الحقول الاختيارية (مثل الملاحظات)
  static String? validateOptionalText(String? value, {int minLength = 0}) {
    // إذا كان فارغاً، لا مشكلة (لأنه اختياري)
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    // لكن إذا كتب شيئاً، يجب أن يطابق الحد الأدنى
    if (value.trim().length < minLength) {
      return "يجب أن يحتوي على $minLength أحرف على الأقل";
    }
    return null;
  }
}
