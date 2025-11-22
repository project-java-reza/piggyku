// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:finai_frontend/app/data/data_sources/auth_data_source.dart'
    as _i318;
import 'package:finai_frontend/app/data/repositories/auth_repository_impl.dart'
    as _i1060;
import 'package:finai_frontend/app/domain/entities/global.dart' as _i457;
import 'package:finai_frontend/app/domain/repositories/auth_repository.dart'
    as _i323;
import 'package:finai_frontend/app/domain/use_cases/auth/login.dart' as _i958;
import 'package:finai_frontend/core/helper/api_helper.dart' as _i445;
import 'package:finai_frontend/core/services/api_service.dart' as _i662;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.lazySingleton<_i445.ApiHelper>(() => _i445.ApiHelper());
  gh.lazySingleton<_i662.ApiService>(() => _i662.ApiService());
  gh.lazySingleton<_i457.Global>(() => _i457.Global());
  gh.lazySingleton<_i318.AuthDataSource>(() => _i318.AuthDataSourceImpl());
  gh.lazySingleton<_i323.AuthRepository>(
      () => _i1060.AuthRepositoryImpl(gh<_i318.AuthDataSource>()));
  gh.lazySingleton<_i958.Login>(() => _i958.Login(gh<_i323.AuthRepository>()));
  return getIt;
}
