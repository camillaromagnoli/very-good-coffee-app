import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_coffee_app/core/errors/exceptions.dart';
import 'package:very_good_coffee_app/core/usecases/usecase.dart';
import 'package:very_good_coffee_app/features/coffee/domain/entities/coffee.dart';
import 'package:very_good_coffee_app/features/coffee/domain/usecases/get_favorite_coffees.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

@injectable
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc({required GetFavoriteCoffees getFavoriteCoffees})
    : _getFavoriteCoffees = getFavoriteCoffees,
      super(const FavoritesState.initial()) {
    on<FavoritesRequested>(_onFavoritesRequested);
  }

  final GetFavoriteCoffees _getFavoriteCoffees;

  Future<void> _onFavoritesRequested(
    FavoritesRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(state.copyWith(status: FavoritesStatus.loading, failure: null));
    try {
      final coffees = await _getFavoriteCoffees(const NoParams());
      emit(state.copyWith(status: FavoritesStatus.success, coffees: coffees));
    } on Failure catch (failure) {
      emit(state.copyWith(status: FavoritesStatus.failure, failure: failure));
    } catch (e) {
      emit(
        state.copyWith(
          status: FavoritesStatus.failure,
          failure: Failure(e.toString()),
        ),
      );
    }
  }
}
