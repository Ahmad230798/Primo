import 'package:get_it/get_it.dart';
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
}
