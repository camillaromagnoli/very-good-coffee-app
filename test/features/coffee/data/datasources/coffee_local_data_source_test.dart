import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:very_good_coffee_app/core/errors/exceptions.dart';
import 'package:very_good_coffee_app/features/coffee/data/datasources/coffee_local_data_source.dart';
import 'package:very_good_coffee_app/features/coffee/data/models/coffee_model.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late CoffeeLocalDataSourceImpl dataSource;
  late MockBox mockBox;

  setUp(() {
    mockBox = MockBox();
    dataSource = CoffeeLocalDataSourceImpl(mockBox);
  });

  group('saveCoffee', () {
    final tCoffeeModel = CoffeeModel(
      id: '1',
      imageUrl: 'https://example.com/coffee.jpg',
      imageBytes: Uint8List.fromList([1, 2, 3]),
    );

    test('should save coffee successfully', () async {
      when(() => mockBox.isOpen).thenReturn(true);
      when(() => mockBox.path).thenReturn('/test/path');
      when(() => mockBox.keys).thenReturn([tCoffeeModel.id]);
      when(() => mockBox.length).thenReturn(1);
      when(() => mockBox.put(any(), any())).thenAnswer((_) async => {});
      when(() => mockBox.flush()).thenAnswer((_) async => {});

      await dataSource.saveCoffee(tCoffeeModel);

      verify(
        () => mockBox.put(tCoffeeModel.id, tCoffeeModel.toJson()),
      ).called(1);
      verify(() => mockBox.flush()).called(1);
    });

    test('should throw CacheException when save fails', () async {
      when(() => mockBox.isOpen).thenReturn(true);
      when(() => mockBox.path).thenReturn('/test/path');
      when(() => mockBox.keys).thenReturn([]);
      when(() => mockBox.length).thenReturn(0);
      when(() => mockBox.put(any(), any())).thenThrow(Exception());

      final call = dataSource.saveCoffee;

      expect(() => call(tCoffeeModel), throwsA(isA<CacheException>()));
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

    test(
      'should return list of CoffeeModel when the call is successful',
      () async {
        when(() => mockBox.isOpen).thenReturn(true);
        when(() => mockBox.path).thenReturn('/test/path');
        when(
          () => mockBox.keys,
        ).thenReturn([tCoffeeModel1.id, tCoffeeModel2.id]);
        when(() => mockBox.length).thenReturn(2);
        when(
          () => mockBox.values,
        ).thenReturn([tCoffeeModel1.toJson(), tCoffeeModel2.toJson()]);

        final result = await dataSource.getSavedCoffees();

        expect(result, isA<List<CoffeeModel>>());
        expect(result.length, equals(2));
        expect(result[0].id, equals(tCoffeeModel1.id));
        expect(result[1].id, equals(tCoffeeModel2.id));
      },
    );

    test('should throw CacheException when get fails', () async {
      when(() => mockBox.isOpen).thenReturn(true);
      when(() => mockBox.path).thenReturn('/test/path');
      when(() => mockBox.keys).thenReturn([]);
      when(() => mockBox.length).thenReturn(0);
      when(() => mockBox.values).thenThrow(Exception());

      final call = dataSource.getSavedCoffees;

      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });
}
