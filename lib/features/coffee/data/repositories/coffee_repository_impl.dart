import 'package:injectable/injectable.dart';
import 'package:very_good_coffee_app/core/errors/exceptions.dart';
import 'package:very_good_coffee_app/features/coffee/data/datasources/coffee_local_data_source.dart';
import 'package:very_good_coffee_app/features/coffee/data/datasources/coffee_remote_data_source.dart';
import 'package:very_good_coffee_app/features/coffee/data/models/coffee_model.dart';
import 'package:very_good_coffee_app/features/coffee/domain/entities/coffee.dart';
import 'package:very_good_coffee_app/features/coffee/domain/repositories/coffee_repository.dart';

@lazySingleton
@Injectable(as: CoffeeRepository)
class CoffeeRepositoryImpl implements CoffeeRepository {
  CoffeeRepositoryImpl(this._remoteDataSource, this._localDataSource);

  final CoffeeRemoteDataSource _remoteDataSource;
  final CoffeeLocalDataSource _localDataSource;

  @override
  Future<Coffee> getCoffee() async {
    try {
      final coffee = await _remoteDataSource.getCoffee();
      return coffee.toEntity();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> saveCoffee(Coffee coffee) async {
    try {
      final model = CoffeeModel.fromEntity(coffee);

      await _localDataSource.saveCoffee(model);
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<List<Coffee>> getSavedCoffees() async {
    try {
      final models = await _localDataSource.getSavedCoffees();
      return models.map((m) => m.toEntity()).toList();
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
}
