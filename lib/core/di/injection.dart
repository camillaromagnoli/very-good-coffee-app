import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../../features/coffee/data/datasources/coffee_local_data_source.dart';
import '../../../features/coffee/data/datasources/coffee_remote_data_source.dart';
import '../../../features/coffee/data/repositories/coffee_repository_impl.dart';
import '../../../features/coffee/domain/repositories/coffee_repository.dart';
import 'injection.config.dart';

final GetIt sl = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  await sl.init();

  sl.registerLazySingleton<CoffeeRemoteDataSource>(
    () => sl<CoffeeRemoteDataSourceImpl>(),
  );
  sl.registerLazySingleton<CoffeeLocalDataSource>(
    () => sl<CoffeeLocalDataSourceImpl>(),
  );
  sl.registerLazySingleton<CoffeeRepository>(() => sl<CoffeeRepositoryImpl>());
}
