import 'package:injectable/injectable.dart';
import 'package:very_good_coffee_app/core/usecases/usecase.dart';
import 'package:very_good_coffee_app/features/coffee/domain/entities/coffee.dart';
import 'package:very_good_coffee_app/features/coffee/domain/repositories/coffee_repository.dart';

@lazySingleton
@injectable
class SaveCoffee implements UseCase<void, SaveCoffeeParams> {
  SaveCoffee(this._repository);

  final CoffeeRepository _repository;

  @override
  Future<void> call(SaveCoffeeParams params) {
    return _repository.saveCoffee(params.coffee);
  }
}

class SaveCoffeeParams {
  const SaveCoffeeParams(this.coffee);

  final Coffee coffee;
}
