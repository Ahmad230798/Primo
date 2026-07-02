abstract class ApiConstant {
  static const String baseUrl = "https://api.primo-market.cloud/api";

  // --- Auth ---
  static const String register = "/register";
  static const String verifyRegister = "/confirm-registration";
  static const String login = "/login";

  // --- Admin ---
  static const String adminCategories = "/admin/categories";
  static const String adminProducts = "/admin/products";
  static const String adminOffers = "/admin/offers";
  static const String adminVariants = "/admin/variants";
  static const String toggleProductStatus = "/admin/products/toggle-active";
}
