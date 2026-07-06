class NotificationSettingsModel {
  final bool notificationOffer;
  final bool notificationOrder;

  const NotificationSettingsModel({
    required this.notificationOffer,
    required this.notificationOrder,
  });

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      notificationOffer: json['notification_offer'] as bool? ?? true,
      notificationOrder: json['notification_order'] as bool? ?? true,
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
