class NotificationSettingsModel {
  final bool notificationOffer;
  final bool notificationOrder;

  const NotificationSettingsModel({
    required this.notificationOffer,
    required this.notificationOrder,
  });

  static bool _parseBool(dynamic val) {
    if (val == null) return true;
    if (val is bool) return val;
    if (val is num) return val != 0;
    if (val is String) {
      final s = val.trim().toLowerCase();
      return s == '1' || s == 'true' || s == 'yes';
    }
    return true;
  }

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      notificationOffer: _parseBool(json['notification_offer']),
      notificationOrder: _parseBool(json['notification_order']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notification_offer': notificationOffer,
      'notification_order': notificationOrder,
    };
  }

  NotificationSettingsModel copyWith({
    bool? notificationOffer,
    bool? notificationOrder,
  }) {
    return NotificationSettingsModel(
      notificationOffer: notificationOffer ?? this.notificationOffer,
      notificationOrder: notificationOrder ?? this.notificationOrder,
    );
  }
}
