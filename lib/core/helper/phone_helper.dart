class PhoneHelper {
  PhoneHelper._();

  static String cleanPhone(String rawPhone) {
    var phone = rawPhone.trim();
    if (phone.startsWith('+963')) {
      phone = phone.substring(4);
    } else if (phone.startsWith('00963')) {
      phone = phone.substring(5);
    } else if (phone.startsWith('963')) {
      phone = phone.substring(3);
    }
    if (phone.startsWith('0')) {
      phone = phone.substring(1);
    }
    return '+963$phone';
  }
}
