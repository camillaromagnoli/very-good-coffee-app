part of 'coffee_bloc.dart';

abstract class CoffeeEvent extends Equatable {
  const CoffeeEvent();

  @override
  List<Object?> get props => [];
}

class CoffeeRequested extends CoffeeEvent {
  const CoffeeRequested();
}

class CoffeeSaved extends CoffeeEvent {
  const CoffeeSaved();
}
