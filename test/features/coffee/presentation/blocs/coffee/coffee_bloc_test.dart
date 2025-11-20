import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:very_good_coffee_app/core/errors/exceptions.dart';
import 'package:very_good_coffee_app/core/usecases/usecase.dart';
import 'package:very_good_coffee_app/features/coffee/domain/entities/coffee.dart';
import 'package:very_good_coffee_app/features/coffee/domain/usecases/save_coffee.dart';
import 'package:very_good_coffee_app/features/coffee/presentation/blocs/coffee/coffee_bloc.dart';
import '../../../../../mocks/mocks.dart';

void main() {
  late CoffeeBloc bloc;
  late MockGetCoffee mockGetCoffee;
  late MockSaveCoffee mockSaveCoffee;

  final tCoffee = Coffee(
    id: '1',
    imageUrl: 'https://example.com/coffee.jpg',
    imageBytes: Uint8List.fromList([1, 2, 3]),
  );

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(SaveCoffeeParams(tCoffee));
  });

  setUp(() {
    mockGetCoffee = MockGetCoffee();
    mockSaveCoffee = MockSaveCoffee();
    bloc = CoffeeBloc(getCoffee: mockGetCoffee, saveCoffee: mockSaveCoffee);
  });

  tearDown(() {
    bloc.close();
  });

  group('CoffeeBloc', () {
    group('_onCoffeeSaved', () {
      test('should emit saveSuccess when saveCoffee succeeds', () async {
        bloc.emit(
          CoffeeState(
            status: CoffeeStatus.success,
            coffee: tCoffee,
            failure: null,
            saveStatus: SaveStatus.initial,
            saveFailure: null,
          ),
        );

        when(() => mockSaveCoffee(any())).thenAnswer((_) async {});

        bloc.add(const CoffeeSaved());

        await expectLater(
          bloc.stream,
          emitsInOrder([
            predicate<CoffeeState>(
              (state) =>
                  state.saveStatus == SaveStatus.saving &&
                  state.saveFailure == null,
            ),
            predicate<CoffeeState>(
              (state) =>
                  state.saveStatus == SaveStatus.success &&
                  state.saveFailure == null,
            ),
          ]),
        );

        verify(() => mockSaveCoffee(any())).called(1);
      });

      test('should emit saveFailure when saveCoffee throws Failure', () async {
        final failure = CacheException('Failed to save');
        bloc.emit(
          CoffeeState(
            status: CoffeeStatus.success,
            coffee: tCoffee,
            failure: null,
            saveStatus: SaveStatus.initial,
            saveFailure: null,
          ),
        );

        when(() => mockSaveCoffee(any())).thenThrow(failure);

        bloc.add(const CoffeeSaved());

        await expectLater(
          bloc.stream,
          emitsInOrder([
            predicate<CoffeeState>(
              (state) =>
                  state.saveStatus == SaveStatus.saving &&
                  state.saveFailure == null,
            ),
            predicate<CoffeeState>(
              (state) =>
                  state.saveStatus == SaveStatus.failure &&
                  state.saveFailure == failure,
            ),
          ]),
        );

        verify(() => mockSaveCoffee(any())).called(1);
      });

      test(
        'should emit saveFailure when saveCoffee throws generic exception',
        () async {
          bloc.emit(
            CoffeeState(
              status: CoffeeStatus.success,
              coffee: tCoffee,
              failure: null,
              saveStatus: SaveStatus.initial,
              saveFailure: null,
            ),
          );

          when(
            () => mockSaveCoffee(any()),
          ).thenThrow(Exception('Unexpected error'));

          bloc.add(const CoffeeSaved());

          await expectLater(
            bloc.stream,
            emitsInOrder([
              predicate<CoffeeState>(
                (state) =>
                    state.saveStatus == SaveStatus.saving &&
                    state.saveFailure == null,
              ),
              predicate<CoffeeState>(
                (state) =>
                    state.saveStatus == SaveStatus.failure &&
                    state.saveFailure != null &&
                    state.saveFailure?.message == 'Exception: Unexpected error',
              ),
            ]),
          );

          verify(() => mockSaveCoffee(any())).called(1);
        },
      );

      test('should not call saveCoffee when coffee is null', () async {
        bloc.emit(
          const CoffeeState(
            status: CoffeeStatus.success,
            coffee: null,
            failure: null,
            saveStatus: SaveStatus.initial,
            saveFailure: null,
          ),
        );

        bloc.add(const CoffeeSaved());
        await Future.delayed(const Duration(milliseconds: 100));

        verifyNever(() => mockSaveCoffee(any()));
      });

      test(
        'should emit saveStatus saving then success during save operation',
        () async {
          bloc.emit(
            CoffeeState(
              status: CoffeeStatus.success,
              coffee: tCoffee,
              failure: null,
              saveStatus: SaveStatus.initial,
              saveFailure: null,
            ),
          );

          when(() => mockSaveCoffee(any())).thenAnswer((_) async {
            await Future.delayed(const Duration(milliseconds: 50));
          });

          bloc.add(const CoffeeSaved());

          await expectLater(
            bloc.stream,
            emitsInOrder([
              predicate<CoffeeState>(
                (state) =>
                    state.saveStatus == SaveStatus.saving &&
                    state.saveFailure == null,
              ),
              predicate<CoffeeState>(
                (state) =>
                    state.saveStatus == SaveStatus.success &&
                    state.saveFailure == null,
              ),
            ]),
          );
        },
      );
    });
  });
}
