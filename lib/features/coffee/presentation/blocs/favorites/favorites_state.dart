part of 'favorites_bloc.dart';

enum FavoritesStatus { initial, loading, success, failure }

class FavoritesState extends Equatable {
  const FavoritesState({
    required this.status,
    required this.coffees,
    required this.failure,
  });

  const FavoritesState.initial()
    : status = FavoritesStatus.initial,
      coffees = const [],
      failure = null;

  final FavoritesStatus status;
  final List<Coffee> coffees;
  final Failure? failure;

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<Coffee>? coffees,
    Failure? failure,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      coffees: coffees ?? this.coffees,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, coffees, failure];
}
