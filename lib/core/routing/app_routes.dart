import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/core/di/service_locator.dart';
import 'package:primo/core/routing/otp_enum.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/feature/admin_categories/presentation/cubit/admin_category_cubit.dart';
import 'package:primo/feature/admin_offers/presentation/cubit/admin_offers_cubit.dart';
import 'package:primo/feature/admin_product/presentation/cubit/admin_product_cubit.dart';
import 'package:primo/feature/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:primo/feature/auth/presentation/cubit/login_cubit.dart';
import 'package:primo/feature/auth/presentation/cubit/otp_cubit.dart';
import 'package:primo/feature/auth/presentation/cubit/register_cubit.dart';
import 'package:primo/feature/auth/presentation/cubit/reset_password_cubit.dart';
import 'package:primo/feature/auth/presentation/screens/forgot_password_screen.dart';
import 'package:primo/feature/auth/presentation/screens/otp_verification_screen.dart';
import 'package:primo/feature/auth/presentation/screens/reset_password_screen.dart';
import 'package:primo/feature/main_layout/presentation/screen/user_main_layout.dart';
import 'package:primo/feature/notifications/presentation/screen/notifications_screen.dart';
import 'package:primo/feature/profile/presentation/screen/change_password_screen.dart';
import 'package:primo/feature/profile/presentation/screen/settings_screen.dart';
import 'package:primo/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:primo/feature/search/presentation/screen/search_results_screen.dart';
import 'package:primo/feature/addresses/presentation/bloc/adresses_cubit.dart';
import 'package:primo/core/models/product_model.dart';
import 'package:primo/feature/home/presentation/cubit/home_cubit.dart';
import 'package:primo/feature/product/presentation/cubit/product_cubit.dart';
import 'package:primo/feature/categories/presentation/cubit/user_categories_cubit.dart';
import 'package:primo/feature/search/presentation/cubit/search_cubit.dart';
import 'package:primo/feature/favorites/presentation/cubit/favorites_cubit.dart';

import 'package:primo/core/models/category_model.dart';
import 'package:primo/feature/categories/presentation/cubit/category_products_cubit.dart';
import 'package:primo/feature/categories/presentation/screen/category_products_screen.dart';
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
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ================== Auth & Splash ==================
      case Routes.splash:
        return CupertinoPageRoute(builder: (_) => const SplashScreen());
      case Routes.login:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: const LoginScreen(),
          ),
        );
      case Routes.register:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<RegisterCubit>(),
            child: const RegisterScreen(),
          ),
        );
      case Routes.userMainLayout:
        return CupertinoPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => getIt<ProfileCubit>()..getProfile(),
              ),
              BlocProvider(
                create: (context) => getIt<AddressesCubit>()..getAddresses(),
              ),
              BlocProvider(
                create: (context) => getIt<HomeCubit>()..fetchHomeData(),
              ),
              BlocProvider(
                create: (context) => getIt<UserCategoriesCubit>()..fetchCategories(),
              ),
              BlocProvider(
                create: (context) => getIt<FavoritesCubit>()..fetchFavorites(),
              ),
            ],
            child: const UserMainLayout(),
          ),
        );
      case Routes.forgotPassword:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ForgotPasswordCubit>(),
            child: const ForgotPasswordScreen(),
          ),
        );
      case Routes.otpVerification:
        final args =
            settings.arguments as OtpVerificationArgs; // استلام الكلاس المجمع
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<OtpCubit>()..checkAndStartTimer(),
            child: OtpVerificationScreen(
              args: args,
            ), // تمرير الكائن بالكامل للشاشة
          ),
        );
      case Routes.resetPassword:
        final args =
            settings.arguments as String; // استلام رقم الهاتف من الشاشة السابقة
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ResetPasswordCubit>(),
            child: ResetPasswordScreen(
              phoneNumber: args,
            ), // تمرير رقم الهاتف للشاشة
          ),
        );

      // ================== User App ==================
      case Routes.home:
        return CupertinoPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<HomeCubit>()..fetchHomeData()),
              BlocProvider.value(value: getIt<FavoritesCubit>()),
            ],
            child: const Home(),
          ),
        );
      case Routes.profile:
        return CupertinoPageRoute(
          builder: (_) {
            final cubit = settings.arguments as ProfileCubit? ?? (getIt<ProfileCubit>()..getProfile());
            return BlocProvider.value(
              value: cubit,
              child: const Profile(),
            );
          },
        );
      case Routes.editProfile:
        return CupertinoPageRoute(
          builder: (_) {
            final cubit = settings.arguments as ProfileCubit? ?? (getIt<ProfileCubit>()..getProfile());
            return BlocProvider.value(
              value: cubit,
              child: const EditProfile(),
            );
          },
        );

      // مثال احترافي لتمرير البيانات:
      case Routes.productDetails:
        return CupertinoPageRoute(
          builder: (_) {
            final arg = settings.arguments;
            int productId = 1;
            ProductModel? initProduct;
            if (arg is ProductModel) {
              initProduct = arg;
              if (arg.id != null) productId = arg.id!;
            } else if (arg is int) {
              productId = arg;
            } else if (arg is Map && arg['id'] != null) {
              productId = arg['id'];
            }
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => getIt<ProductCubit>()..getProductDetails(productId),
                ),
                BlocProvider.value(value: getIt<FavoritesCubit>()),
              ],
              child: ProductDetails(initialProduct: initProduct),
            );
          },
        );

      case Routes.cart:
        return CupertinoPageRoute(builder: (_) => const Cart());
      case Routes.orderTracking:
        return CupertinoPageRoute(builder: (_) => const OrderTracking());
      case Routes.notifications:
        return CupertinoPageRoute(builder: (_) => const NotificationsScreen());
      case Routes.searchResults:
        return CupertinoPageRoute(
          builder: (_) {
            final query = settings.arguments as String? ?? "";
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => getIt<SearchCubit>()..searchProducts(query),
                ),
                BlocProvider.value(value: getIt<FavoritesCubit>()),
              ],
              child: const SearchResultsScreen(),
            );
          },
        );
      case Routes.settings:
        return CupertinoPageRoute(
          builder: (_) {
            final cubit = settings.arguments as ProfileCubit? ?? getIt<ProfileCubit>();
            return BlocProvider.value(
              value: cubit,
              child: const SettingsScreen(),
            );
          },
        );
      case Routes.changePassword:
        return CupertinoPageRoute(
          builder: (_) {
            final cubit = settings.arguments as ProfileCubit? ?? getIt<ProfileCubit>();
            return BlocProvider.value(
              value: cubit,
              child: const ChangePasswordScreen(),
            );
          },
        );
      case Routes.orderDetailsScreen:
        return CupertinoPageRoute(builder: (_) => const OrderDetailsScreen());
      case Routes.suggestProduct:
        return CupertinoPageRoute(builder: (_) => const SuggestProductPage());
      case Routes.favorites:
        return CupertinoPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<FavoritesCubit>()..fetchFavorites()),
            ],
            child: const FavoritesPage(),
          ),
        );
      case Routes.orderHistory:
        return CupertinoPageRoute(builder: (_) => const OrderHistoryScreen());
      case Routes.categories:
        return CupertinoPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<UserCategoriesCubit>()..fetchCategories()),
              BlocProvider.value(value: getIt<HomeCubit>()),
              BlocProvider.value(value: getIt<FavoritesCubit>()),
            ],
            child: const AllCategoriesScreen(),
          ),
        );
      case Routes.categoryProducts:
        return CupertinoPageRoute(
          builder: (_) {
            final arg = settings.arguments;
            int categoryId = 1;
            String? categoryName;
            if (arg is CategoryModel) {
              categoryId = arg.id ?? 1;
              categoryName = arg.name;
            } else if (arg is int) {
              categoryId = arg;
            } else if (arg is Map) {
              if (arg['id'] != null) categoryId = int.tryParse(arg['id'].toString()) ?? 1;
              if (arg['name'] != null) categoryName = arg['name'].toString();
            }
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => getIt<CategoryProductsCubit>()..fetchCategoryProducts(categoryId, categoryName: categoryName),
                ),
                BlocProvider.value(value: getIt<FavoritesCubit>()),
              ],
              child: CategoryProductsScreen(categoryName: categoryName ?? "منتجات القسم"),
            );
          },
        );
      case Routes.addresses:
        return CupertinoPageRoute(
          builder: (_) {
            final cubit = settings.arguments as AddressesCubit? ?? (getIt<AddressesCubit>()..getAddresses());
            return BlocProvider.value(
              value: cubit,
              child: const SavedAddressesScreen(),
            );
          },
        );

      // ================== Admin App ==================
      case Routes.adminHome:
        return CupertinoPageRoute(builder: (_) => const AdminHomeScreen());
      case Routes.adminInventory:
        return CupertinoPageRoute(builder: (_) => const InventoryScreen());
      case Routes.addProducts:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                getIt<AdminProductCubit>()
                  ..loadCategories(), // جلب الأقسام فور فتح الشاشة
            child: const AddProductScreen(),
          ),
        );
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
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<AdminCategoryCubit>(),
            child: const AddCategoryScreen(),
          ),
        );
      case Routes.adminOffers:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<AdminOffersCubit>(),
            child: const CreateOfferScreen(),
          ),
        );
      case Routes.adminSuggestions:
        return CupertinoPageRoute(
          builder: (_) => const AdminSuggestionsScreen(),
        );

      // ================== Default & Checkout ==================
      case Routes.checkoutScreen:
        return CupertinoPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) {
                  final addressesCubit = getIt<AddressesCubit>()..getAddresses(showLoading: false);
                  final defaultId = addressesCubit.defaultAddressId?.toString();
                  return getIt<CheckoutCubit>()..initCheckout(defaultId);
                },
              ),
              BlocProvider.value(
                value: getIt<AddressesCubit>()..getAddresses(showLoading: false),
              ),
            ],
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
