import 'package:primo/core/network/app_storage.dart';

class HelpCenterModel {
  final String supportPhone;
  final String managerPhone;
  final String facebookAccount;
  final String instagramAccount;
  final String workingHours;
  final String address;

  const HelpCenterModel({
    required this.supportPhone,
    required this.managerPhone,
    required this.facebookAccount,
    this.instagramAccount = 'INSTAGRAM_URL_HERE',
    required this.workingHours,
    required this.address,
  });

  factory HelpCenterModel.fromJson(Map<String, dynamic> json) {
    // Penetrate the 'data' wrapper if it exists
    final Map<String, dynamic> targetData =
        (json.containsKey('data') && json['data'] != null)
        ? json['data']
        : json;

    // 💡 حفظ إحداثيات المتجر القادمة من الباك إيند في AppStorage تلقائياً
    if (targetData['location_lat'] != null &&
        targetData['location_lng'] != null) {
      final double? lat = double.tryParse(
        targetData['location_lat'].toString(),
      );
      final double? lng = double.tryParse(
        targetData['location_lng'].toString(),
      );
      if (lat != null && lng != null) {
        AppStorage.saveStoreCoordinates(lat: lat, lng: lng);
      }
    }

    return HelpCenterModel(
      supportPhone: targetData['customer_service_phone']?.toString() ?? '',
      managerPhone: targetData['admin_phone']?.toString() ?? '',
      workingHours: targetData['working_hours']?.toString() ?? '',
      address: targetData['location']?.toString() ?? '',
      facebookAccount: targetData['facebook_account']?.toString() ?? '',
      instagramAccount:
          targetData['instagram_account']?.toString() ??
          targetData['instagram']?.toString() ??
          'INSTAGRAM_URL_HERE',
    );
  }

  static const HelpCenterModel dummy = HelpCenterModel(
    supportPhone: '+963 999 000 111',
    managerPhone: '+963 999 000 222',
    facebookAccount: 'facebook.com/primo',
    instagramAccount: 'INSTAGRAM_URL_HERE',
    workingHours: 'يومياً من 9 صباحاً حتى 10 مساءً',
    address: 'دمشق، سوريا',
  );
}
