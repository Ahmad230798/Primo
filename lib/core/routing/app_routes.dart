import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: unused_import
import 'package:get_it/get_it.dart';
import 'package:primo/core/di/service_locator.dart';
import 'package:primo/core/models/order_model.dart';
import 'package:primo/core/routing/otp_enum.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/feature/admin_categories/presentation/cubit/admin_category_cubit.dart';
import 'package:primo/feature/admin_categories/presentation/cubit/admin_categories_list_cubit.dart';
import 'package:primo/feature/admin_offers/presentation/cubit/admin_offers_cubit.dart';
import 'package:primo/feature/admin_offers/presentation/cubit/admin_offers_list_cubit.dart';
import 'package:primo/feature/admin_orders/presentation/cubit/admin_orders_cubit.dart';
import 'package:primo/feature/admin_product/presentation/cubit/admin_product_cubit.dart';
import 'package:primo/feature/admin_product/presentation/cubit/admin_products_list_cubit.dart';
import 'package:primo/feature/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:primo/feature/auth/presentation/cubit/login_cubit.dart';
import 'package:primo/feature/auth/presentation/cubit/otp_cubit.dart';
import 'package:primo/feature/auth/presentation/cubit/register_cubit.dart';
import 'package:primo/feature/auth/presentation/cubit/reset_password_cubit.dart';
import 'package:primo/feature/auth/presentation/screens/forgot_password_screen.dart';
import 'package:primo/feature/auth/presentation/screens/otp_verification_screen.dart';
import 'package:primo/feature/auth/presentation/screens/reset_password_screen.dart';
import 'package:primo/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:primo/feature/main_layout/presentation/cubit/main_layout_cubit.dart';
import 'package:primo/feature/main_layout/presentation/screen/user_main_layout.dart';
import 'package:primo/feature/notifications/presentation/screen/notification_settings_screen.dart';
import 'package:primo/feature/notifications/presentation/cubit/notification_settings_cubit.dart';
import 'package:primo/feature/onboarding/onboardingscreen.dart';
import 'package:primo/feature/orders/presentation/bloc/orders_cubit.dart';
import 'package:primo/feature/suggestions/presentation/cubit/suggestions_cubit.dart';
import 'package:primo/feature/profile/presentation/screen/change_password_screen.dart';
import 'package:primo/feature/profile/presentation/screen/settings_screen.dart';
import 'package:primo/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:primo/feature/notifications/presentation/screen/notifications_history_screen.dart';
import 'package:primo/feature/profile/presentation/screen/help_center_screen.dart';
import 'package:primo/feature/profile/presentation/screen/privacy_policy_screen.dart';
import 'package:primo/feature/profile/presentation/screen/terms_of_use_screen.dart';
import 'package:primo/feature/search/presentation/screen/search_results_screen.dart';
import 'package:primo/feature/addresses/presentation/bloc/adresses_cubit.dart';
import 'package:primo/core/models/product_model.dart';
import 'package:primo/feature/home/presentation/cubit/home_cubit.dart';
import 'package:primo/feature/product/presentation/cubit/product_cubit.dart';
import 'package:primo/feature/categories/presentation/cubit/user_categories_cubit.dart';
import 'package:primo/feature/search/presentation/cubit/search_cubit.dart';
import 'package:primo/feature/favorites/presentation/cubit/favorites_cubit.dart';

import 'package:primo/core/models/category_model.dart';
import 'package:primo/core/models/offer_model.dart';
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
import 'package:primo/feature/admin_offers/presentation/screen/admin_offers_screen.dart';
import 'package:primo/feature/admin_suggestions/presentation/screen/admin_suggestions_screen.dart';
import 'package:primo/feature/suggestions/presentation/screens/suggest_product_page.dart';
import 'package:primo/feature/admin_home/presentation/cubit/admin_dashboard_cubit.dart';
import 'package:primo/feature/admin_settings/presentation/screen/admin_settings_screen.dart';
import 'package:primo/feature/admin_settings/presentation/cubit/store_settings_cubit.dart';
import 'package:primo/feature/admin_settings/presentation/cubit/add_store_address_cubit.dart';

class AppRoutes {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ================== Auth & Splash ==================
      case Routes.splash:
        return CupertinoPageRoute(builder: (_) => const SplashScreen());
      case Routes.onboarding:
        return CupertinoPageRoute(builder: (_) => const OnboardingScreen());
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
              // 💡 تم إزالة دوال الجلب لتخفيف الضغط عند فتح التطبيق
              BlocProvider(create: (context) => getIt<ProfileCubit>()),
              BlocProvider(create: (context) => getIt<AddressesCubit>()),
              BlocProvider(create: (context) => getIt<UserCategoriesCubit>()),
              BlocProvider(create: (context) => getIt<OrdersCubit>()),

              // 💡 هذه الـ Cubits فقط التي نحتاجها فوراً في الشاشة الرئيسية:
              BlocProvider(
                create: (context) => getIt<HomeCubit>()..fetchHomeData(),
              ),
              BlocProvider.value(value: getIt<FavoritesCubit>()),
              BlocProvider.value(
                value: getIt<CartCubit>()..getCart(),
              ), // لأجل أيقونة الإشعارات

              BlocProvider(create: (context) => MainLayoutCubit()),
            ],
            child: UserMainLayout(),
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
              BlocProvider(create: (_) => getIt<HomeCubit>()..fetchHomeData()),
              BlocProvider.value(value: getIt<FavoritesCubit>()),
            ],
            child: const Home(),
          ),
        );
      case Routes.profile:
        return CupertinoPageRoute(
          builder: (_) {
            final cubit =
                settings.arguments as ProfileCubit? ??
                (getIt<ProfileCubit>()..getProfile());
            return BlocProvider.value(
              value: cubit,
              child: const Profile(isFromBottomNav: false),
            );
          },
        );
      case Routes.editProfile:
        return CupertinoPageRoute(
          builder: (_) {
            final cubit =
                settings.arguments as ProfileCubit? ??
                (getIt<ProfileCubit>()..getProfile());
            return BlocProvider.value(value: cubit, child: const EditProfile());
          },
        );

      // مثال احترافي لتمرير البيانات:
      case Routes.productDetails:
        return CupertinoPageRoute(
          builder: (_) {
            final arg = settings.arguments;
            int productId = 1;
            ProductModel? initProduct;
            OfferModel? initOffer;
            if (arg is ProductModel) {
              initProduct = arg;
              if (arg.id != null) productId = arg.id!;
            } else if (arg is OfferModel) {
              initOffer = arg;
              initProduct = arg.variant?.product;
              if (arg.productId != null) {
                productId = arg.productId!;
              } else if (arg.variant?.productId != null) {
                productId = arg.variant!.productId!;
              } else if (arg.variant?.product?.id != null) {
                productId = arg.variant!.product!.id!;
              } else if (arg.variantId != null) {
                productId = arg.variantId!;
              } else if (arg.id != null) {
                productId = arg.id!;
              }
            } else if (arg is int) {
              productId = arg;
            } else if (arg is Map) {
              if (arg['id'] != null) productId = arg['id'];
              if (arg['product'] is ProductModel) initProduct = arg['product'];
              if (arg['offer'] is OfferModel) initOffer = arg['offer'];
            }
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      getIt<ProductCubit>()..getProductDetails(productId),
                ),
                BlocProvider.value(value: getIt<FavoritesCubit>()),
              ],
              child: ProductDetails(
                initialProduct: initProduct,
                initialOffer: initOffer,
              ),
            );
          },
        );

      case Routes.cart:
        return CupertinoPageRoute(
          // 💡 تم التعديل إلى .value لأننا نستعير السلة العامة ولا ننشئ واحدة جديدة
          builder: (_) => BlocProvider.value(
            value: getIt<CartCubit>()..getCart(),
            child: const Cart(isFromBottomNav: false),
          ),
        );
      case Routes.orderTracking:
        final orderArg = settings.arguments as OrderModel?;
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) {
              final cubit = getIt<OrdersCubit>();
              if (orderArg != null) {
                cubit.getOrderDetails(orderArg.id); // جلب التفاصيل الحية
              }
              return cubit;
            },
            child: OrderTracking(orderArg: orderArg),
          ),
        );
      case Routes.notifications:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<NotificationSettingsCubit>(),
            child: const NotificationSettingsScreen(),
          ),
        );
      case Routes.notificationsHistory:
        return CupertinoPageRoute(
          builder: (_) => const NotificationsHistoryScreen(),
        );
      case Routes.helpCenter:
        return CupertinoPageRoute(builder: (_) => const HelpCenterScreen());
      case Routes.privacyPolicy:
        return CupertinoPageRoute(builder: (_) => const PrivacyPolicyScreen());
      case Routes.termsOfUse:
        return CupertinoPageRoute(builder: (_) => const TermsOfUseScreen());
      case Routes.searchResults:
        return CupertinoPageRoute(
          builder: (_) {
            final query = settings.arguments as String? ?? "";
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      getIt<SearchCubit>()..searchProducts(query),
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
            final cubit =
                settings.arguments as ProfileCubit? ?? getIt<ProfileCubit>();
            return BlocProvider.value(
              value: cubit,
              child: const SettingsScreen(isFromBottomNav: false),
            );
          },
        );
      case Routes.changePassword:
        return CupertinoPageRoute(
          builder: (_) {
            final cubit =
                settings.arguments as ProfileCubit? ?? getIt<ProfileCubit>();
            return BlocProvider.value(
              value: cubit,
              child: const ChangePasswordScreen(),
            );
          },
        );
      case Routes.orderDetailsScreen:
        final order = settings.arguments as OrderModel?; // استلام الداتا
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) {
              final cubit = getIt<OrdersCubit>();
              if (order != null) {
                cubit.getOrderDetails(order.id);
              }
              return cubit;
            },
            child: OrderDetailsScreen(orderArg: order),
          ), // تمريرها للشاشة
        );
      case Routes.suggestProduct:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<SuggestionsCubit>(),

            child: const SuggestProductPage(isFromBottomNav: false),
          ),
        );
      case Routes.favorites:
        return CupertinoPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: getIt<FavoritesCubit>()
                  ..fetchFavorites(showLoading: false),
              ),
            ],
            child: const FavoritesPage(isFromBottomNav: false),
          ),
        );
      case Routes.orderHistory:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<OrdersCubit>()..getOrders(),
            child: const OrderHistoryScreen(isFromBottomNav: false),
          ),
        );
      case Routes.categories:
        return CupertinoPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => getIt<UserCategoriesCubit>()..fetchCategories(),
              ),
              BlocProvider(create: (_) => getIt<HomeCubit>()),
              // 💡 Singleton نستخدم value
              BlocProvider.value(value: getIt<FavoritesCubit>()),
            ],
            child: const AllCategoriesScreen(isFromBottomNav: false),
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
              if (arg['id'] != null) {
                categoryId = int.tryParse(arg['id'].toString()) ?? 1;
              }
              if (arg['name'] != null) {
                categoryName = arg['name'].toString();
              }
            }
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => getIt<CategoryProductsCubit>()
                    ..fetchCategoryProducts(
                      categoryId,
                      categoryName: categoryName,
                    ),
                ),
                BlocProvider.value(value: getIt<FavoritesCubit>()),
              ],
              child: CategoryProductsScreen(
                categoryName: categoryName ?? "منتجات القسم",
              ),
            );
          },
        );
      case Routes.addresses:
        return CupertinoPageRoute(
          builder: (_) {
            final cubit =
                settings.arguments as AddressesCubit? ??
                (getIt<AddressesCubit>()..getAddresses());
            return BlocProvider.value(
              value: cubit,
              child: const SavedAddressesScreen(),
            );
          },
        );

      // ================== Admin App ==================
      case Routes.adminHome:
        return CupertinoPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => getIt<AdminDashboardCubit>()..getDashboard(),
              ),
              BlocProvider(create: (context) => getIt<ProfileCubit>()),
            ],
            child: const AdminHomeScreen(),
          ),
        );
      case Routes.adminInventory:
        return CupertinoPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<AdminProductsListCubit>()),
              BlocProvider.value(value: getIt<AdminProductCubit>()),
            ],
            child: const InventoryScreen(),
          ),
        );
      case Routes.addProducts:
        return CupertinoPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: getIt<AdminProductCubit>()
                  ..clearForm()
                  ..loadCategories(),
              ),
              BlocProvider.value(value: getIt<AdminProductsListCubit>()),
              BlocProvider(create: (context) => getIt<ProfileCubit>()),
            ],
            child: const AddProductScreen(),
          ),
        );
      case Routes.editProduct:
        final prodCubit = getIt<AdminProductCubit>();
        if (settings.arguments is ProductModel) {
          prodCubit.initForEdit(settings.arguments as ProductModel);
        }
        prodCubit.loadCategories();
        return CupertinoPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: prodCubit),
              BlocProvider.value(value: getIt<AdminProductsListCubit>()),
            ],
            child: const EditProductScreen(),
          ),
        );
      case Routes.adminOrders: // استخدم اسم المسار الخاص بك لشاشة الطلبات
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            // 💡 توفير الكيوبت هنا (مع استدعاء دالة جلب الطلبات فوراً إذا أردت)
            create: (context) =>
                getIt<AdminOrdersCubit>()
                  ..getOrders(), // استبدل getOrders باسم الدالة لديك
            child: const AdminOrdersScreen(), // اسم شاشة الطلبات الخاصة بك
          ),
        );
      case Routes.orderDetails:
        // 💡 استخراج الـ OrderModel الممرر كـ argument بأمان
        final order = settings.arguments as OrderModel?;

        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            // 💡 السحر هنا: نطلب التفاصيل الكاملة بالـ ID فور إنشاء الكيوبت
            create: (context) {
              final cubit = getIt<AdminOrdersCubit>();
              if (order?.id != null) {
                cubit.getOrderDetails(order!.id);
              }
              return cubit;
            },
            child: AdminOrderDetailsScreen(
              orderArg: order,
            ), // تمرير الـ argument للشاشة
          ),
        );
      case Routes.directOrders:
        return CupertinoPageRoute(builder: (_) => const DirectOrdersScreen());
      case Routes.adminCategories:
        return CupertinoPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<AdminCategoriesListCubit>()),
              BlocProvider.value(value: getIt<AdminCategoryCubit>()),
              BlocProvider(create: (context) => getIt<ProfileCubit>()),
            ],
            child: const AdminCategoriesScreen(),
          ),
        );
      case Routes.addCategory:
        final catCubit = getIt<AdminCategoryCubit>();
        if (settings.arguments is CategoryModel) {
          catCubit.initForEdit(settings.arguments as CategoryModel);
        } else {
          catCubit.clearForAdd();
        }
        return CupertinoPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: catCubit),
              BlocProvider.value(value: getIt<AdminCategoriesListCubit>()),
            ],
            child: const AddCategoryScreen(),
          ),
        );
      case Routes.adminOffers: // استخدم اسم المسار الخاص بك
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              // 1. كيوبت إنشاء وتعديل العروض (للـ Form)
              BlocProvider(create: (context) => getIt<AdminOffersCubit>()),

              // 2. كيوبت المنتجات (لكي تعمل القائمة المنسدلة للأنواع)
              BlocProvider(
                create: (context) => getIt<AdminProductsListCubit>(),
              ),

              // 3. 💡 كيوبت قائمة العروض (هذا هو المفقود الذي يسبب الشاشة الحمراء الآن!)
              BlocProvider(
                create: (context) => getIt<AdminOffersListCubit>()..getOffers(),
              ),
              BlocProvider(create: (context) => getIt<ProfileCubit>()),
            ],
            child: const AdminOffersScreen(),
          ),
        );
      case Routes.createOffer:
        return CupertinoPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<AdminOffersCubit>()),
              BlocProvider.value(value: getIt<AdminOffersListCubit>()),
              BlocProvider.value(
                value: getIt<AdminProductsListCubit>()..getProducts(),
              ),
            ],
            child: const CreateOfferScreen(),
          ),
        );
      case Routes.adminSuggestions:
        return CupertinoPageRoute(
          builder: (_) => const AdminSuggestionsScreen(),
        );
      case Routes.adminSettings:
        return CupertinoPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<StoreSettingsCubit>()),
              BlocProvider(create: (_) => getIt<AddStoreAddressCubit>()),
              BlocProvider(create: (context) => getIt<ProfileCubit>()),
            ],
            child: const AdminSettingsScreen(),
          ),
        );

      // ================== Default & Checkout ==================
      // في ملف AppRoutes.dart
      case Routes.checkoutScreen:
        return CupertinoPageRoute(
          builder: (_) {
            // 1. 💡 إنشاء نسخة واحدة فقط من الكيوبت هنا
            final addressesCubit = getIt<AddressesCubit>()
              ..getAddresses(showLoading: false);
            final defaultId = addressesCubit.defaultAddressId?.toString();

            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      getIt<CheckoutCubit>()..initCheckout(defaultId),
                ),
                // 2. 💡 تمرير نفس النسخة التي أنشأناها لواجهة المستخدم
                BlocProvider.value(value: addressesCubit),
              ],
              child: const CheckoutScreen(),
            );
          },
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
