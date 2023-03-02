
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_with_clean_arch/config/global/localize/localization/data/data_source/lang_locale_data_source.dart';
import 'package:shop_with_clean_arch/config/global/localize/localization/data/repository/lang_repository.dart';
import 'package:shop_with_clean_arch/config/global/localize/localization/domain/repository/base_lang_repository.dart';
import 'package:shop_with_clean_arch/config/global/localize/localization/domain/use_case/change_lang_use_case.dart';
import 'package:shop_with_clean_arch/config/global/localize/localization/domain/use_case/save_lang.dart';
import 'package:shop_with_clean_arch/config/global/localize/localization/presentation/controller/locale_cubit.dart';
import 'package:shop_with_clean_arch/config/global/theme/cubit/cubit.dart';
import 'package:shop_with_clean_arch/core/api/api_consumer.dart';
import 'package:shop_with_clean_arch/core/api/app_interceptor.dart';
import 'package:shop_with_clean_arch/core/api/dio_consumer.dart';
import 'package:shop_with_clean_arch/shop_app/auth/data/data_source/auth_data_source.dart';
import 'package:shop_with_clean_arch/shop_app/auth/data/repository/auth_repository.dart';
import 'package:shop_with_clean_arch/shop_app/auth/domain/repository/base_auth_repository.dart';
import 'package:shop_with_clean_arch/shop_app/auth/domain/use_case/login_use_case.dart';
import 'package:shop_with_clean_arch/shop_app/auth/domain/use_case/register_use_case.dart';
import 'package:shop_with_clean_arch/shop_app/auth/presentation/controller/login_bloc.dart';
import 'package:shop_with_clean_arch/shop_app/auth/presentation/controller/register_cubit.dart';

final sl=GetIt.instance;
class ServicesLocator {
  Future<void> init() async{
    // Blocs
    sl.registerFactory(() => LoginCubit(sl()));
    sl.registerFactory(() => RegisterCubit(sl()));
    sl.registerFactory(() => ThemeCubit());
    sl.registerFactory<LocaleCubit>(
            () => LocaleCubit(getSavedLangUseCase: sl(), changeLangUseCase: sl()));

    sl.registerLazySingleton(() => LoginUseCase(sl()));
    sl.registerLazySingleton(() => RegisterUseCase(sl()));
    sl.registerLazySingleton<GetSavedLangUseCase>(
            () => GetSavedLangUseCase(langRepository: sl()));
    sl.registerLazySingleton<ChangeLangUseCase>(
            () => ChangeLangUseCase(langRepository: sl()));

    sl.registerLazySingleton<BaseAuthRepository>(() => AuthRepository(sl()));
    sl.registerLazySingleton<LangRepository>(
            () => LangRepositoryImpl(langLocalDataSource: sl()));


    sl.registerLazySingleton<BaseAuthDataSource>(() =>
        AuthDataSource(sl()));
    sl.registerLazySingleton<LangLocalDataSource>(
            () => LangLocalDataSourceImpl(sharedPreferences: sl()));
    sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(client: sl()));
    sl.registerLazySingleton(() => AppIntercepters(sl()));
    sl.registerLazySingleton(() =>
        LogInterceptor(
            request: true,
            requestBody: true,
            requestHeader: true,
            responseBody: true,
            responseHeader: true,
            error: true));
    sl.registerLazySingleton(()  =>  Dio());

    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton(() => sharedPreferences);
    final cacheHelper =  CacheHelper(sharedPreferences: sl());
    sl.registerLazySingleton(() => cacheHelper);
  }
}
