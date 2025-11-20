import 'package:injectable/injectable.dart';
import 'package:very_good_coffee_app/core/usecases/usecase.dart';
import 'package:very_good_coffee_app/features/coffee/domain/entities/coffee.dart';
import 'package:very_good_coffee_app/features/coffee/domain/repositories/coffee_repository.dart';

@lazySingleton
@injectable
class GetFavoriteCoffees implements UseCase<List<Coffee>, NoParams> {
  GetFavoriteCoffees(this._repository);

  final CoffeeRepository _repository;

  @override
  Future<List<Coffee>> call(NoParams params) {
    return _repository.getSavedCoffees();
  }
}
