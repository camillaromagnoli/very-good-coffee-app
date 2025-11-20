import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_coffee_app/core/errors/exceptions.dart';
import 'package:very_good_coffee_app/core/usecases/usecase.dart';
import 'package:very_good_coffee_app/features/coffee/domain/entities/coffee.dart';
import 'package:very_good_coffee_app/features/coffee/domain/usecases/get_coffee.dart';
import 'package:very_good_coffee_app/features/coffee/domain/usecases/save_coffee.dart';

part 'coffee_event.dart';
part 'coffee_state.dart';

@injectable
class CoffeeBloc extends Bloc<CoffeeEvent, CoffeeState> {
  CoffeeBloc({required GetCoffee getCoffee, required SaveCoffee saveCoffee})
    : _getCoffee = getCoffee,
      _saveCoffee = saveCoffee,
      super(const CoffeeState.initial()) {
    on<CoffeeRequested>(_onCoffeeRequested);
    on<CoffeeSaved>(_onCoffeeSaved);
  }

  final GetCoffee _getCoffee;
  final SaveCoffee _saveCoffee;

  Future<void> _onCoffeeRequested(
    CoffeeEvent event,
    Emitter<CoffeeState> emit,
  ) async {
    emit(state.copyWith(status: CoffeeStatus.loading, failure: null));
    try {
      final coffee = await _getCoffee(const NoParams());
      emit(state.copyWith(status: CoffeeStatus.success, coffee: coffee));
    } on Failure catch (failure) {
      emit(state.copyWith(status: CoffeeStatus.failure, failure: failure));
    } catch (e) {
      emit(
        state.copyWith(
          status: CoffeeStatus.failure,
          failure: Failure(e.toString()),
        ),
      );
    }
  }

  Future<void> _onCoffeeSaved(
    CoffeeSaved event,
    Emitter<CoffeeState> emit,
  ) async {
    final currentCoffee = state.coffee;
    if (currentCoffee == null) {
      return;
    }

    emit(state.copyWith(saveStatus: SaveStatus.saving, saveFailure: null));

    try {
      await _saveCoffee(SaveCoffeeParams(currentCoffee));
      emit(state.copyWith(saveStatus: SaveStatus.success));
    } on Failure catch (failure) {
      emit(
        state.copyWith(saveStatus: SaveStatus.failure, saveFailure: failure),
      );
    } catch (e) {
      emit(
        state.copyWith(
          saveStatus: SaveStatus.failure,
          saveFailure: Failure(e.toString()),
        ),
      );
    }
  }
}
