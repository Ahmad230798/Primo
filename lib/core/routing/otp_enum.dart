// 1. تحديد أنواع العمليات التي تحتاج OTP
enum OtpType { register, forgotPassword, login }

// 2. كلاس لتجميع رقم الهاتف ونوع العملية لتمريرهم معاً في الـ Route
class OtpVerificationArgs {
  final String phoneNumber;
  final OtpType otpType;

  OtpVerificationArgs({
    required this.phoneNumber,
    required this.otpType,
  });
}