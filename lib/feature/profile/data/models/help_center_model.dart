class HelpCenterModel {
  final String supportPhone;
  final String managerPhone;
  final String supportEmail;
  final String workingHours;
  final String address;

  const HelpCenterModel({
    required this.supportPhone,
    required this.managerPhone,
    required this.supportEmail,
    required this.workingHours,
    required this.address,
  });

  factory HelpCenterModel.fromJson(Map<String, dynamic> json) {
    return HelpCenterModel(
      supportPhone: json['support_phone']?.toString() ?? '+963 999 000 111',
      managerPhone: json['manager_phone']?.toString() ?? '+963 999 000 222',
      supportEmail: json['support_email']?.toString() ?? 'support@primo-market.cloud',
      workingHours: json['working_hours']?.toString() ?? 'يومياً من 9 صباحاً حتى 10 مساءً',
      address: json['address']?.toString() ?? 'دمشق، سوريا',
    );
  }

  static const HelpCenterModel dummy = HelpCenterModel(
    supportPhone: '+963 999 000 111',
    managerPhone: '+963 999 000 222',
    supportEmail: 'support@primo-market.cloud',
    workingHours: 'يومياً من 9 صباحاً حتى 10 مساءً',
    address: 'دمشق، سوريا',
  );
}
