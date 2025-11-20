import 'package:very_good_coffee_app/features/coffee/domain/entities/coffee.dart';

abstract class CoffeeRepository {
  Future<Coffee> getCoffee();

  Future<void> saveCoffee(Coffee coffee);

  Future<List<Coffee>> getSavedCoffees();
}
