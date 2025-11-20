// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive/hive.dart' as _i979;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/coffee/data/datasources/coffee_local_data_source.dart'
    as _i668;
import '../../features/coffee/data/datasources/coffee_remote_data_source.dart'
    as _i439;
import '../../features/coffee/data/repositories/coffee_repository_impl.dart'
    as _i718;
import '../../features/coffee/domain/repositories/coffee_repository.dart'
    as _i449;
import '../../features/coffee/domain/usecases/get_coffee.dart' as _i175;
import '../../features/coffee/domain/usecases/get_favorite_coffees.dart'
    as _i549;
import '../../features/coffee/domain/usecases/save_coffee.dart' as _i446;
import '../../features/coffee/presentation/blocs/coffee/coffee_bloc.dart'
    as _i1015;
import '../../features/coffee/presentation/blocs/favorites/favorites_bloc.dart'
    as _i480;
import 'app_module.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    gh.lazySingleton<_i361.Dio>(() => appModule.dio);
    await gh.lazySingletonAsync<_i979.Box<Map<dynamic, dynamic>>>(
      () => appModule.favoritesBox,
      preResolve: true,
    );
    gh.lazySingleton<_i668.CoffeeLocalDataSourceImpl>(() =>
        _i668.CoffeeLocalDataSourceImpl(
            gh<_i979.Box<Map<dynamic, dynamic>>>()));
    gh.lazySingleton<_i439.CoffeeRemoteDataSourceImpl>(
        () => _i439.CoffeeRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i718.CoffeeRepositoryImpl>(
        () => _i718.CoffeeRepositoryImpl(
              gh<_i439.CoffeeRemoteDataSource>(),
              gh<_i668.CoffeeLocalDataSource>(),
            ));
    gh.lazySingleton<_i175.GetCoffee>(
        () => _i175.GetCoffee(gh<_i449.CoffeeRepository>()));
    gh.lazySingleton<_i549.GetFavoriteCoffees>(
        () => _i549.GetFavoriteCoffees(gh<_i449.CoffeeRepository>()));
    gh.lazySingleton<_i446.SaveCoffee>(
        () => _i446.SaveCoffee(gh<_i449.CoffeeRepository>()));
    gh.factory<_i1015.CoffeeBloc>(() => _i1015.CoffeeBloc(
          getCoffee: gh<_i175.GetCoffee>(),
          saveCoffee: gh<_i446.SaveCoffee>(),
        ));
    gh.factory<_i480.FavoritesBloc>(() => _i480.FavoritesBloc(
        getFavoriteCoffees: gh<_i549.GetFavoriteCoffees>()));
    return this;
  }
}

class _$AppModule extends _i460.AppModule {}
