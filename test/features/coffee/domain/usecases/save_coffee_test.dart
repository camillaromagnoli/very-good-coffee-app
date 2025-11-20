import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:very_good_coffee_app/core/errors/exceptions.dart';
import 'package:very_good_coffee_app/features/coffee/domain/entities/coffee.dart';
import 'package:very_good_coffee_app/features/coffee/domain/usecases/save_coffee.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SaveCoffee usecase;
  late MockCoffeeRepository mockRepository;

  final tCoffee = Coffee(
    id: '1',
    imageUrl: 'https://example.com/coffee.jpg',
    imageBytes: Uint8List.fromList([1, 2, 3]),
  );

  setUpAll(() {
    registerFallbackValue(tCoffee);
  });

  setUp(() {
    mockRepository = MockCoffeeRepository();
    usecase = SaveCoffee(mockRepository);
  });

  test('should save coffee to the repository', () async {
    when(() => mockRepository.saveCoffee(any())).thenAnswer((_) async => {});

      await usecase(SaveCoffeeParams(tCoffee));

      verify(() => mockRepository.saveCoffee(tCoffee)).called(1);
      verifyNoMoreInteractions(mockRepository);
  });

  test('should throw CacheException when repository fails', () async {
    when(
      () => mockRepository.saveCoffee(any()),
    ).thenThrow(CacheException('Test error'));

      final call = usecase;

      expect(
        () => call(SaveCoffeeParams(tCoffee)),
      throwsA(isA<CacheException>()),
      );
      verify(() => mockRepository.saveCoffee(tCoffee)).called(1);
      verifyNoMoreInteractions(mockRepository);
  });
}
