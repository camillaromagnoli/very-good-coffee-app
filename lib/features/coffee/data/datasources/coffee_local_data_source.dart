import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_coffee_app/core/errors/exceptions.dart';
import 'package:very_good_coffee_app/features/coffee/data/models/coffee_model.dart';

abstract class CoffeeLocalDataSource {
  Future<void> saveCoffee(CoffeeModel coffee);

  Future<List<CoffeeModel>> getSavedCoffees();
}

@lazySingleton
@Injectable(as: CoffeeLocalDataSource)
class CoffeeLocalDataSourceImpl implements CoffeeLocalDataSource {
  CoffeeLocalDataSourceImpl(this._box);

  final Box<Map> _box;

  @override
  Future<void> saveCoffee(CoffeeModel coffee) async {
    try {
      await _box.put(coffee.id, coffee.toJson());
      await _box.flush();
    } catch (e) {
      throw CacheException('Failed to save coffee: ${e.toString()}');
    }
  }

  @override
  Future<List<CoffeeModel>> getSavedCoffees() async {
    try {
      if (!_box.isOpen) {
        throw CacheException(
          'Hive box is not open. Ensure Hive is initialized before accessing favorites.',
        );
      }

      final values = _box.values.toList();
      final coffees = <CoffeeModel>[];
      for (final json in values) {
        try {
          final Map<String, dynamic> jsonMap = Map<String, dynamic>.from(json);
          final coffee = CoffeeModel.fromJson(jsonMap);
          coffees.add(coffee);
        } catch (e) {
          continue;
        }
      }

      return coffees;
    } catch (e) {
      if (e is CacheException) {
        rethrow;
      }
      throw CacheException('Failed to load saved coffees: ${e.toString()}');
    }
  }
}
