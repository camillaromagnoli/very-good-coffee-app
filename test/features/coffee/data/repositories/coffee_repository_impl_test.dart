import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:very_good_coffee_app/core/errors/exceptions.dart';
import 'package:very_good_coffee_app/features/coffee/data/models/coffee_model.dart';
import 'package:very_good_coffee_app/features/coffee/data/repositories/coffee_repository_impl.dart';
import 'package:very_good_coffee_app/features/coffee/domain/entities/coffee.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late CoffeeRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;

  setUpAll(() {
    registerFallbackValue(
      CoffeeModel(
        id: 'fallback',
        imageUrl: 'https://example.com/fallback.jpg',
        imageBytes: Uint8List.fromList([]),
      ),
    );
  });

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    repository = CoffeeRepositoryImpl(
      mockRemoteDataSource,
      mockLocalDataSource,
    );
  });

  group('getCoffee', () {
    final tCoffeeModel = CoffeeModel(
      id: '1',
      imageUrl: 'https://example.com/coffee.jpg',
      imageBytes: Uint8List.fromList([1, 2, 3]),
    );
    final tCoffee = tCoffeeModel.toEntity();

    test(
      'should return Coffee when the call to remote data source is successful',
      () async {
        when(
          () => mockRemoteDataSource.getCoffee(),
        ).thenAnswer((_) async => tCoffeeModel);

        final result = await repository.getCoffee();

        expect(result, equals(tCoffee));
        verify(() => mockRemoteDataSource.getCoffee()).called(1);
      },
    );

    test(
      'should throw ServerException when the call to remote data source is unsuccessful',
      () async {
        when(
          () => mockRemoteDataSource.getCoffee(),
        ).thenThrow(ServerException('Test error'));

        final call = repository.getCoffee;

        expect(() => call(), throwsA(isA<ServerException>()));
        verify(() => mockRemoteDataSource.getCoffee()).called(1);
        verifyZeroInteractions(mockLocalDataSource);
      },
    );

    test('should rethrow any exception from remote data source', () async {
      when(
        () => mockRemoteDataSource.getCoffee(),
      ).thenThrow(Exception('Unexpected error'));

      final call = repository.getCoffee;

      expect(() => call(), throwsA(isA<Exception>()));
      verify(() => mockRemoteDataSource.getCoffee()).called(1);
      verifyZeroInteractions(mockLocalDataSource);
    });
  });

  group('saveCoffee', () {
    final tCoffee = Coffee(
      id: '1',
      imageUrl: 'https://example.com/coffee.jpg',
      imageBytes: Uint8List.fromList([1, 2, 3]),
    );

    test('should complete successfully when save is successful', () async {
      when(
        () => mockLocalDataSource.saveCoffee(any()),
      ).thenAnswer((_) async => {});

      await repository.saveCoffee(tCoffee);

      verify(() => mockLocalDataSource.saveCoffee(any())).called(1);
    });

    test('should throw CacheException when save fails', () async {
      when(
        () => mockLocalDataSource.saveCoffee(any()),
      ).thenThrow(CacheException('Test error'));

      final call = repository.saveCoffee;

      expect(() => call(tCoffee), throwsA(isA<CacheException>()));
      verify(() => mockLocalDataSource.saveCoffee(any())).called(1);
    });
  });

  group('getSavedCoffees', () {
    final tCoffeeModel1 = CoffeeModel(
      id: '1',
      imageUrl: 'https://example.com/coffee1.jpg',
      imageBytes: Uint8List.fromList([1, 2, 3]),
    );
    final tCoffeeModel2 = CoffeeModel(
      id: '2',
      imageUrl: 'https://example.com/coffee2.jpg',
      imageBytes: Uint8List.fromList([4, 5, 6]),
    );
    final tCoffees = [tCoffeeModel1.toEntity(), tCoffeeModel2.toEntity()];

    test('should return list of Coffee when the call is successful', () async {
      when(
        () => mockLocalDataSource.getSavedCoffees(),
      ).thenAnswer((_) async => [tCoffeeModel1, tCoffeeModel2]);

      final result = await repository.getSavedCoffees();

      expect(result, equals(tCoffees));
      verify(() => mockLocalDataSource.getSavedCoffees()).called(1);
    });

    test('should throw CacheException when the call fails', () async {
      when(
        () => mockLocalDataSource.getSavedCoffees(),
      ).thenThrow(CacheException('Test error'));

      final call = repository.getSavedCoffees;

      expect(() => call(), throwsA(isA<CacheException>()));
      verify(() => mockLocalDataSource.getSavedCoffees()).called(1);
    });
  });
}
