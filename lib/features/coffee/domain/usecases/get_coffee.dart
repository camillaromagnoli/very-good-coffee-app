import 'package:injectable/injectable.dart';
import 'package:very_good_coffee_app/core/usecases/usecase.dart';
import 'package:very_good_coffee_app/features/coffee/domain/entities/coffee.dart';
import 'package:very_good_coffee_app/features/coffee/domain/repositories/coffee_repository.dart';

@lazySingleton
@injectable
class GetCoffee implements UseCase<Coffee, NoParams> {
  GetCoffee(this._repository);

  final CoffeeRepository _repository;

  @override
  Future<Coffee> call(NoParams params) {
    return _repository.getCoffee();
  }
}
