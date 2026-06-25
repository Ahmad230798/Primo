// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:primo/core/routing/routes.dart';
// import 'package:primo/feature/addresses/presentation/bloc/adresses_cubit.dart';
// import 'package:primo/feature/addresses/presentation/screen/saved_addresses_screen.dart';
// import 'package:primo/feature/categories/presentation/screen/all_categories_screen.dart';
// import 'package:primo/feature/favorites/presentation/screens/favorites_screen.dart';
// import 'package:primo/feature/orders/presentation/screens/order_details_screen.dart';
// import 'package:primo/feature/orders/presentation/screens/order_history_screen.dart';

// // --- Auth & Profile ---
// import 'package:primo/feature/splash_screen/splash_screen.dart';
// import 'package:primo/feature/auth/presentation/screens/login_screen.dart';
// import 'package:primo/feature/auth/presentation/screens/register_screen.dart';
// import 'package:primo/feature/orders/presentation/bloc/checkout_cubit.dart';
// import 'package:primo/feature/orders/presentation/screens/checkout.dart';
// import 'package:primo/feature/profile/presentation/screen/edit_profile.dart';
// import 'package:primo/feature/profile/presentation/screen/profile.dart';

// // --- User Features ---
// import 'package:primo/feature/home/presentation/screen/home.dart';
// import 'package:primo/feature/product/presentation/screen/product_details.dart';
// import 'package:primo/feature/cart/presentation/screens/cart.dart';
// import 'package:primo/feature/orders/presentation/screens/order_tracking.dart';

// // --- Admin Features ---
// import 'package:primo/feature/admin_home/presentation/screen/admin_home_screen.dart';
// import 'package:primo/feature/inventory/presentation/screen/inventory_screen.dart';
// import 'package:primo/feature/admin_product/presentation/screen/add_product_screen.dart';
// import 'package:primo/feature/admin_product/presentation/screen/edit_product_screen.dart';
// import 'package:primo/feature/admin_orders/presentation/screen/admin_orders_screen.dart';
// import 'package:primo/feature/admin_orders/presentation/screen/admin_order_details_screen.dart';
// import 'package:primo/feature/direct_orders/presentation/screen/direct_orders_screen.dart';
// import 'package:primo/feature/admin_categories/presentation/screen/admin_categories_screen.dart';
// import 'package:primo/feature/admin_categories/presentation/screen/add_category_screen.dart';
// import 'package:primo/feature/admin_offers/presentation/screen/create_offer_screen.dart';
// import 'package:primo/feature/admin_suggestions/presentation/screen/admin_suggestions_screen.dart';
// import 'package:primo/feature/suggestions/presentation/screens/suggest_product_page.dart';

// class AppRoutes {
//   Route generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       // ================== Auth & Splash ==================
//       case Routes.splash:
//         return CupertinoPageRoute(builder: (_) => const SplashScreen());
//       case Routes.login:
//         return CupertinoPageRoute(builder: (_) => const LoginScreen());
//       case Routes.register:
//         return CupertinoPageRoute(builder: (_) => const RegisterScreen());

//       // ================== User App ==================
//       case Routes.home:
//         return CupertinoPageRoute(builder: (_) => const Home());
//       case Routes.profile:
//         return CupertinoPageRoute(builder: (_) => const Profile());
//       case Routes.editProfile:
//         return CupertinoPageRoute(builder: (_) => const EditProfile());
//       case Routes.productDetails:
//         return CupertinoPageRoute(builder: (_) => const ProductDetails());
//       case Routes.cart:
//         return CupertinoPageRoute(builder: (_) => const Cart());
//       case Routes.orderTracking:
//         return CupertinoPageRoute(builder: (_) => const OrderTracking());
//       case Routes.orderDetailsScreen:
//         return CupertinoPageRoute(builder: (_) => const OrderDetailsScreen());
//       case Routes.suggestProduct:
//         return CupertinoPageRoute(builder: (_) => const SuggestProductPage());
//       case Routes.favorites:
//         return CupertinoPageRoute(builder: (_) => const FavoritesPage());
//       case Routes.orderHistory:
//         return CupertinoPageRoute(builder: (_) => const OrderHistoryScreen());
//       case Routes.categories:
//         return CupertinoPageRoute(builder: (_) => const AllCategoriesScreen());
//       case Routes.addresses:
//         return CupertinoPageRoute(
//           builder: (_) => BlocProvider(
//             create: (context) => AddressesCubit(),
//             child: const SavedAddressesScreen(),
//           ),
//         );

//       // ================== Admin App ==================
//       case Routes.adminHome:
//         return CupertinoPageRoute(builder: (_) => const AdminHomeScreen());
//       case Routes.adminInventory:
//         return CupertinoPageRoute(builder: (_) => const InventoryScreen());
//       case Routes.addProducts:
//         return CupertinoPageRoute(builder: (_) => const AddProductScreen());
//       case Routes.editProduct:
//         return CupertinoPageRoute(builder: (_) => const EditProductScreen());
//       case Routes.adminOrders:
//         return CupertinoPageRoute(builder: (_) => const AdminOrdersScreen());
//       case Routes.orderDetails:
//         return CupertinoPageRoute(
//           builder: (_) => const AdminOrderDetailsScreen(),
//         );
//       case Routes.directOrders:
//         return CupertinoPageRoute(builder: (_) => const DirectOrdersScreen());
//       case Routes.adminCategories:
//         return CupertinoPageRoute(
//           builder: (_) => const AdminCategoriesScreen(),
//         );
//       case Routes.addCategory:
//         return CupertinoPageRoute(builder: (_) => const AddCategoryScreen());
//       case Routes.adminOffers:
//         return CupertinoPageRoute(builder: (_) => const CreateOfferScreen());
//       case Routes.adminSuggestions:
//         return CupertinoPageRoute(
//           builder: (_) => const AdminSuggestionsScreen(),
//         );

//       // ================== Default ==================
//       case Routes.checkoutScreen:
//         return CupertinoPageRoute(
//           builder: (_) => BlocProvider(
//             create: (context) => CheckoutCubit(),
//             child: const CheckoutScreen(),
//           ),
//         );
//       default:
//         return CupertinoPageRoute(
//           builder: (_) => const Scaffold(
//             body: Center(child: Text("No route defined for this path")),
//           ),
//         );
//     }
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/feature/addresses/presentation/bloc/addresses_cubit.dart';

// --- Imports (تم اختصارها للتنظيم) ---
import 'package:primo/feature/addresses/presentation/screen/saved_addresses_screen.dart';
import 'package:primo/feature/categories/presentation/screen/all_categories_screen.dart';
import 'package:primo/feature/favorites/presentation/screens/favorites_screen.dart';
import 'package:primo/feature/orders/presentation/screens/order_details_screen.dart';
import 'package:primo/feature/orders/presentation/screens/order_history_screen.dart';
import 'package:primo/feature/splash_screen/splash_screen.dart';
import 'package:primo/feature/auth/presentation/screens/login_screen.dart';
import 'package:primo/feature/auth/presentation/screens/register_screen.dart';
import 'package:primo/feature/orders/presentation/bloc/checkout_cubit.dart';
import 'package:primo/feature/orders/presentation/screens/checkout.dart';
import 'package:primo/feature/profile/presentation/screen/edit_profile.dart';
import 'package:primo/feature/profile/presentation/screen/profile.dart';
import 'package:primo/feature/home/presentation/screen/home.dart';
import 'package:primo/feature/product/presentation/screen/product_details.dart';
import 'package:primo/feature/cart/presentation/screens/cart.dart';
import 'package:primo/feature/orders/presentation/screens/order_tracking.dart';
import 'package:primo/feature/admin_home/presentation/screen/admin_home_screen.dart';
import 'package:primo/feature/inventory/presentation/screen/inventory_screen.dart';
import 'package:primo/feature/admin_product/presentation/screen/add_product_screen.dart';
import 'package:primo/feature/admin_product/presentation/screen/edit_product_screen.dart';
import 'package:primo/feature/admin_orders/presentation/screen/admin_orders_screen.dart';
import 'package:primo/feature/admin_orders/presentation/screen/admin_order_details_screen.dart';
import 'package:primo/feature/direct_orders/presentation/screen/direct_orders_screen.dart';
import 'package:primo/feature/admin_categories/presentation/screen/admin_categories_screen.dart';
import 'package:primo/feature/admin_categories/presentation/screen/add_category_screen.dart';
import 'package:primo/feature/admin_offers/presentation/screen/create_offer_screen.dart';
import 'package:primo/feature/admin_suggestions/presentation/screen/admin_suggestions_screen.dart';
import 'package:primo/feature/suggestions/presentation/screens/suggest_product_page.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    // استخراج الـ arguments مسبقاً إذا وُجدت

    // final args = settings.arguments;

    switch (settings.name) {
      // ================== Auth & Splash ==================
      case Routes.splash:
        return CupertinoPageRoute(builder: (_) => const SplashScreen());
      case Routes.login:
        return CupertinoPageRoute(builder: (_) => const LoginScreen());
      case Routes.register:
        return CupertinoPageRoute(builder: (_) => const RegisterScreen());

      // ================== User App ==================
      case Routes.home:
        return CupertinoPageRoute(builder: (_) => const Home());
      case Routes.profile:
        return CupertinoPageRoute(builder: (_) => const Profile());
      case Routes.editProfile:
        return CupertinoPageRoute(builder: (_) => const EditProfile());

      // مثال احترافي لتمرير البيانات:
      case Routes.productDetails:
        return CupertinoPageRoute(builder: (_) => ProductDetails());

      case Routes.cart:
        return CupertinoPageRoute(builder: (_) => const Cart());
      case Routes.orderTracking:
        return CupertinoPageRoute(builder: (_) => const OrderTracking());
      case Routes.orderDetailsScreen:
        return CupertinoPageRoute(builder: (_) => const OrderDetailsScreen());
      case Routes.suggestProduct:
        return CupertinoPageRoute(builder: (_) => const SuggestProductPage());
      case Routes.favorites:
        return CupertinoPageRoute(builder: (_) => const FavoritesPage());
      case Routes.orderHistory:
        return CupertinoPageRoute(builder: (_) => const OrderHistoryScreen());
      case Routes.categories:
        return CupertinoPageRoute(builder: (_) => const AllCategoriesScreen());
      case Routes.addresses:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AddressesCubit(),
            child: const SavedAddressesScreen(),
          ),
        );

      // ================== Admin App ==================
      case Routes.adminHome:
        return CupertinoPageRoute(builder: (_) => const AdminHomeScreen());
      case Routes.adminInventory:
        return CupertinoPageRoute(builder: (_) => const InventoryScreen());
      case Routes.addProducts:
        return CupertinoPageRoute(builder: (_) => const AddProductScreen());
      case Routes.editProduct:
        return CupertinoPageRoute(builder: (_) => const EditProductScreen());
      case Routes.adminOrders:
        return CupertinoPageRoute(builder: (_) => const AdminOrdersScreen());
      case Routes.orderDetails:
        return CupertinoPageRoute(
          builder: (_) => const AdminOrderDetailsScreen(),
        );
      case Routes.directOrders:
        return CupertinoPageRoute(builder: (_) => const DirectOrdersScreen());
      case Routes.adminCategories:
        return CupertinoPageRoute(
          builder: (_) => const AdminCategoriesScreen(),
        );
      case Routes.addCategory:
        return CupertinoPageRoute(builder: (_) => const AddCategoryScreen());
      case Routes.adminOffers:
        return CupertinoPageRoute(builder: (_) => const CreateOfferScreen());
      case Routes.adminSuggestions:
        return CupertinoPageRoute(
          builder: (_) => const AdminSuggestionsScreen(),
        );

      // ================== Default & Checkout ==================
      case Routes.checkoutScreen:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CheckoutCubit(),
            child: const CheckoutScreen(),
          ),
        );

      default:
        return CupertinoPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("No route defined for this path")),
          ),
        );
    }
  }
}
