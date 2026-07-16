class NotificationModel {
  final int id;
  final int? userId;
  final String title;
  final String body;
  final int? orderId; // استخراج رقم الطلب من الـ object الداخلي
  final String createdAt;

  NotificationModel({
    required this.id,
    this.userId,
    required this.title,
    required this.body,
    this.orderId,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    // 💡 التقاط رقم الطلب بذكاء وتوقع تصحيح الخطأ الإملائي من الباك إند مستقبلاً
    int? parsedOrderId;
    if (json['data'] != null && json['data'] is Map) {
      parsedOrderId = json['data']['ordar_id'] ?? json['data']['order_id'];
    }

    return NotificationModel(
      id: json['id'] ?? 0,
      userId: json['user_id'],
      title: json['title']?.toString() ?? 'بدون عنوان',
      body: json['body']?.toString() ?? '',
      orderId: parsedOrderId,
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}
