import 'package:get_it/get_it.dart';
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
import 'package:primo/feature/auth/domain/usecases/login_usecase.dart';
import 'package:primo/feature/auth/domain/usecases/register_usecase.dart';
import 'package:primo/feature/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:primo/feature/auth/presentation/cubit/login_cubit.dart';
import 'package:primo/feature/auth/presentation/cubit/otp_cubit.dart';
import 'package:primo/feature/auth/presentation/cubit/register_cubit.dart';
import '../network/api_consumer.dart';
import '../network/dio_factory.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // 1. النواة والشبكة (Core / Network)
  // كائن جلب الـ Dio كمثيل وحيد مستقر
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
  getIt.registerFactory(() => OtpCubit(getIt<VerifyOtpUseCase>()));
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
  getIt.registerFactory(() => AdminCategoryCubit(getIt<AddCategoryUseCase>()));

  // ================= ADMIN OFFERS =================
  getIt.registerLazySingleton<AdminOffersRepo>(
    () => AdminOffersRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton(
    () => CreateOfferUseCase(getIt<AdminOffersRepo>()),
  );
  getIt.registerFactory(() => AdminOffersCubit(getIt<CreateOfferUseCase>()));

  getIt.registerLazySingleton<AdminProductRepo>(
    () => AdminProductRepoImpl(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton(
    () => GetProductsUseCase(getIt<AdminProductRepo>()),
  );
  getIt.registerLazySingleton(
    () => ManageProductUseCase(getIt<AdminProductRepo>()),
  );

  getIt.registerFactory(
    () => AdminProductCubit(
      getIt<ManageProductUseCase>(),
      getIt<GetCategoriesUseCase>(), // جلب الأقسام من قسم الـ Categories
    ),
  );
}
