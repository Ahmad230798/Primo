class VariantRequestModel {
  final int? id; // نستخدمه فقط عند التعديل
  final String property;
  final String price;
  final String stock;
  final int? isActive; // نستخدمه فقط عند التعديل (0 أو 1)

  VariantRequestModel({
    this.id,
    required this.property,
    required this.price,
    required this.stock,
    this.isActive,
  });
}
