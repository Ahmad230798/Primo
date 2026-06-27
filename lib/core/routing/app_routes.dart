import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/feature/auth/presentation/screens/forgot_password_screen.dart';
import 'package:primo/feature/auth/presentation/screens/otp_verification_screen.dart';
import 'package:primo/feature/auth/presentation/screens/reset_password_screen.dart';
import 'package:primo/feature/main_layout/presentation/screen/user_main_layout.dart';
import 'package:primo/feature/notifications/presentation/screen/notifications_screen.dart';
import 'package:primo/feature/profile/presentation/screen/change_password_screen.dart';
import 'package:primo/feature/profile/presentation/screen/settings_screen.dart';
import 'package:primo/feature/search/presentation/screen/search_results_screen.dart';

// --- Auth & Profile ---
import 'package:primo/feature/splash_screen/splash_screen.dart';
import 'package:primo/feature/auth/presentation/screens/login_screen.dart';
import 'package:primo/feature/auth/presentation/screens/register_screen.dart';
import 'package:primo/feature/orders/presentation/bloc/checkout_cubit.dart';
import 'package:primo/feature/orders/presentation/screens/checkout.dart';
import 'package:primo/feature/profile/presentation/screen/edit_profile.dart';
import 'package:primo/feature/profile/presentation/screen/profile.dart';

// --- User Features ---
import 'package:primo/feature/home/presentation/screen/home.dart';
import 'package:primo/feature/product/presentation/screen/product_details.dart';
import 'package:primo/feature/cart/presentation/screens/cart.dart';
import 'package:primo/feature/orders/presentation/screens/order_tracking.dart';

// --- Admin Features ---
import 'package:primo/feature/admin_home/presentation/screen/admin_home_screen.dart';
import 'package:primo/feature/inventory/presentation/screen/inventory_screen.dart';
import 'package:primo/feature/admin_product/presentation/screen/add_product_screen.dart';
import 'package:primo/feature/admin_product/presentation/screen/edit_product_screen.dart';
import 'package:primo/feature/admin_orders/presentation/screen/admin_orders_screen.dart';
import 'package:primo/feature/admin_orders/presentation/screen/order_details_screen.dart';
import 'package:primo/feature/direct_orders/presentation/screen/direct_orders_screen.dart';
import 'package:primo/feature/admin_categories/presentation/screen/admin_categories_screen.dart';
import 'package:primo/feature/admin_categories/presentation/screen/add_category_screen.dart';
import 'package:primo/feature/admin_offers/presentation/screen/create_offer_screen.dart';
import 'package:primo/feature/admin_suggestions/presentation/screen/admin_suggestions_screen.dart';

class AppRoutes {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ================== Auth & Splash ==================
      case Routes.splash:
        return CupertinoPageRoute(builder: (_) => const SplashScreen());
      case Routes.login:
        return CupertinoPageRoute(builder: (_) => const LoginScreen());
      case Routes.register:
        return CupertinoPageRoute(builder: (_) => const RegisterScreen());
      case Routes.userMainLayout:
        return CupertinoPageRoute(builder: (_) => const UserMainLayout());
      case Routes.changePassword:
        return CupertinoPageRoute(builder: (_) => const ChangePasswordScreen());
      case Routes.forgotPassword:
        return CupertinoPageRoute(builder: (_) => const ForgotPasswordScreen());
      case Routes.otpVerification:
        return CupertinoPageRoute(
          builder: (_) => const OtpVerificationScreen(),
        );
      case Routes.resetPassword:
        return CupertinoPageRoute(builder: (_) => const ResetPasswordScreen());

      // ================== User App ==================
      case Routes.home:
        return CupertinoPageRoute(builder: (_) => const Home());
      case Routes.profile:
        return CupertinoPageRoute(builder: (_) => const Profile());
      case Routes.editProfile:
        return CupertinoPageRoute(builder: (_) => const EditProfile());
      case Routes.productDetails:
        return CupertinoPageRoute(builder: (_) => const ProductDetails());
      case Routes.cart:
        return CupertinoPageRoute(builder: (_) => const Cart());
      case Routes.orderTracking:
        return CupertinoPageRoute(builder: (_) => const OrderTracking());
      case Routes.notifications:
        return CupertinoPageRoute(builder: (_) => const NotificationsScreen());
      case Routes.searchResults:
        return CupertinoPageRoute(builder: (_) => const SearchResultsScreen());
      case Routes.settings:
        return CupertinoPageRoute(builder: (_) => const SettingsScreen());

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
        return CupertinoPageRoute(builder: (_) => const OrderDetailsScreen());
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

      // ================== Default ==================
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
