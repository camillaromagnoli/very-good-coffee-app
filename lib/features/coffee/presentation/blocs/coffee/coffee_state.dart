part of 'coffee_bloc.dart';

enum CoffeeStatus { initial, loading, success, failure }

enum SaveStatus { initial, saving, success, failure }

class CoffeeState extends Equatable {
  const CoffeeState({
    required this.status,
    required this.coffee,
    required this.failure,
    required this.saveStatus,
    required this.saveFailure,
  });

  const CoffeeState.initial()
    : status = CoffeeStatus.initial,
      coffee = null,
      failure = null,
      saveStatus = SaveStatus.initial,
      saveFailure = null;

  final CoffeeStatus status;
  final Coffee? coffee;
  final Failure? failure;

  final SaveStatus saveStatus;
  final Failure? saveFailure;

  CoffeeState copyWith({
    CoffeeStatus? status,
    Coffee? coffee,
    Failure? failure,
    SaveStatus? saveStatus,
    Failure? saveFailure,
  }) {
    return CoffeeState(
      status: status ?? this.status,
      coffee: coffee ?? this.coffee,
      failure: failure ?? this.failure,
      saveStatus: saveStatus ?? this.saveStatus,
      saveFailure: saveFailure ?? this.saveFailure,
    );
  }

  @override
  List<Object?> get props => [status, coffee, failure, saveStatus, saveFailure];
}
