import 'package:mocktail/mocktail.dart';

import 'package:very_good_coffee_app/features/coffee/domain/usecases/get_coffee.dart';
import 'package:very_good_coffee_app/features/coffee/domain/usecases/get_favorite_coffees.dart';
import 'package:very_good_coffee_app/features/coffee/domain/usecases/save_coffee.dart';

class MockGetCoffee extends Mock implements GetCoffee {}

class MockGetFavoriteCoffees extends Mock implements GetFavoriteCoffees {}

class MockSaveCoffee extends Mock implements SaveCoffee {}
