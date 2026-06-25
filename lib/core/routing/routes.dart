class Routes {
  // --- Auth & Splash Routes ---
  static const String splash = "/splash";
  static const String login = "/login";
  static const String register = "/register";

  // --- User App Routes ---
  static const String home = '/home';
  static const String profile = '/profile';
  static const String editProfile = '/editProfile';
  static const String productDetails = '/productDetails';
  static const String cart = '/cart';
  static const String orderTracking = '/orderTracking'; // تم تصحيح الكلمة

  // --- Admin App Routes ---
  static const String adminHome = '/adminHome';
  static const String adminInventory =
      '/adminInventory'; // تم التوحيد مع الـ Drawer
  static const String addProducts = '/addProducts';
  static const String editProduct = '/editProduct';
  static const String adminOrders = '/adminOrders';
  static const String orderDetails = '/orderDetails';
  static const String directOrders = '/directOrders';
  static const String adminCategories = '/adminCategories';
  static const String addCategory = '/addCategory';
  static const String adminOffers = '/adminOffers'; // تم التوحيد مع الـ Drawer
  static const String adminSuggestions = '/adminSuggestions';
}
