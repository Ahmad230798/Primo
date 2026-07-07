abstract class ApiConstant {
  static const String baseUrl = "https://api.primo-market.cloud/api";

  // --- Auth ---
  static const String register = "/register";
  static const String verifyRegister = "/confirm-registration";
  static const String forgotPassword = "/forgot-password";
  static const String confirmForgotPassword = "/confirm-forgot-password";
  static const String resetPassword = "/reset-password";
  static const String resendOtp = "/resend-otp";
  static const String login = "/login";
  static const String confirmLogin = "/confirm-login";
  static const String deleteAccount = "/account/delete";
  static const String refreshToken = "/refresh";
  static const String logOut = "/logout";

  // --- User Profile & Addresses ---
  static const String profile = "/user/profile";
  static const String changePassword = "/user/change-password";
  static const String addresses = "/user/addresses";

  // --- Admin ---
  static const String adminCategories = "/admin/categories";
  static const String adminProducts = "/admin/products";
  static const String adminOffers = "/admin/offers";
  static const String adminVariants = "/admin/variants";
  static const String toggleProductStatus = "/admin/products/toggle-active";

  // --- User Home, Catalog, Categories, Favorites ---
  static const String userHome = "/user/home";
  static const String userProducts = "/user/products";
  static const String userCategories = "/user/categories";
  static const String userFavorites = "/user/favorites";
  static const String toggleFavorite = "/user/favorites/toggle";

  // --- Cart & Orders ---
  static const String userCart = "/user/cart";
  static const String orderPrice = "/user/ordar/price";
  static const String orderConfirm = "/user/ordar/confirme";
  static const String userOrders = "/user/ordars";

  // --- Notifications & Suggestions ---
  static const String userNotifications = "/user/notifications";
  static const String userSuggestions = "/user/suggestions";
}
