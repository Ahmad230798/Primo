import 'package:get_it/get_it.dart';
import 'package:primo/core/services/firebase_messaging_service.dart';
import 'package:primo/feature/addresses/domain/usecases/get_default_address_usecase.dart';
import 'package:primo/feature/addresses/domain/usecases/save_default_address_usecase.dart';
import 'package:primo/feature/admin_orders/data/repos/admin_orders_repo_impl.dart';
import 'package:primo/feature/admin_orders/domain/repo/admin_orders_repo.dart';
import 'package:primo/feature/admin_orders/domain/usecases/get_admin_order_details_usecase.dart';
import 'package:primo/feature/admin_orders/domain/usecases/get_admin_orders_usecase.dart';
import 'package:primo/feature/admin_orders/domain/usecases/update_order_status_usecase.dart';
import 'package:primo/feature/admin_orders/presentation/cubit/admin_orders_cubit.dart';
import 'package:primo/feature/admin_suggestions/data/repos/admin_suggestions_repo_impl.dart';
import 'package:primo/feature/admin_suggestions/domain/repo/admin_suggestions_repo.dart';
import 'package:primo/feature/admin_suggestions/domain/usecases/get_admin_suggestions_usecase.dart';
import 'package:primo/feature/admin_suggestions/domain/usecases/update_suggestion_status_usecase.dart';
import 'package:primo/feature/admin_suggestions/presentation/cubit/admin_suggestions_cubit.dart';
import 'package:primo/feature/admin_categories/data/repos/admin_category_repo_impl.dart';
import 'package:primo/feature/admin_categories/domain/repo/admin_category_repo.dart';
import 'package:primo/feature/admin_categories/domain/usecases/add_category_usecase.dart';
import 'package:primo/feature/admin_categories/presentation/cubit/admin_category_cubit.dart';
import 'package:primo/feature/admin_offers/data/repos/admin_offers_repo_impl.dart';
import 'package:primo/feature/admin_offers/domain/repo/admin_offers_repo.dart';
import 'package:primo/feature/admin_offers/domain/usecases/create_offer_usecase.dart';
import 'package:primo/feature/admin_offers/presentation/cubit/admin_offers_cubit.dart';
import 'package:primo/feature/admin_product/data/repos/admin_product_repo_impl.dart';
import 'package:primo/feature/admin_product/domain/repo/admin_product_repo.dart';
import 'package:primo/feature/admin_product/domain/usecases/get_categories_usecase.dart';
import 'package:primo/feature/admin_product/domain/usecases/get_products_usecase.dart';
import 'package:primo/feature/admin_product/domain/usecases/manage_product_usecase.dart';
import 'package:primo/feature/admin_product/presentation/cubit/admin_product_cubit.dart';
import 'package:primo/feature/auth/data/repos/auth_repo_impl.dart';
import 'package:primo/feature/auth/domain/repo/auth_repo.dart';
import 'package:primo/feature/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:primo/feature/auth/domain/usecases/log_out_usecase.dart';
import 'package:primo/feature/auth/domain/usecases/login_usecase.dart';
import 'package:primo/feature/auth/domain/usecases/register_usecase.dart';
import 'package:primo/feature/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:primo/feature/auth/domain/usecases/reset_password_use_case.dart';
import 'package:primo/feature/auth/domain/usecases/verify_forget_password_otp_usecase.dart';
import 'package:primo/feature/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:primo/feature/auth/domain/usecases/confirm_login_usecase.dart';
import 'package:primo/feature/auth/domain/usecases/delete_account_usecase.dart';
import 'package:primo/feature/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:primo/feature/auth/presentation/cubit/login_cubit.dart';
import 'package:primo/feature/auth/presentation/cubit/otp_cubit.dart';
import 'package:primo/feature/auth/presentation/cubit/register_cubit.dart';
import 'package:primo/feature/auth/presentation/cubit/reset_password_cubit.dart';
import 'package:primo/feature/addresses/data/repos/addresses_repo_impl.dart';
import 'package:primo/feature/addresses/domain/repo/addresses_repo.dart';
import 'package:primo/feature/addresses/domain/usecases/get_addresses_usecase.dart';
import 'package:primo/feature/addresses/domain/usecases/get_address_by_id_usecase.dart';
import 'package:primo/feature/addresses/domain/usecases/create_address_usecase.dart';
import 'package:primo/feature/addresses/domain/usecases/update_address_usecase.dart';
import 'package:primo/feature/addresses/domain/usecases/delete_address_usecase.dart';
import 'package:primo/feature/addresses/presentation/bloc/adresses_cubit.dart';
import 'package:primo/feature/notifications/domain/usecases/get_last_seen_notification_usecase.dart';
import 'package:primo/feature/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:primo/feature/notifications/domain/usecases/save_last_seen_notification_usecase.dart';
import 'package:primo/feature/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:primo/feature/orders/data/repos/orders_repo_impl.dart';
import 'package:primo/feature/orders/domain/repos/orders_repo.dart';
import 'package:primo/feature/orders/domain/usecases/confirm_order_usecase.dart';
import 'package:primo/feature/orders/domain/usecases/get_order_by_id_usecase.dart';
import 'package:primo/feature/orders/domain/usecases/get_order_price_usecase.dart';
import 'package:primo/feature/orders/domain/usecases/get_orders_usecase.dart';
import 'package:primo/feature/orders/domain/usecases/rate_product_in_order_usecase.dart';
import 'package:primo/feature/orders/presentation/bloc/checkout_cubit.dart';
import 'package:primo/feature/orders/presentation/bloc/orders_cubit.dart';
import 'package:primo/feature/profile/data/repos/profile_repo_impl.dart';
import 'package:primo/feature/profile/domain/repo/profile_repo.dart';
import 'package:primo/feature/profile/domain/usecases/get_profile_usecase.dart';
import 'package:primo/feature/profile/domain/usecases/update_profile_usecase.dart';
import 'package:primo/feature/profile/domain/usecases/change_password_usecase.dart';
import 'package:primo/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:primo/feature/home/data/repos/home_repo_impl.dart';
import 'package:primo/feature/home/domain/repo/home_repo.dart';
import 'package:primo/feature/home/domain/usecases/get_home_data_usecase.dart';
import 'package:primo/feature/home/presentation/cubit/home_cubit.dart';
import 'package:primo/feature/product/data/repos/product_repo_impl.dart';
import 'package:primo/feature/product/domain/repo/product_repo.dart';
import 'package:primo/feature/product/domain/usecases/get_product_details_usecase.dart';
import 'package:primo/feature/product/presentation/cubit/product_cubit.dart';
import 'package:primo/feature/categories/data/repos/user_categories_repo_impl.dart';
import 'package:primo/feature/categories/domain/repo/user_categories_repo.dart';
import 'package:primo/feature/categories/domain/usecases/get_user_categories_usecase.dart';
import 'package:primo/feature/categories/domain/usecases/get_category_products_usecase.dart';
import 'package:primo/feature/categories/presentation/cubit/user_categories_cubit.dart';
import 'package:primo/feature/categories/presentation/cubit/category_products_cubit.dart';
import 'package:primo/feature/search/presentation/cubit/search_cubit.dart';
import 'package:primo/feature/favorites/data/repos/favorites_repo_impl.dart';
import 'package:primo/feature/favorites/domain/repo/favorites_repo.dart';
import 'package:primo/feature/favorites/domain/usecases/get_favorites_usecase.dart';
import 'package:primo/feature/favorites/domain/usecases/toggle_favorite_usecase.dart';
import 'package:primo/feature/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:primo/feature/cart/data/repos/cart_repo_impl.dart';
import 'package:primo/feature/cart/domain/repos/cart_repo.dart';
import 'package:primo/feature/cart/domain/usecases/get_cart_usecase.dart';
import 'package:primo/feature/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:primo/feature/cart/domain/usecases/update_cart_quantity_usecase.dart';
import 'package:primo/feature/cart/domain/usecases/delete_from_cart_usecase.dart';
import 'package:primo/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:primo/feature/notifications/data/repos/notification_settings_repo_impl.dart';
import 'package:primo/feature/notifications/domain/repos/notification_settings_repo.dart';
import 'package:primo/feature/notifications/domain/usecases/get_notification_settings_usecase.dart';
import 'package:primo/feature/notifications/domain/usecases/update_notification_settings_usecase.dart';
import 'package:primo/feature/notifications/presentation/cubit/notification_settings_cubit.dart';
import 'package:primo/feature/suggestions/data/repos/suggestions_repo_impl.dart';
import 'package:primo/feature/suggestions/domain/repos/suggestions_repo.dart';
import 'package:primo/feature/suggestions/domain/usecases/send_suggestion_usecase.dart';
import 'package:primo/feature/suggestions/presentation/cubit/suggestions_cubit.dart';
import 'package:primo/feature/admin_home/data/repos/admin_dashboard_repo_impl.dart';
import 'package:primo/feature/admin_home/domain/repos/admin_dashboard_repo.dart';
import 'package:primo/feature/admin_home/domain/usecases/get_admin_dashboard_usecase.dart';
import 'package:primo/feature/admin_home/presentation/cubit/admin_dashboard_cubit.dart';
import 'package:primo/feature/admin_settings/data/repos/store_settings_repo_impl.dart';
import 'package:primo/feature/admin_settings/domain/repos/store_settings_repo.dart';
import 'package:primo/feature/admin_settings/domain/usecases/add_store_address_usecase.dart';
import 'package:primo/feature/admin_settings/domain/usecases/get_delivery_price_usecase.dart';
import 'package:primo/feature/admin_settings/domain/usecases/update_delivery_price_usecase.dart';
import 'package:primo/feature/admin_settings/presentation/cubit/add_store_address_cubit.dart';
import 'package:primo/feature/admin_settings/presentation/cubit/store_settings_cubit.dart';
import 'package:primo/feature/admin_product/presentation/cubit/admin_products_list_cubit.dart';
import 'package:primo/feature/admin_categories/domain/usecases/manage_category_usecase.dart';
import 'package:primo/feature/admin_categories/presentation/cubit/admin_categories_list_cubit.dart';
import 'package:primo/feature/admin_offers/domain/usecases/manage_offers_usecase.dart';
import 'package:primo/feature/admin_offers/presentation/cubit/admin_offers_list_cubit.dart';
import '../network/api_consumer.dart';
import '../network/dio_factory.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // 1. النواة والشبكة (Core / Network)
  getIt.registerLazySingleton(() => FirebaseCloudMessagingService());
  getIt.registerLazySingleton(() => ApiConsumer(DioFactory.getDio()));

  // 2. المستودعات (Repositories)
  // نربط العقد المجرد بالتنفيذ الفعلي
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(getIt<ApiConsumer>()),
  );

  // 3. حالات الاستخدام (UseCases)
  getIt.registerLazySingleton(() => RegisterUseCase(getIt<AuthRepo>()));

  // 4. إدارة الحالة (Cubit)
  // نستخدم registerFactory لأن الـ Cubit يجب أن يُغلق ويُنشأ من جديد مع كل فتح للشاشة
  getIt.registerFactory(() => RegisterCubit(getIt<RegisterUseCase>()));

  ////////////////////////////////////////////////////

  // 1. حقن الـ UseCase (نستخدم LazySingleton لأنه كلاس لا يحمل حالة متغيرة)
  getIt.registerLazySingleton(() => VerifyOtpUseCase(getIt<AuthRepo>()));

  // 2. حقن الـ OtpCubit (نستخدم Factory ضروري جداً هنا)
  getIt.registerFactory(
    () => VerifyForgetPasswordOtpUsecase(getIt<AuthRepo>()),
  );
  getIt.registerLazySingleton(() => ResendOtpUseCase(getIt<AuthRepo>()));
  getIt.registerLazySingleton(() => ConfirmLoginUseCase(getIt<AuthRepo>()));
  getIt.registerLazySingleton(() => DeleteAccountUseCase(getIt<AuthRepo>()));
  getIt.registerFactory(
    () => OtpCubit(
      getIt<VerifyOtpUseCase>(),
      getIt<VerifyForgetPasswordOtpUsecase>(),
      getIt<ResendOtpUseCase>(),
      getIt<ConfirmLoginUseCase>(),
    ),
  );
  // حقن LoginUseCase
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepo>()));

  // حقن LoginCubit
  getIt.registerFactory(() => LoginCubit(getIt<LoginUseCase>()));

  // --- Admin Categories ---
  getIt.registerLazySingleton<AdminCategoryRepo>(
    () => AdminCategoryRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton(
    () => AddCategoryUseCase(getIt<AdminCategoryRepo>()),
  );
  getIt.registerLazySingleton(
    () => GetCategoriesUseCase(getIt<AdminCategoryRepo>()),
  );
  getIt.registerLazySingleton(
    () => ManageCategoryUseCase(getIt<AdminCategoryRepo>()),
  );
  getIt.registerLazySingleton(
    () => AdminCategoryCubit(getIt<ManageCategoryUseCase>()),
  );
  getIt.registerLazySingleton(
    () => AdminCategoriesListCubit(getIt<ManageCategoryUseCase>()),
  );

  // ================= ADMIN OFFERS =================
  getIt.registerLazySingleton<AdminOffersRepo>(
    () => AdminOffersRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton(
    () => CreateOfferUseCase(getIt<AdminOffersRepo>()),
  );
  getIt.registerLazySingleton(
    () => ManageOffersUseCase(getIt<AdminOffersRepo>()),
  );
  getIt.registerLazySingleton(
    () => AdminOffersCubit(getIt<ManageOffersUseCase>()),
  );
  getIt.registerLazySingleton(
    () => AdminOffersListCubit(getIt<ManageOffersUseCase>()),
  );

  getIt.registerLazySingleton<AdminProductRepo>(
    () => AdminProductRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton(
    () => GetProductsUseCase(getIt<AdminProductRepo>()),
  );
  getIt.registerLazySingleton(
    () => ManageProductUseCase(getIt<AdminProductRepo>()),
  );

  getIt.registerLazySingleton(
    () => AdminProductCubit(
      getIt<ManageProductUseCase>(),
      getIt<GetCategoriesUseCase>(), // جلب الأقسام من قسم الـ Categories
    ),
  );
  getIt.registerLazySingleton(
    () => AdminProductsListCubit(
      getIt<GetProductsUseCase>(),
      getIt<ManageProductUseCase>(),
    ),
  );
  getIt.registerLazySingleton(() => ForgotPasswordUsecase(getIt<AuthRepo>()));
  getIt.registerFactory(
    () => ForgotPasswordCubit(getIt<ForgotPasswordUsecase>()),
  );
  // 1. حقن حالة الاستخدام (UseCase)
  // نستخدم LazySingleton لأنه كلاس لا يحمل حالة متغيرة (Stateless)
  getIt.registerLazySingleton(() => ResetPasswordUseCase(getIt<AuthRepo>()));

  // 2. حقن الكيوبت (Cubit)
  // نستخدم Factory لضمان إنشاء نسخة جديدة بمتحكمات فارغة في كل مرة تُفتح فيها الشاشة
  getIt.registerFactory(
    () => ResetPasswordCubit(getIt<ResetPasswordUseCase>()),
  );
  // ================= PROFILE =================
  getIt.registerLazySingleton<ProfileRepo>(
    () => ProfileRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton(() => GetProfileUseCase(getIt<ProfileRepo>()));
  getIt.registerLazySingleton(() => UpdateProfileUseCase(getIt<ProfileRepo>()));
  getIt.registerLazySingleton(
    () => ChangePasswordUseCase(getIt<ProfileRepo>()),
  );
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepo>()));
  getIt.registerFactory(
    () => ProfileCubit(
      getIt<GetProfileUseCase>(),
      getIt<UpdateProfileUseCase>(),
      getIt<ChangePasswordUseCase>(),
      getIt<DeleteAccountUseCase>(),
      getIt<LogoutUseCase>(),
    )..getProfile(),
  );

  // ================= ADDRESSES =================
  getIt.registerLazySingleton<AddressesRepo>(
    () => AddressesRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton(
    () => GetAddressesUseCase(getIt<AddressesRepo>()),
  );
  getIt.registerLazySingleton(
    () => GetAddressByIdUseCase(getIt<AddressesRepo>()),
  );
  getIt.registerLazySingleton(
    () => CreateAddressUseCase(getIt<AddressesRepo>()),
  );
  getIt.registerLazySingleton(
    () => UpdateAddressUseCase(getIt<AddressesRepo>()),
  );
  getIt.registerLazySingleton(
    () => DeleteAddressUseCase(getIt<AddressesRepo>()),
  ); // قسم العناوين
  getIt.registerLazySingleton(() => GetDefaultAddressUseCase(getIt()));
  getIt.registerLazySingleton(() => SaveDefaultAddressUseCase(getIt()));
  getIt.registerFactory(
    () => AddressesCubit(
      getIt<GetAddressesUseCase>(),
      getIt<GetAddressByIdUseCase>(),
      getIt<CreateAddressUseCase>(),
      getIt<UpdateAddressUseCase>(),
      getIt<DeleteAddressUseCase>(),
    ),
  );

  // ================= HOME & CATALOG =================
  getIt.registerLazySingleton<HomeRepo>(
    () => HomeRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton(() => GetHomeDataUseCase(getIt<HomeRepo>()));
  // استبدل السطر القديم بهذا:
  getIt.registerFactory(() => HomeCubit(getIt<GetHomeDataUseCase>()));

  // ================= PRODUCTS =================
  getIt.registerLazySingleton<ProductRepo>(
    () => ProductRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton(
    () => GetProductDetailsUseCase(getIt<ProductRepo>()),
  );
  getIt.registerFactory(() => ProductCubit(getIt<GetProductDetailsUseCase>()));

  // ================= CATEGORIES & SEARCH =================
  getIt.registerLazySingleton<UserCategoriesRepo>(
    () => UserCategoriesRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton(
    () => GetUserCategoriesUseCase(getIt<UserCategoriesRepo>()),
  );
  getIt.registerLazySingleton(
    () => GetCategoryProductsUseCase(getIt<UserCategoriesRepo>()),
  );
  // استبدل السطر القديم بهذا:
  getIt.registerFactory(
    () => UserCategoriesCubit(getIt<GetUserCategoriesUseCase>()),
  );
  getIt.registerFactory(
    () => CategoryProductsCubit(getIt<GetCategoryProductsUseCase>()),
  );
  getIt.registerFactory(() => SearchCubit(getIt<GetHomeDataUseCase>()));

  // ================= FAVORITES =================
  getIt.registerLazySingleton<FavoritesRepo>(
    () => FavoritesRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton(
    () => GetFavoritesUseCase(getIt<FavoritesRepo>()),
  );
  getIt.registerLazySingleton(
    () => ToggleFavoriteUseCase(getIt<FavoritesRepo>()),
  );
  // استبدل السطر القديم بهذا:
  getIt.registerLazySingleton(
    () => FavoritesCubit(
      getIt<GetFavoritesUseCase>(),
      getIt<ToggleFavoriteUseCase>(),
    )..fetchFavorites(),
  );

  // ================= CART =================
  getIt.registerLazySingleton<CartRepo>(
    () => CartRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton(() => GetCartUseCase(getIt<CartRepo>()));
  getIt.registerLazySingleton(() => AddToCartUseCase(getIt<CartRepo>()));
  getIt.registerLazySingleton(
    () => UpdateCartQuantityUseCase(getIt<CartRepo>()),
  );
  getIt.registerLazySingleton(() => DeleteFromCartUseCase(getIt<CartRepo>()));
  // استبدل السطر القديم بهذا:
  getIt.registerLazySingleton(
    () => CartCubit(
      getIt<GetCartUseCase>(),
      getIt<AddToCartUseCase>(),
      getIt<UpdateCartQuantityUseCase>(),
      getIt<DeleteFromCartUseCase>(),
    ),
  );

  // ================= ORDERS & CHECKOUT =================
  getIt.registerLazySingleton<OrdersRepo>(
    () => OrdersRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton(() => GetOrdersUseCase(getIt<OrdersRepo>()));
  getIt.registerLazySingleton(() => GetOrderByIdUseCase(getIt<OrdersRepo>()));
  getIt.registerLazySingleton(() => GetOrderPriceUseCase(getIt<OrdersRepo>()));
  getIt.registerLazySingleton(() => ConfirmOrderUseCase(getIt<OrdersRepo>()));
  getIt.registerLazySingleton(
    () => RateProductInOrderUseCase(getIt<OrdersRepo>()),
  );

  getIt.registerFactory(
    () => CheckoutCubit(
      getIt<GetOrderPriceUseCase>(),
      getIt<ConfirmOrderUseCase>(),
      getIt<GetDefaultAddressUseCase>(),
      getIt<SaveDefaultAddressUseCase>(),
    ),
  );

  // استبدل الكتلة القديمة بالكامل بهذه (مع إزالة التعليق الخاطئ):
  getIt.registerFactory(
    () => OrdersCubit(
      getIt<GetOrdersUseCase>(),
      getIt<GetOrderByIdUseCase>(),
      getIt<RateProductInOrderUseCase>(),
    ),
  );

  // --- Notifications Settings ---
  getIt.registerLazySingleton<NotificationSettingsRepo>(
    () => NotificationSettingsRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton(
    () => GetNotificationSettingsUseCase(getIt<NotificationSettingsRepo>()),
  );
  getIt.registerLazySingleton(
    () => UpdateNotificationSettingsUseCase(getIt<NotificationSettingsRepo>()),
  );
  getIt.registerFactory(
    () => NotificationSettingsCubit(
      getIt<GetNotificationSettingsUseCase>(),
      getIt<UpdateNotificationSettingsUseCase>(),
    ),
  );

  // --- Suggestions ---
  getIt.registerLazySingleton<SuggestionsRepo>(
    () => SuggestionsRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton(
    () => SendSuggestionUseCase(getIt<SuggestionsRepo>()),
  );
  getIt.registerFactory(() => SuggestionsCubit(getIt<SendSuggestionUseCase>()));

  // --- Admin Dashboard ---
  getIt.registerLazySingleton<AdminDashboardRepo>(
    () => AdminDashboardRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton(
    () => GetAdminDashboardUseCase(getIt<AdminDashboardRepo>()),
  );
  getIt.registerFactory(
    () => AdminDashboardCubit(getIt<GetAdminDashboardUseCase>()),
  );

  // --- Store Settings ---
  getIt.registerLazySingleton<StoreSettingsRepo>(
    () => StoreSettingsRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton(
    () => GetDeliveryPriceUseCase(getIt<StoreSettingsRepo>()),
  );
  getIt.registerLazySingleton(
    () => UpdateDeliveryPriceUseCase(getIt<StoreSettingsRepo>()),
  );
  getIt.registerLazySingleton(
    () => AddStoreAddressUseCase(getIt<StoreSettingsRepo>()),
  );
  getIt.registerFactory(
    () => StoreSettingsCubit(
      getIt<GetDeliveryPriceUseCase>(),
      getIt<UpdateDeliveryPriceUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => AddStoreAddressCubit(getIt<AddStoreAddressUseCase>()),
  );

  // --- Admin Orders ---
  getIt.registerLazySingleton<AdminOrdersRepo>(
    () => AdminOrdersRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton(
    () => GetAdminOrdersUseCase(getIt<AdminOrdersRepo>()),
  );
  getIt.registerLazySingleton(
    () => GetAdminOrderDetailsUseCase(getIt<AdminOrdersRepo>()),
  );
  getIt.registerLazySingleton(
    () => UpdateOrderStatusUseCase(getIt<AdminOrdersRepo>()),
  );
  getIt.registerFactory(
    () => AdminOrdersCubit(
      getIt<GetAdminOrdersUseCase>(),
      getIt<GetAdminOrderDetailsUseCase>(),
      getIt<UpdateOrderStatusUseCase>(),
    ),
  );

  // --- Admin Suggestions ---
  getIt.registerLazySingleton<AdminSuggestionsRepo>(
    () => AdminSuggestionsRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton(
    () => GetAdminSuggestionsUseCase(getIt<AdminSuggestionsRepo>()),
  );
  getIt.registerLazySingleton(
    () => UpdateSuggestionStatusUseCase(getIt<AdminSuggestionsRepo>()),
  );
  getIt.registerFactory(
    () => AdminSuggestionsCubit(
      getIt<GetAdminSuggestionsUseCase>(),
      getIt<UpdateSuggestionStatusUseCase>(),
    ),
  );
  // ==========================================
  // ميزة الإشعارات (Notifications Feature)
  // ==========================================
  getIt.registerLazySingleton(() => GetLastSeenNotificationUseCase(getIt()));
  getIt.registerLazySingleton(() => SaveLastSeenNotificationUseCase(getIt()));
  // 1. تسجيل الـ Cubit (نستخدم Factory لكي يتم إنشاء نسخة جديدة كلما فتحنا الشاشة)
  getIt.registerLazySingleton(
    () => NotificationsCubit(getIt(), getIt(), getIt()),
  );

  // 2. تسجيل الـ UseCase (نستخدم LazySingleton لأنه لا يخزن حالة)
  getIt.registerLazySingleton(() => GetNotificationsUseCase(getIt()));

  // 3. تسجيل الـ Repository
  getIt.registerLazySingleton<NotificationSettingsRepoImpl>(
    () => NotificationSettingsRepoImpl(getIt()),
    // 💡 ملاحظة: getIt() هنا سيقوم تلقائياً بجلب ApiConsumer الذي قمت بتسجيله مسبقاً في مشروعك
  );
}
